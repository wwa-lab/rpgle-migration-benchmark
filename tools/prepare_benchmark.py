#!/usr/bin/env python3
"""Freeze/verify text-only benchmark materials. Never execute business code."""
from pathlib import Path
import argparse, hashlib, io, json, re, zipfile
ROOT=Path(__file__).resolve().parents[1]
B=ROOT/'benchmark'
VERSION='RPGFLOW-1.0'
LIMIT=24000

def dump(x):return (json.dumps(x,ensure_ascii=False,indent=2)+'\n').encode()
def digest(data):return hashlib.sha256(data).hexdigest()
def read(path):return (ROOT/path).read_bytes()
def strip_comments(data,suffix):
 text=data.decode('ascii');rows=text.splitlines(keepends=True);removed=[]
 if suffix!='.clle':
  clean=[]
  for number,row in enumerate(rows,1):
   comment=len(row)>6 and (row[5]=='*' or row[6]=='*')
   if comment:removed.append({'line':number,'text':row.rstrip('\n')});clean.append('\n')
   else:clean.append(row)
  return ''.join(clean).encode(),removed
 # CL string literals can contain apostrophe escapes and comment-like text.
 chars=list(text);inside=False;quoted=False;i=0
 while i<len(text):
  if inside:
   if text[i:i+2]=='*/':chars[i]=chars[i+1]=' ';inside=False;i+=2;continue
   if text[i]!='\n':chars[i]=' '
   i+=1;continue
  if text[i]=="'":
   if quoted and text[i:i+2]=="''":i+=2;continue
   quoted=not quoted;i+=1;continue
  if not quoted and text[i:i+2]=='/*':chars[i]=chars[i+1]=' ';inside=True;i+=2;continue
  i+=1
 assert not inside and not quoted,'CL comments or strings unclosed'
 out=''.join(chars).splitlines(keepends=True);clean=[]
 for n,(before,after) in enumerate(zip(rows,out),1):
  if before!=after:removed.append({'line':n,'text':before.rstrip('\n')})
  clean.append('\n' if not after.strip() else after)
 return ''.join(clean).encode(),removed

def archive(files,prefix):
 out=io.BytesIO()
 with zipfile.ZipFile(out,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
  for path,data in sorted(files.items()):
   info=zipfile.ZipInfo(prefix+path,date_time=(1980,1,1,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o100644<<16;info.create_system=3;z.writestr(info,data)
 return out.getvalue()

def make_parts(material,order):
 blocks=[]
 for path in order:
  lines=material[path].decode().splitlines(keepends=True);start=1;group=[];size=0
  def emit():
   end=start+len(group)-1;body=''.join(group);head=f'<<<FILE {path} LINES {start}-{end}>>>\n';tail='<<<END_FILE>>>\n'
   return {'path':path,'startLine':start,'endLine':end,'contentSha256':digest(body.encode()),'text':head+body+tail}
  for line in lines:
   length=len(line.encode())
   assert length<22000,'single input line exceeds text transport capacity'
   if group and size+length>22000:blocks.append(emit());start+=len(group);group=[];size=0
   group.append(line);size+=length
  if group:blocks.append(emit())
 parts=[];group=[];size=0
 for block in blocks:
  n=len(block['text'].encode())
  if group and size+n>LIMIT-128:parts.append(group);group=[];size=0
  group.append(block);size+=n
 if group:parts.append(group)
 files={};index=[]
 for number,group in enumerate(parts,1):
  name=f'parts/part-{number:03}.txt';data=(f'PART {number:03} OF {len(parts):03}\n'+''.join(b['text'] for b in group)).encode();assert len(data)<=LIMIT
  files[name]=data;index.append({'id':number,'path':name,'utf8Bytes':len(data),'sha256':digest(data),'sections':[{k:v for k,v in s.items() if k!='text'} for s in group]})
 return files,index

def desired():
 result={};material={};transforms=[]
 source=json.loads(read('docs/source/static-checks.json'));assert source['status']=='PASS'
 for a in source['assets']:
  path=a['path'];raw=read(path);assert digest(raw)==a['sha256'],'source changed; inspect before a new freeze'
  cleaned,removed=strip_comments(raw,Path(path).suffix)
  assert len(raw.splitlines())==len(cleaned.splitlines())
  if Path(path).suffix!='.clle':
   for x,y in zip(raw.splitlines(),cleaned.splitlines()):
    assert not y or x==y,'noncomment code changed'
  assert not re.search(rb'BR-\d{2}|\bStep\s+\d|SKILL\.md',cleaned,re.I)
  material[path]=cleaned
  transforms.append({'developmentPath':path,'inputPath':path,'developmentSha256':digest(raw),'inputSha256':digest(cleaned),'physicalLines':len(cleaned.splitlines()),'mapping':'identity: input line N = development line N','commentLinesBlanked':len(removed),'removedComments':removed})
 for path in ['README.md','context/operations-and-systems.md','context/interfaces.md']:material[path]=(B/'input'/path).read_bytes()
 common=(B/'prompts/task.md').read_bytes();ro=(B/'prompts/ro-files.md').read_bytes();cont=(B/'prompts/continuation.md').read_bytes();start=(B/'prompts/text-parts-start.md').read_bytes()
 entries=[{'path':p,'bytes':len(d),'sha256':digest(d),'physicalLines':len(d.splitlines())} for p,d in sorted(material.items())]
 material_hash=digest(dump(entries));inputfiles=dict(material)
 inputfiles.update({'prompts/task.md':common,'prompts/run.md':ro+b'\n---\n\n'+common,'prompts/continuation.md':cont})
 manifest={'materialVersion':VERSION,'status':'FROZEN_STATIC_CANDIDATE','compiled':False,'executed':False,'sourceFiles':35,'businessMaterialFiles':len(material),'materialSetSha256':material_hash,'taskSha256':digest(common),'lineNumberConvention':'physical lines including blank lines; no COPY expansion','files':[{'path':p,'bytes':len(d),'sha256':digest(d),'physicalLines':len(d.splitlines())} for p,d in sorted(inputfiles.items())]}
 inputfiles['manifest.json']=dump(manifest)
 for p,d in inputfiles.items():result['input/'+p]=d
 order=['README.md','context/operations-and-systems.md','context/interfaces.md']
 order+=sorted(p for p in material if p.endswith('.rpgleinc'))+sorted(p for p in material if p.endswith('.dds'))
 order+=['src/QCLLESRC/ORDRUN.clle']+[f'src/QRPGLESRC/{p}.rpgle' for p in ['ORDMAIN','ORDCHECK','ORDPRICE','ORDSTOCK','ORDSETTL','ORDREPLY','ORDDAILY']]
 assert len(order)==len(set(order))==len(material) and set(order)==set(material)
 delivery,parts=make_parts(material,order)
 delivery.update({'start.md':start,'final.md':common,'continuation.md':cont})
 delivery['index.json']=dump({'materialVersion':VERSION,'profile':'TEXT-PARTS','tools':'disabled','materialSetSha256':material_hash,'taskSha256':digest(common),'partCount':len(parts),'partUtf8ByteLimit':LIMIT,'materialFiles':entries,'parts':parts})
 for p,d in delivery.items():result['delivery/'+p]=d
 result['reference/transformation.json']=dump({'materialVersion':VERSION,'method':'Blank full-line RPGLE/COPY/DDS comments and lexical CL comment spans; retain line breaks and noncomment columns. No identifier or business literal changes.','files':transforms})
 result['reference/source-static-checks.json']=read('docs/source/static-checks.json')
 baseline=sorted([*ROOT.glob('docs/requirements/*.md'),*ROOT.glob('docs/design/*.md'),*ROOT.glob('docs/specifications/**/*.md'),*ROOT.glob('docs/specifications/**/*.json'),*ROOT.glob('src/QRPGLESRC/*'),*ROOT.glob('src/QCLLESRC/*'),*ROOT.glob('src/QDDSSRC/*')])
 result['reference/baseline-manifest.json']=dump({'materialVersion':VERSION,'files':[{'path':str(p.relative_to(ROOT)),'sha256':digest(p.read_bytes())} for p in baseline if p.is_file()]})
 for suffix,files,prefix in [('files',inputfiles,'input/'),('text',delivery,'delivery/')]:result[f'dist/{VERSION}-{suffix}.zip']=archive(files,prefix)
 result['dist/SHA256SUMS.txt']=''.join(f'{digest(result[p])}  {Path(p).name}\n' for p in sorted(result) if p.endswith('.zip')).encode()
 controls=sorted([*B.glob('prompts/*.md'),*B.glob('reference/*.md'),B/'reference/evidence-checklist.json',*[B/'runs'/name for name in ('README.md','run-template.json','configuration-notes.md','score-template.csv','comparison-template.csv')]])
 frozen={'materialVersion':VERSION,'status':'FROZEN_STATIC_CANDIDATE','runStatus':'NOT_RUN','materialSetSha256':material_hash,'taskSha256':digest(common),'generatedFiles':[{'path':p,'sha256':digest(d)} for p,d in sorted(result.items())],'controlFiles':[{'path':str(p.relative_to(B)),'sha256':digest(p.read_bytes())} for p in controls if p.is_file()]}
 result['freeze.json']=dump(frozen)
 return result,material,parts,transforms

def verify(result,material,parts,transforms):
 issues=[]
 for path,data in result.items():
  target=B/path
  if not target.is_file() or target.read_bytes()!=data:issues.append('missing or changed: '+path)
 for folder in ['input','delivery','dist']:
  actual={str(p.relative_to(B)) for p in (B/folder).rglob('*') if p.is_file()};expect={p for p in result if p.startswith(folder+'/')}
  if actual!=expect:issues.append('unexpected file set: '+folder)
 rebuilt={p:[] for p in material};nextline={p:1 for p in material}
 for part in parts:
  text=result['delivery/'+part['path']].decode()
  chunks=re.findall(r'^<<<FILE ([^\n]+) LINES (\d+)-(\d+)>>>\n(.*?)^<<<END_FILE>>>\n',text,re.M|re.S)
  if len(chunks)!=len(part['sections']):issues.append('part parse: '+part['path']);continue
  for (path,start,end,body),spec in zip(chunks,part['sections']):
   if int(start)!=nextline[path] or len(body.splitlines())!=int(end)-int(start)+1 or digest(body.encode())!=spec['contentSha256']:issues.append('part range: '+path)
   rebuilt[path].append(body);nextline[path]=int(end)+1
 for path,values in rebuilt.items():
  if ''.join(values).encode()!=material[path]:issues.append('text reconstruction differs: '+path)
 for name,prefix in [('files','input/'),('text','delivery/')]:
  raw=result[f'dist/{VERSION}-{name}.zip']
  with zipfile.ZipFile(io.BytesIO(raw)) as z:
   expected={p for p in result if p.startswith(prefix)}
   if set(z.namelist())!=expected:issues.append('archive allowlist: '+name)
   for item in z.infolist():
    if z.read(item.filename)!=result[item.filename]:issues.append('archive bytes: '+item.filename)
    if item.filename.startswith(('/', '../')) or '..' in Path(item.filename).parts:issues.append('unsafe archive path')
 # Every evidence range must point to retained code, not a removed annotation.
 refs=json.loads((B/'reference/evidence-checklist.json').read_text());assert len(refs['criteria'])==20
 if sum(len(c['points']) for c in refs['criteria'])!=100:issues.append('rubric maximum')
 for c in refs['criteria']:
  for e in c['evidence']:
   rows=material[e['path']].decode().splitlines()
   if 'startLine' in e:
    if not (1<=e['startLine']<=e['endLine']<=len(rows)) or not any(x.strip() for x in rows[e['startLine']-1:e['endLine']]):issues.append('evidence range: '+c['id'])
    if 'routine' in e and rows[e['startLine']-1][11:25].strip()!=e['routine']:issues.append('evidence routine: '+c['id'])
   elif e['section'] not in '\n'.join(rows):issues.append('background section: '+c['id'])
 return {'status':'PASS' if not issues else 'FAIL','materialVersion':VERSION,'issues':issues,'sourceFiles':len(transforms),'businessMaterialFiles':len(material),'textParts':len(parts),'maxPartUtf8Bytes':max(p['utf8Bytes'] for p in parts),'commentsRemoved':sum(t['commentLinesBlanked'] for t in transforms),'mainPhysicalLines':next(t['physicalLines'] for t in transforms if t['inputPath'].endswith('/ORDMAIN.rpgle')),'textReconstruction':'byte-identical' if not issues else 'see issues','archiveBoundary':'allowlist verified' if not issues else 'see issues','compiled':False,'businessCodeExecuted':False,'modelsCalled':False}

if __name__=='__main__':
 parser=argparse.ArgumentParser();parser.add_argument('--check',action='store_true');args=parser.parse_args()
 result,material,parts,transforms=desired()
 if not args.check:
  if (B/'freeze.json').exists():
   assert (B/'freeze.json').read_bytes()==result['freeze.json'],'Frozen material/control changed; create a new version instead of overwriting this freeze.'
  for path,data in result.items():
   target=B/path;target.parent.mkdir(parents=True,exist_ok=True)
   if not target.exists() or target.read_bytes()!=data:target.write_bytes(data)
 report=verify(result,material,parts,transforms)
 if not args.check:(B/'reference/packaging-checks.json').write_bytes(dump(report))
 print(json.dumps(report,ensure_ascii=False,indent=2))
 raise SystemExit(0 if report['status']=='PASS' else 1)
