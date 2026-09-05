#!/usr/bin/env python3
"""Inspect source text and contracts; never compile or execute IBM i code."""
from pathlib import Path
import json,re,collections,hashlib
ROOT=Path(__file__).resolve().parents[1]
C=json.loads((ROOT/'docs/specifications/shared-contract.json').read_text())
IDX=json.loads((ROOT/'docs/specifications/specification-index.json').read_text())
FILES={p.stem:json.loads(p.read_text()) for p in (ROOT/'docs/specifications/files').glob('*.json')}
issues=[];stats=[];maps={}
def check(ok,msg):
 if not ok:issues.append(msg)
def expand(lines):
 defs={x.strip().split()[-1] for x in lines if '/DEFINE ' in x};out=[]
 for x in lines:
  if '/COPY ' in x:
   name=x.split(',')[-1].strip();inc=(ROOT/'src/QRPGLESRC'/ (name+'.rpgleinc')).read_text().splitlines();enabled=True
   for row in inc:
    if '/IF DEFINED(' in row:enabled=row.split('(')[-1].split(')')[0] in defs
    elif '/ENDIF' in row:enabled=True
    elif enabled:out.append(row)
  else:out.append(x)
 return out
for p in sorted((ROOT/'src/QRPGLESRC').glob('*.rpgle')):
 name=p.stem;raw=p.read_text();lines=raw.splitlines();expanded=expand(lines);ps=next(x for x in IDX['programs'] if x['object']==name)
 check(all(len(x)<=80 and x.isascii() for x in lines),name+': columns or encoding')
 check(all(not x or (len(x)>5 and x[5] in 'HFDICOP* ') for x in lines),name+': spec type')
 check(not any('/FREE' in x.upper() or '**FREE' in x.upper() for x in lines),name+': free source')
 decls=[];struct={};current=None
 for x in expanded:
  if len(x)>5 and x[5]=='D':
   n=x[6:21].strip();k=x[23:25].strip()
   if not n:continue
   if k:decls.append(n);current=n if k=='DS' else None
   elif current:struct.setdefault(current,set()).add(n)
 dups=[n for n,c in collections.Counter(decls).items() if c>1];check(not dups,name+': duplicate D '+str(dups))
 for n,s in C['structures'].items():
  if n in decls:struct[n]={f['fieldName'] for f in s['fields']}
 for x in expanded:
  if len(x)>5 and x[5]=='D':
   n=x[6:21].strip();m=re.search(r'LIKEREC\((\w+)\)',x)
   if m:
    fmt=m.group(1);file=next((f for f,d in FILES.items() if d['recordFormats'][0]['formatName']==fmt),None)
    file={'SETLDYR':'SETLHDPF','SETLRFR':'SETLHDPF','OUTBYSR':'OUTBOXPF'}.get(fmt,file)
    if file:struct[n]={f['fieldName'] for f in next(iter(FILES[file]['fieldDefinitions'].values()))}
   m=re.search(r'LIKEDS\((\w+)\)',x)
   if m and m.group(1) in struct:struct[n]=struct[m.group(1)]
 defs={};calls=[];external=[];opcounts=collections.Counter();keydefs={};entry=[];current='ENTRY';stack=[];keycurr=None;callseq=None
 statements=[]
 for num,x in enumerate(lines,1):
  if len(x)<6 or x[5]!='C':continue
  x=x.ljust(80);f1=x[11:25].strip();op=x[25:35].strip().upper();f2=x[35:49].strip();res=x[49:63].strip();expr=x[35:80].strip()
  if op=='':
   if statements:statements[-1]['text']+=' '+expr
   continue
  opcounts[op]+=1
  statements.append({'line':num,'op':op,'f1':f1,'f2':f2,'res':res,'text':expr,'routine':current})
  if op=='BEGSR':
   current=f1;defs[f1]=num;check(not stack,name+': unclosed block before '+f1+str(stack))
  if op=='EXSR':calls.append((current,f2,num))
  if op=='CALL':callseq={'program':f2.strip("'"),'parameters':[],'line':num};external.append(callseq)
  elif op=='PARM':
   if current=='ENTRY' and not external:entry.append(res)
   elif callseq:callseq['parameters'].append(res)
  if op=='KLIST':keycurr=f1;keydefs[keycurr]=[]
  if op=='KFLD':keydefs[keycurr].append(res)
  if op in ['IF','FOR','DOW','DOU','SELECT','MONITOR']:stack.append((op,num))
  if op in ['ENDIF','ENDFOR','ENDDO','ENDSL','ENDMON']:
   expect={'ENDIF':['IF'],'ENDFOR':['FOR'],'ENDDO':['DOW','DOU'],'ENDSL':['SELECT'],'ENDMON':['MONITOR']}[op]
   check(bool(stack) and stack[-1][0] in expect,name+': block mismatch '+str(num)+' '+op+' '+str(stack[-1:]))
   if stack:stack.pop()
  if op=='ENDSR':check(not stack,name+': unclosed block in '+current+str(stack));current='AFTERSR'
 check(not stack,name+': trailing blocks')
 check(entry==[p[0] for p in C['interfaces'][name]],name+': entry ABI '+str(entry))
 for c in external:
  check(c['program'] in ps['calls'],name+': unexpected call '+c['program'])
  check(c['parameters']==[x[0] for x in C['interfaces'].get(c['program'],[])],name+': call ABI '+str(c))
 for caller,sub,line in calls:check(sub in defs,name+': unresolved EXSR '+sub+' at '+str(line))
 seen={'ENTRY'}
 while True:
  more={sub for caller,sub,_ in calls if caller in seen}
  if more<=seen:break
  seen |= more
 check(set(defs)<=seen,name+': unreachable '+str(sorted(set(defs)-seen)))
 for step in ps['steps']:check(step['routine'] in defs and step['routine'] in seen,name+': spec step missing '+step['routine'])
 check(name=='ORDMAIN' or opcounts['COMMIT']+opcounts['ROLBK']==0,name+': helper transaction boundary')
 allowed=set(decls)|set(defs)|set(keydefs)|set(ps['files'])|{d['recordFormats'][0]['formatName'] for d in FILES.values()}|{'SETLDYR','SETLRFR','OUTBYSR'}
 unknown=set();fieldbad=set()
 words={'AND','OR','NOT','TO','DOWNTO','BY','ON','OFF','INLR','BLANKS','ZERO','ZEROS','LOVAL','HIVAL','ISO0','ISO','D','ENTRY'}
 for s in statements:
  if s['op'] not in ['EVAL','IF','DOW','DOU','FOR','WHEN','ELSEIF',''] :continue
  expr=re.sub(r"'(?:[^']|'')*'",' ',s['text'])
  for m in re.finditer(r'\b([A-Za-z][A-Za-z0-9_]*)(?:\([^()]*\))?\.(\w+)',expr):
   b,f=m.groups()
   if b not in struct or f not in struct[b]:fieldbad.add(b+'.'+f)
  for m in re.finditer(r'\b[A-Za-z][A-Za-z0-9_]*',expr):
   tok=m.group();before=expr[m.start()-1] if m.start()>0 else ''
   if before in ['%','.','*']:continue
   if tok.upper() not in words and tok not in allowed:unknown.add(tok)
 check(not fieldbad,name+': field refs '+str(sorted(fieldbad)))
 check(not unknown,name+': unknown symbols '+str(sorted(unknown)))
 # Actual file operations and helper input directions must match the contract.
 format_files={d['recordFormats'][0]['formatName']:f for f,d in FILES.items() if d['specHeader']['fileType']=='PF'}
 writes={f for st in ps['steps'] for f in st['writes']}
 actual_reads=set();actual_writes=set()
 for st in statements:
  op=st['op'].split('(')[0]
  if op in ['READ','READE','CHAIN','SETLL','SETGT']:
   actual_reads.add(st['f2']);check(st['f2'] in ps['files'],name+': undeclared read '+st['f2'])
  if op in ['WRITE','UPDATE','DELETE']:
   file=format_files.get(st['f2'],st['f2']);actual_writes.add(file);check(file in writes,name+': forbidden write '+file)
  if op in ['READ','READE','CHAIN','WRITE','UPDATE']:
   check(st['res'] in decls,name+': I/O buffer missing '+st['res'])
  if name!='ORDMAIN' and op=='EVAL':
   lhs=st['text'].split('=')[0].strip().split('.')[0].split('(')[0]
   inputs={x[0] for x in C['interfaces'][name] if x[3]=='I'}
   check(lhs not in inputs,name+': changed input '+lhs)
 # Key operations must reference an explicit KLIST or the low boundary.
 for s in statements:
  if s['op'].split('(')[0] in ['CHAIN','READE','SETLL','SETGT'] and s['f1']:
   check(s['f1'] in keydefs or s['f1'] in ['*LOVAL','*HIVAL'],name+': undefined key '+str(s))
 blank=sum(not x.strip() for x in lines);comments=sum(len(x)>6 and x[5:7] in ['* ','C*'] for x in lines)
 stats.append({'program':name,'path':str(p.relative_to(ROOT)),'physicalLines':len(lines),'blankLines':blank,'commentLines':comments,'nonblankNoncommentLines':len(lines)-blank-comments,'routines':len(defs),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
 maps[name]={'routines':defs,'calls':external,'steps':[{'number':s['number'],'routine':s['routine'],'line':defs.get(s['routine']),'rules':s['br']} for s in ps['steps']], 'opcodeCounts':dict(opcounts),'actualReads':sorted(actual_reads),'actualWrites':sorted(actual_writes)}
# DDS field placement and exact key definitions.
for n,spec in FILES.items():
 p=ROOT/'src/QDDSSRC'/(n+'.dds');rows=p.read_text().splitlines();fields=[];keys=[];record=[]
 for i,row in enumerate(rows):
  check(len(row)<=80 and row.isascii(),n+': DDS columns')
  row=row.ljust(80)
  if row[6]=='*':continue
  kind=row[16];fname=row[18:28].strip()
  if kind=='R':record.append((i,fname))
  elif kind=='K':keys.append(fname)
  elif fname:fields.append((fname,int(row[29:34]),row[34],int(row[35:37]) if row[35:37].strip() else None))
 check([f[1] for f in record]==[spec['recordFormats'][0]['formatName']],n+': DDS format')
 check(keys==[k['fieldName'] for k in spec['keyDefinition']['keys']],n+': DDS keys')
 check(any('UNIQUE' in x for x in rows[:record[0][0]]),n+': DDS UNIQUE scope')
 if spec['specHeader']['fileType']=='PF':
  expected=[(f['fieldName'],f['length'],f['type'],f['decimals']) for f in next(iter(spec['fieldDefinitions'].values()))]
  check(fields==expected,n+': DDS fields differ')
 else:check(not fields and any('PFILE(' in x for x in rows),n+': LF inheritance')
# Validate shared COPY order, precision, dimensions, bytes independently.
for name,s in C['structures'].items():
 lines=(ROOT/'src/QRPGLESRC'/(s['member']+'.rpgleinc')).read_text().splitlines();active=False;found=[];dim=1
 for row in lines:
  if '/IF DEFINED(U_'+name+')' in row:active=True;continue
  if active and '/ENDIF' in row:break
  if active and len(row)>5 and row[5]=='D':
   row=row.ljust(80);m=re.search(r'DIM\((\d+)\)',row)
   if m:dim=int(m.group(1))
   n=row[6:21].strip()
   if n and row[23:25].strip()=='':found.append((n,int(row[32:39]),row[39],int(row[40:42]) if row[40:42].strip() else None))
 expected=[(f['fieldName'],f['length'],f['type'],f['decimals']) for f in s['fields']]
 check(found==expected,name+': COPY layout');check(dim==s['count'],name+': COPY dimension')
 size=sum(z if t=='A' else (z+2)//2 for _,z,t,d in found)*dim
 check(size==s['bytes'],name+': COPY bytes')
driver=ROOT/'src/QCLLESRC/ORDRUN.clle'
driver_text=driver.read_text();driver_steps=[]
for st in next(x for x in IDX['programs'] if x['object']=='ORDRUN')['steps']:
 loc=next((i for i,line in enumerate(driver_text.splitlines(),1) if st['routine']+':' in line),None)
 check(loc is not None,'ORDRUN step '+st['routine']);driver_steps.append({'number':st['number'],'routine':st['routine'],'line':loc,'rules':st['br']})
check('PGM PARM(&BATCH &DAY &MODE &ACTOR &RESULT)' in driver_text,'ORDRUN entry ABI')
check('CALL PGM(ORDMAIN) PARM(&BATCH &DAY &MODE &ACTOR &RESULT)' in driver_text,'ORDRUN call ABI')
check('CALL PGM(' not in driver_text.replace('CALL PGM(ORDMAIN)',''),'ORDRUN extra external call')
check(driver_text.index("CHGVAR VAR(&OWNED) VALUE('1')")>driver_text.index('STRCMTCTL'),'ORDRUN ownership ordering')
maps['ORDRUN']={'steps':driver_steps,'calls':[{'program':'ORDMAIN','parameters':['BATCH','DAY','MODE','ACTOR','RESULT']}]}
check(10000<=next(x for x in stats if x['program']=='ORDMAIN')['physicalLines']<=12000,'main physical line target')
check(sum(len(x['steps']) for x in maps.values())==94,'all program steps')
rules={br for p in maps.values() for st in p['steps'] for br in st['rules']}
check(rules=={'BR-'+str(n).zfill(2) for n in range(1,33)},'rule trace coverage')
source_assets=[]
for file in sorted((ROOT/'src').rglob('*')):
 if file.suffix in ['.rpgle','.rpgleinc','.clle','.dds']:
  check(not any(x in file.read_text().upper() for x in ['TODO','FIXME','TBD','PLACEHOLDER','STUB']),'source placeholder '+str(file))
  source_assets.append({'path':str(file.relative_to(ROOT)),'sha256':hashlib.sha256(file.read_bytes()).hexdigest(),'physicalLines':len(file.read_text().splitlines())})
check(len(source_assets)==35,'source asset count')
# Upstream manifest remains immutable.
m=json.loads((ROOT/'.agent/upstream-manifest.json').read_text())
for f in m['files']:
 p=ROOT/f['destination_path'];check(hashlib.sha256(p.read_bytes()).hexdigest()==f['sha256'],'upstream hash '+str(p));check(oct(p.stat().st_mode&0o777)==f['mode'],'upstream mode '+str(p))
for p in ROOT.rglob('*'):
 if p.is_file() and '.git' not in p.parts:
  try:check('.'+'claude' not in p.read_text(),'old directory reference '+str(p))
  except UnicodeDecodeError:pass
result={'status':'PASS' if not issues else 'FAIL','scope':'Static structure, contract and traceability; no IBM i compilation or execution','issues':issues,'programs':stats,'traceability':maps,'assets':source_assets}
(ROOT/'docs/source/static-checks.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'status':result['status'],'issues':issues,'sourceAssets':len(source_assets),'programSteps':sum(len(p['steps']) for p in maps.values()),'mainPhysicalLines':next(p['physicalLines'] for p in stats if p['program']=='ORDMAIN')},ensure_ascii=False,indent=2))
raise SystemExit(1 if issues else 0)
