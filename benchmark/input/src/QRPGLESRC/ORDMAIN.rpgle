

     H DFTACTGRP(*NO) ACTGRP('ORDBENCH')
     H OPTION(*SRCSTMT:*NODEBUGIO) DECEDIT('0.')
     FAUDITPF   UF A E           K DISK    COMMIT
     FBATCHPF   UF A E           K DISK    COMMIT
     FINDTLPF   IF   E           K DISK    COMMIT
     FINHDRPF   IF   E           K DISK    COMMIT
     FORDDTLPF  UF A E           K DISK    COMMIT
     FORDHDRPF  UF A E           K DISK    COMMIT
     FREQPF     UF A E           K DISK    COMMIT
     FRTNDTLPF  UF A E           K DISK    COMMIT
     FRTNHDRPF  UF A E           K DISK    COMMIT
     FSETLDTPF  IF   E           K DISK    COMMIT
     FSETLHDPF  IF   E           K DISK    COMMIT
     FSHIPDTPF  UF A E           K DISK    COMMIT
     FSHIPHDPF  UF A E           K DISK    COMMIT
      /DEFINE U_CTXDS
      /DEFINE U_RESDS
      /DEFINE U_HDRDS
      /DEFINE U_RAWROWS
      /DEFINE U_CHKHEAD
      /DEFINE U_NORMROWS
      /DEFINE U_PRIN
      /DEFINE U_PROUT
      /DEFINE U_STKIN
      /DEFINE U_STKOLD
      /DEFINE U_STKNEW
      /DEFINE U_SETHEAD
      /DEFINE U_SETROWS
      /DEFINE U_SETVIEW
      /DEFINE U_OUTREC
      /DEFINE U_DAYHEAD
      /COPY QRPGLESRC,ORDCTX
      /COPY QRPGLESRC,ORDRES
      /COPY QRPGLESRC,ORDSTS
     DBATCH            S             20A
     DDAY              S              8A
     DMODE             S              8A
     DACTOR            S             20A
     DRESULT           S              4A
     DAUREC            DS                  LIKEREC(AUDITR)
     DKAUID            S             64A
     DBTREC            DS                  LIKEREC(BATCHR)
     DKBTID            S             20A
     DIDREC            DS                  LIKEREC(INDTLR)
     DKIDBATCH         S             20A
     DKIDINPUT         S              9P 0
     DKIDPOS           S              5P 0
     DIHREC            DS                  LIKEREC(INHDRR)
     DKIHBATCH         S             20A
     DKIHSEQ           S              9P 0
     DODREC            DS                  LIKEREC(ORDDTLR)
     DKODORDER         S             20A
     DKODLINE          S              5P 0
     DOHREC            DS                  LIKEREC(ORDHDRR)
     DKOHORDER         S             20A
     DRQREC            DS                  LIKEREC(REQR)
     DKRQSRC           S             12A
     DKRQREQ           S             20A
     DRDREC            DS                  LIKEREC(RTNDTLR)
     DKRDRETURN        S             20A
     DKRDLINE          S              5P 0
     DRHREC            DS                  LIKEREC(RTNHDRR)
     DKRHRETURN        S             20A
     DSLREC            DS                  LIKEREC(SETLDTR)
     DKSLSETTL         S             48A
     DKSLLINE          S              5P 0
     DSEREC            DS                  LIKEREC(SETLHDR)
     DKSEID            S             48A
     DSDREC            DS                  LIKEREC(SHIPDTR)
     DKSDSHIP          S             20A
     DKSDLINE          S              5P 0
     DSHREC            DS                  LIKEREC(SHIPHDR)
     DKSHSHIP          S             20A
     DINPUTNO          S              9P 0
     DLASTNO           S              9P 0
     DROWCOUNT         S              9P 0
     DORDCNT           S              9P 0
     DOLDCOUNT         S              9P 0
     DAUDSEQ           S              9P 0
     DMSGSEQ           S              9P 0
     DLINEIX           S              9P 0
     DORDERQ           S              9P 0
     DRETURNQ          S              9P 0
     DPREVQ            S              9P 0
     DGROUPN           S              9P 0
     DGI               S              9P 0
     DSTARTPOS         S              9P 0
     DSEGNO            S              9P 0
     DSEGMAX           S              9P 0
     DSNAPLEN          S              9P 0
     DSNAPPOS          S              9P 0
     DSNAPLEFT         S              9P 0
     DVERSION          S              9P 0
     DRESTCOUNT        S              9P 0
     DINPUTEND         S               N
     DHASKEY           S               N
     DDUPLICATE        S               N
     DCONFLICT         S               N
     DNEWLEDGER        S               N
     DRETRYABLE        S               N
     DRECOVERING       S               N
     DRECFOUND         S               N
     DMISSING          S               N
     DSTOCKWAIT        S               N
     DHASCHANGE        S               N
     DSKIPAPPLY        S               N
     DANYCANCEL        S               N
     DANYREMAIN        S               N
     DERRORUNIT        S               N
     DBUSRC            S              4A
     DBUSREASON        S            120A
     DREQSTATE         S              8A
     DRUNBATCH         S             20A
     DRUNDAY           S              8A
     DINPUTBATCH       S             20A
     DOLDMSG           S             80A
     DFINALMSG         S             80A
     DORIGEVENT        S              8A
     DAFTERSTATE       S              8A
     DBEFORESTATE      S              8A
     DAUDKIND          S             16A
     DAUDKEY           S             80A
     DSNAPTEXT         S          30000A
     DIDENT            S            120A
     DFEEDBACK         S              8A
     DSHIPKEY          S             20A
     DRETURNKEY        S             20A
     DSETTLEKEY        S             48A
     DRECOVERYRC       S              4A
     DRECOVERYREASON   S            120A
     DORDERAMT         S             19P 2
     DSHIPAMT          S             19P 2
     DRETURNAMT        S             19P 2
     DPREVAMT          S             19P 2
     DSUCCAMT          S             19P 2
     DGROUPAMT         S             19P 2
     DI                S              9P 0
     DJ                S              9P 0
     DK                S              9P 0
     DN                S              9P 0
     DX                S              9P 0
     DY                S              9P 0
     DPOSN             S              9P 0
     DFLEN             S              9P 0
     DHLEN             S              9P 0
     DTOKEN            S          30000A
     DPAYLOAD          S          30000A
     DTOKLEN           S              9P 0
     DPAYLEN           S              9P 0
     DLEN4             S              4S 0
     DWIDE             S             31P12
     DWORKDAY          S               D   DATFMT(*ISO)
     DORDLINES         DS                  LIKEDS(ODREC)
     D                                     DIM(100)
     DOLDLINES         DS                  LIKEDS(ODREC)
     D                                     DIM(100)
     DORDERKEEP        DS                  LIKEDS(OHREC)
     DOLDHEAD          DS                  LIKEDS(OHREC)
     DSHIPBASE         DS                  LIKEDS(SDREC)
     D                                     DIM(100)
     DSHIPHEADS        DS                  LIKEDS(SHREC)
     D                                     DIM(100)
     DRETROWS          DS                  LIKEDS(RDREC)
     D                                     DIM(100)
     DRQKEEP           DS                  LIKEDS(RQREC)
     DORIGRQ           DS                  LIKEDS(RQREC)
     DRECCTX           DS                  LIKEDS(CTXDS)
     DRECHDR           DS                  LIKEDS(HDRDS)
     DRECRAW           DS                  LIKEDS(RAWROWS) DIM(100)
     DRECCHK           DS                  LIKEDS(CHKHEAD)
     DBUSCTX           DS                  LIKEDS(CTXDS)
     DBUSRES           DS                  LIKEDS(RESDS)
     DMSGRESULT        DS                  LIKEDS(OUTREC)
     DSETKEEP          DS                  LIKEDS(SETHEAD)
     DRETPRIOR         S              9P 0 DIM(100)
     DRETSUCC          S             15P 2 DIM(100)
     DGROUPSHIP        S             20A   DIM(100)
     DGROUPIDX         S              5P 0 DIM(100)
     DRECSHIPQ         S              9P 0 DIM(100)
     DRECSHIPA         S             15P 2 DIM(100)
     DCHECKCOUNT       S              9P 0
     DCHECKAMT         S             19P 2
     DREFAMT           S             19P 2
     DCHECKID          S             48A
     DREFID            S             48A
     DREFQTY           S              9P 0
     DCHECKDAY         S              8A
     DSDSAVED          DS                  LIKEDS(SDREC)
     DRDSAVED          DS                  LIKEDS(RDREC)
     DSHSAVED          DS                  LIKEDS(SHREC)
     DRHSAVED          DS                  LIKEDS(RHREC)
     DSESAVED          DS                  LIKEDS(SEREC)
     DSLTRACE          DS                  LIKEDS(SLREC)
     DWIREKEEP         DS                  LIKEDS(OUTREC)
     DWIRESAVE         S          30000A

     C     *ENTRY        PLIST
     C                   PARM                    BATCH
     C                   PARM                    DAY
     C                   PARM                    MODE
     C                   PARM                    ACTOR
     C                   PARM                    RESULT
     C     KAUDIT        KLIST
     C                   KFLD                    KAUID
     C     KBATCH        KLIST
     C                   KFLD                    KBTID
     C     KINDTL1       KLIST
     C                   KFLD                    KIDBATCH
     C     KINDTL2       KLIST
     C                   KFLD                    KIDBATCH
     C                   KFLD                    KIDINPUT
     C     KINDTL        KLIST
     C                   KFLD                    KIDBATCH
     C                   KFLD                    KIDINPUT
     C                   KFLD                    KIDPOS
     C     KINHDR1       KLIST
     C                   KFLD                    KIHBATCH
     C     KINHDR        KLIST
     C                   KFLD                    KIHBATCH
     C                   KFLD                    KIHSEQ
     C     KORDD1        KLIST
     C                   KFLD                    KODORDER
     C     KORDD         KLIST
     C                   KFLD                    KODORDER
     C                   KFLD                    KODLINE
     C     KORDH         KLIST
     C                   KFLD                    KOHORDER
     C     KREQ1         KLIST
     C                   KFLD                    KRQSRC
     C     KREQ          KLIST
     C                   KFLD                    KRQSRC
     C                   KFLD                    KRQREQ
     C     KRTND1        KLIST
     C                   KFLD                    KRDRETURN
     C     KRTND         KLIST
     C                   KFLD                    KRDRETURN
     C                   KFLD                    KRDLINE
     C     KRTNH         KLIST
     C                   KFLD                    KRHRETURN
     C     KSETLD1       KLIST
     C                   KFLD                    KSLSETTL
     C     KSETLD        KLIST
     C                   KFLD                    KSLSETTL
     C                   KFLD                    KSLLINE
     C     KSETLH        KLIST
     C                   KFLD                    KSEID
     C     KSHIPD1       KLIST
     C                   KFLD                    KSDSHIP
     C     KSHIPD        KLIST
     C                   KFLD                    KSDSHIP
     C                   KFLD                    KSDLINE
     C     KSHIPH        KLIST
     C                   KFLD                    KSHSHIP
     C                   MONITOR
     C                   EXSR      MINIT
     C                   ON-ERROR
     C                   EVAL      RESULT = '9000'
     C                   ENDMON
     C                   EVAL      *inlr = *on
     C                   RETURN



     C     MINIT         BEGSR
     C                   CLEAR     CTXDS
     C                   CLEAR     RESDS
     C                   EVAL      RESDS.RSRC = RCOK
     C                   EVAL      RESULT = RCSTOP
     C                   EVAL      RUNBATCH = BATCH
     C                   EVAL      RUNDAY = DAY
     C                   EVAL      CTXDS.CXABI = ABI
     C                   EVAL      CTXDS.CXPROCDAY = RUNDAY
     C                   IF        not ( RUNBATCH <> *blanks )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'BATCH_REQUIRED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = RUNBATCH
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( MODE = 'PROCESS' or MODE = 'RESUME' )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'BATCH_MODE'
     C                   LEAVESR
     C                   ENDIF
     C                   MONITOR
     C                   EVAL      WORKDAY = %date(RUNDAY:*ISO0)
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'RUN_DAY_INVALID'
     C                   LEAVESR
     C                   ENDMON
     C                   EXSR      MBATCH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        BTREC.BTSTATE = 'DONE'
     C                   EVAL      RESULT = BTREC.BTRC
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      LASTNO = BTREC.BTLAST
     C                   EVAL      INPUTEND = *off
     C                   DOW       not INPUTEND
     C                   EXSR      MRESET
     C                   MONITOR
     C                   EXSR      MINPUT
     C                   IF        not INPUTEND and RESDS.RSRC < RCREJECT
     C                   EXSR      MUNIT
     C                   ENDIF
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = RCLOCAL
     C                   EVAL      RESDS.RSREASON = 'EVENT_IO_OR_CONVERSION'
     C                   ENDMON
     C                   IF        INPUTEND
     C                   LEAVE
     C                   ENDIF
     C                   IF        RESDS.RSRC = RCSTOP
     C                   EVAL      RESULT = RCSTOP
     C                   LEAVESR
     C                   ENDIF
     C                   IF        RESDS.RSRC >= RCREJECT or RETRYABLE
     C                   EXSR      MROLL
     C                   ELSE
     C                   EXSR      MCLOSE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   EXSR      MROLL
     C                   ENDIF
     C                   ENDIF
     C                   IF        RESDS.RSRC >= RCSTOP
     C                   EVAL      RESULT = RCSTOP
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MCOMMIT
     C                   IF        RESULT = RCSTOP
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      LASTNO = INPUTNO
     C                   ENDDO
     C                   EXSR      MFINISH
     C                   ENDSR



     C     MBATCH        BEGSR
     C                   EVAL      KBTID = RUNBATCH
     C     KBATCH        CHAIN     BATCHPF       BTREC
     C                   IF        not %found(BATCHPF)
     C                   IF        not ( MODE = 'PROCESS' )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'RESUME_BATCH_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     BTREC
     C                   EVAL      BTREC.BTID = RUNBATCH
     C                   EVAL      BTREC.BTDAY = RUNDAY
     C                   EVAL      BTREC.BTSTATE = 'OPEN'
     C                   EVAL      BTREC.BTACTOR = ACTOR
     C                   EVAL      BTREC.BTRC = RCOK
     C                   WRITE     BATCHR        BTREC
     C                   COMMIT
     C                   ELSE
     C                   IF        not ( BTREC.BTDAY = RUNDAY )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'BATCH_DAY_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( BTREC.BTSTATE = 'OPEN' or BTREC.BTSTATE
     C                             = 'DONE' )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'BATCH_STATE_UNCERTAIN'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR


     C     MRESET        BEGSR
     C                   CLEAR     CTXDS
     C                   CLEAR     RESDS
     C                   CLEAR     HDRDS
     C                   CLEAR     RAWROWS
     C                   CLEAR     CHKHEAD
     C                   CLEAR     NORMROWS
     C                   CLEAR     PRIN
     C                   CLEAR     PROUT
     C                   CLEAR     STKIN
     C                   CLEAR     STKOLD
     C                   CLEAR     STKNEW
     C                   CLEAR     SETHEAD
     C                   CLEAR     SETROWS
     C                   CLEAR     SETVIEW
     C                   CLEAR     OUTREC
     C                   CLEAR     DAYHEAD
     C                   CLEAR     ORDLINES
     C                   CLEAR     OLDLINES
     C                   CLEAR     ORDERKEEP
     C                   CLEAR     OLDHEAD
     C                   CLEAR     SHIPBASE
     C                   CLEAR     SHIPHEADS
     C                   CLEAR     RETROWS
     C                   CLEAR     RQKEEP
     C                   CLEAR     ORIGRQ
     C                   CLEAR     RETPRIOR
     C                   CLEAR     RETSUCC
     C                   CLEAR     GROUPSHIP
     C                   CLEAR     GROUPIDX
     C                   EVAL      ROWCOUNT = 0
     C                   EVAL      ORDCNT = 0
     C                   EVAL      OLDCOUNT = 0
     C                   EVAL      AUDSEQ = 0
     C                   EVAL      MSGSEQ = 0
     C                   EVAL      GROUPN = 0
     C                   EVAL      ORDERAMT = 0
     C                   EVAL      SHIPAMT = 0
     C                   EVAL      RETURNAMT = 0
     C                   EVAL      HASKEY = *off
     C                   EVAL      DUPLICATE = *off
     C                   EVAL      CONFLICT = *off
     C                   EVAL      NEWLEDGER = *off
     C                   EVAL      RETRYABLE = *off
     C                   EVAL      RECOVERING = *off
     C                   EVAL      RECFOUND = *off
     C                   EVAL      STOCKWAIT = *off
     C                   EVAL      HASCHANGE = *off
     C                   EVAL      ERRORUNIT = *off
     C                   EVAL      OLDMSG = *blanks
     C                   EVAL      FINALMSG = *blanks
     C                   EVAL      BEFORESTATE = *blanks
     C                   EVAL      AFTERSTATE = *blanks
     C                   EVAL      BUSREASON = *blanks
     C                   EVAL      BUSRC = RCOK
     C                   EVAL      RESDS.RSRC = RCOK
     C                   EVAL      REQSTATE = 'DONE'
     C                   EVAL      CTXDS.CXABI = ABI
     C                   EVAL      CTXDS.CXBATCH = RUNBATCH
     C                   EVAL      CTXDS.CXPROCDAY = RUNDAY
     C                   EVAL      CTXDS.CXACTOR = ACTOR
     C                   ENDSR



     C     MINPUT        BEGSR
     C                   EVAL      KIHBATCH = RUNBATCH
     C                   EVAL      KIHSEQ = LASTNO
     C     KINHDR        SETGT     INHDRPF
     C                   EVAL      KIHBATCH = RUNBATCH
     C     KINHDR1       READE     INHDRPF       IHREC
     C                   IF        %eof(INHDRPF)
     C                   EVAL      INPUTEND = *on
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      HDRDS = IHREC
     C                   EVAL      INPUTNO = IHREC.IHSEQ
     C                   EVAL      INPUTBATCH = RUNBATCH
     C                   EVAL      CTXDS.CXINPUT = INPUTNO
     C                   EXSR      MREADROWS
     C                   EXSR      MCONTEXT
     C                   ENDSR


     C     MREADROWS     BEGSR
     C                   CLEAR     RAWROWS
     C                   EVAL      ROWCOUNT = 0
     C                   EVAL      KIDBATCH = INPUTBATCH
     C                   EVAL      KIDINPUT = HDRDS.IHSEQ
     C     KINDTL2       SETLL     INDTLPF
     C                   EVAL      KIDBATCH = INPUTBATCH
     C                   EVAL      KIDINPUT = HDRDS.IHSEQ
     C     KINDTL2       READE     INDTLPF       IDREC
     C                   DOW       not %eof(INDTLPF)
     C                   IF        not ( ROWCOUNT < 100 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'INPUT_DETAIL_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ROWCOUNT = ROWCOUNT + 1
     C                   EVAL      RAWROWS(ROWCOUNT) = IDREC
     C                   EVAL      KIDBATCH = INPUTBATCH
     C                   EVAL      KIDINPUT = HDRDS.IHSEQ
     C     KINDTL2       READE     INDTLPF       IDREC
     C                   ENDDO
     C                   EVAL      CTXDS.CXCOUNT = ROWCOUNT
     C                   ENDSR



     C     MCONTEXT      BEGSR
     C                   EVAL      CTXDS.CXSRC = HDRDS.IHSRC
     C                   EVAL      CTXDS.CXREQ = HDRDS.IHREQ
     C                   EVAL      CTXDS.CXEVENT = HDRDS.IHEVENT
     C                   EVAL      CTXDS.CXDAY = HDRDS.IHDAY
     C                   EVAL      CTXDS.CXORDER = HDRDS.IHORDER
     C                   EVAL      CTXDS.CXSHIP = HDRDS.IHSHIP
     C                   EVAL      CTXDS.CXRETURN = HDRDS.IHRETURN
     C                   EVAL      CTXDS.CXSETTL = HDRDS.IHSETTL
     C                   EVAL      CTXDS.CXMSG = HDRDS.IHMSG
     C                   EVAL      CTXDS.CXPART = HDRDS.IHPART
     C                   EVAL      CTXDS.CXREASON = HDRDS.IHREASON
     C                   EVAL      CTXDS.CXFEED = HDRDS.IHRESULT
     C                   IF        HDRDS.IHACTOR <> *blanks
     C                   EVAL      CTXDS.CXACTOR = HDRDS.IHACTOR
     C                   ENDIF
     C                   ENDSR


     C     MUNIT         BEGSR
     C                   EXSR      MCANON
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MDEDUP
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        DUPLICATE
     C                   EXSR      MQUERY
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MENVELOPE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MDISPATCH
     C                   ENDSR



     C     MCANON        BEGSR
     C                   EVAL      CTXDS.CXACTION = 'CANON'
     C                   CALL      'ORDCHECK'
     C                   PARM                    CTXDS
     C                   PARM                    HDRDS
     C                   PARM                    RAWROWS
     C                   PARM                    CHKHEAD
     C                   PARM                    NORMROWS
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MCHECKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSRC <> *blanks and HDRDS.IHREQ
     C                             <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'SOURCE_AND_REQUEST_REQUIRED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      HASKEY = *on
     C                   ENDSR



     C     MDEDUP        BEGSR
     C                   EVAL      KRQSRC = CTXDS.CXSRC
     C                   EVAL      KRQREQ = CTXDS.CXREQ
     C     KREQ          CHAIN     REQPF         RQREC
     C                   EVAL      NEWLEDGER = not %found(REQPF)
     C                   IF        NEWLEDGER
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RQKEEP = RQREC
     C                   IF        RQREC.RQCANLEN <> CHKHEAD.CHLEN or
     C                             RQREC.RQCANON <> CHKHEAD.CHCANON
     C                   EVAL      CONFLICT = *on
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'REQUEST_CONTENT_CONFLICT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      DUPLICATE = *on
     C                   EVAL      OLDMSG = RQREC.RQMSG
     C                   EVAL      CTXDS.CXDAY = RQREC.RQDAY
     C                   EVAL      CTXDS.CXORDER = RQREC.RQORDER
     C                   EVAL      CTXDS.CXSHIP = RQREC.RQSHIP
     C                   EVAL      CTXDS.CXRETURN = RQREC.RQRETURN
     C                   EVAL      CTXDS.CXSETTL = RQREC.RQSETTL
     C                   EVAL      BUSRC = RQREC.RQRC
     C                   EVAL      BUSREASON = RQREC.RQREASON
     C                   EVAL      REQSTATE = RQREC.RQSTATE
     C                   ENDSR



     C     MENVELOPE     BEGSR
     C                   EVAL      CTXDS.CXACTION = 'VALIDATE'
     C                   CALL      'ORDCHECK'
     C                   PARM                    CTXDS
     C                   PARM                    HDRDS
     C                   PARM                    RAWROWS
     C                   PARM                    CHKHEAD
     C                   PARM                    NORMROWS
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MCHECKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXVERSION = CHKHEAD.CHVERSION
     C                   EVAL      CTXDS.CXTIER = CHKHEAD.CHTIER
     C                   EVAL      CTXDS.CXCOUNT = CHKHEAD.CHCOUNT
     C                   MONITOR
     C                   EVAL      WORKDAY = %date(HDRDS.IHDAY:*ISO0)
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'BUSINESS_DAY_INVALID'
     C                   LEAVESR
     C                   ENDMON
     C                   IF        not RECOVERING
     C                   IF        not ( HDRDS.IHDAY = RUNDAY )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'BUSINESS_DAY_MISMATCH'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      MEVENTFIELDS
     C                   ENDSR


     C     MDISPATCH     BEGSR
     C                   SELECT
     C                   WHEN      CTXDS.CXEVENT = 'NEW'
     C                   EXSR      MNEW
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MVALID
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MQUOTE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MPLAN
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MVERSION
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'MOD'
     C                   EXSR      MORDER
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MVALID
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MMOD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MQUOTE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MPLAN
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MVERSION
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'ALLOC'
     C                   EXSR      MORDER
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MALLOC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'CANCEL'
     C                   EXSR      MORDER
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MCANCEL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'SHIP'
     C                   EXSR      MORDER
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSHIPID
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSHIPPLAN
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSHIPAMT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSHIPAP
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'RETURN'
     C                   EXSR      MORDER
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MRETURN
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MRETBASE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        RETRYABLE
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MRETAMT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MRETAP
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'SETRES'
     C                   EXSR      MSETGET
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSETSTATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSETAP
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'DELIVER'
     C                   EXSR      MDELIV
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'RECOVER'
     C                   EXSR      MRECCHK
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MRECROUTE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'QUERY'
     C                   EXSR      MQUERY
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'DAYEND'
     C                   EXSR      MDAY
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   OTHER
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'UNKNOWN_EVENT'
     C                   LEAVESR
     C                   ENDSL
     C                   ENDSR



     C     MORDER        BEGSR
     C                   EVAL      KOHORDER = CTXDS.CXORDER
     C     KORDH         CHAIN     ORDHDRPF      OHREC
     C                   IF        not ( %found(ORDHDRPF) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORDERKEEP = OHREC
     C                   EVAL      OLDHEAD = OHREC
     C                   EVAL      BEFORESTATE = OHREC.OHSTATE
     C                   EVAL      ORDCNT = 0
     C                   EVAL      ORDERAMT = 0
     C                   EVAL      KODORDER = CTXDS.CXORDER
     C     KORDD1        SETLL     ORDDTLPF
     C                   EVAL      KODORDER = CTXDS.CXORDER
     C     KORDD1        READE     ORDDTLPF      ODREC
     C                   DOW       not %eof(ORDDTLPF)
     C                   IF        ODREC.ODACTIVE = 'Y'
     C                   IF        not ( ORDCNT < 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_ROW_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ODREC.ODVERSION = ORDERKEEP.OHVERSION )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_VERSION_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORDCNT = ORDCNT + 1
     C                   EVAL      ORDLINES(ORDCNT) = ODREC
     C                   EVAL      ORDERAMT = ORDERAMT + ODREC.ODAMOUNT
     C                   ENDIF
     C                   EVAL      KODORDER = CTXDS.CXORDER
     C     KORDD1        READE     ORDDTLPF      ODREC
     C                   ENDDO
     C                   IF        not ( ORDCNT = ORDERKEEP.OHNLINE and ORDERAMT
     C                             = ORDERKEEP.OHAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_TOTAL_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OLDCOUNT = ORDCNT
     C                   EVAL      OLDLINES = ORDLINES
     C                   IF        CTXDS.CXEVENT = 'MOD' or CTXDS.CXEVENT =
     C                             'ALLOC' or CTXDS.CXEVENT = 'SHIP' or
     C                             CTXDS.CXEVENT = 'CANCEL'
     C                   IF        not ( CTXDS.CXVERSION = ORDERKEEP.OHVERSION )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'ORDER_VERSION_CONFLICT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDERKEEP.OHVERSION < 999999999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_VERSION_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CTXDS.CXPART = ORDERKEEP.OHPART
     C                   EVAL      RESDS.RSVERSION = ORDERKEEP.OHVERSION
     C                   EXSR      MORDERFACTS
     C                   ENDSR



     C     MNEW          BEGSR
     C                   EVAL      KOHORDER = CTXDS.CXORDER
     C     KORDH         CHAIN     ORDHDRPF      OHREC
     C                   IF        not ( not %found(ORDHDRPF) )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'ORDER_ALREADY_EXISTS'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     ORDERKEEP
     C                   EVAL      ORDERKEEP.OHORDER = CTXDS.CXORDER
     C                   EVAL      ORDERKEEP.OHVERSION = 0
     C                   EVAL      ORDERKEEP.OHDAY = CTXDS.CXDAY
     C                   EVAL      ORDERKEEP.OHSHIPANY = 'N'
     C                   EVAL      BEFORESTATE = 'ABSENT'
     C                   ENDSR



     C     MVALID        BEGSR
     C                   IF        not ( CHKHEAD.CHCOUNT >= 1 and
     C                             CHKHEAD.CHCOUNT <= 100 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_CANDIDATE_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHTIER = 'S' or CHKHEAD.CHTIER
     C                             = 'P' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_CANDIDATE_TIER'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXTIER = CHKHEAD.CHTIER
     C                   EVAL      CTXDS.CXPART = HDRDS.IHPART
     C                   EVAL      CTXDS.CXCOUNT = CHKHEAD.CHCOUNT
     C                   ENDSR



     C     MMOD          BEGSR
     C                   IF        not ( ORDERKEEP.OHSHIPANY = 'N' and
     C                             ORDERKEEP.OHSTATE <> 'CANCEL' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_ORDER_NOT_ELIGIBLE'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to OLDCOUNT
     C                   IF        not ( OLDLINES(I).ODSHIPPED = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'MOD_SHIPMENT_HISTORY'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      AUDKIND = 'VERSION_BEFORE'
     C                   EVAL      OHREC = OLDHEAD
     C                   EXSR      AORDHDR
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to OLDCOUNT
     C                   EVAL      ODREC = OLDLINES(I)
     C                   EXSR      AORDDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR



     C     MQUOTE        BEGSR
     C                   CLEAR     PRIN
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      PRIN(I).PILINE = NORMROWS(I).NRLINE
     C                   EVAL      PRIN(I).PIITEM = NORMROWS(I).NRITEM
     C                   EVAL      PRIN(I).PIQTY = NORMROWS(I).NRQTY
     C                   ENDFOR
     C                   EVAL      CTXDS.CXACTION = 'QUOTE'
     C                   CALL      'ORDPRICE'
     C                   PARM                    CTXDS
     C                   PARM                    PRIN
     C                   PARM                    PROUT
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MPRICEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORDERAMT = RESDS.RSAMOUNT
     C                   ENDSR



     C     MPLAN         BEGSR
     C                   CLEAR     STKIN
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      STKIN(I).SILINE = NORMROWS(I).NRLINE
     C                   EVAL      STKIN(I).SIITEM = NORMROWS(I).NRITEM
     C                   EVAL      STKIN(I).SIQTY = NORMROWS(I).NRQTY
     C                   ENDFOR
     C                   EVAL      CTXDS.CXACTION = CTXDS.CXEVENT
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STOCKWAIT = RESDS.RSRC = RCWAIT
     C                   IF        CTXDS.CXEVENT = 'MOD'
     C                   EXSR      AOLDALLOC
     C                   ENDIF
     C                   ENDSR



     C     MVERSION      BEGSR
     C                   EVAL      CTXDS.CXACTION = 'APPLY'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      VERSION = ORDERKEEP.OHVERSION + 1
     C                   IF        CTXDS.CXEVENT = 'MOD'
     C                   FOR       I = 1 to OLDCOUNT
     C                   EVAL      KODORDER = CTXDS.CXORDER
     C                   EVAL      KODLINE = OLDLINES(I).ODLINE
     C     KORDD         CHAIN     ORDDTLPF      ODREC
     C                   IF        not ( %found(ORDDTLPF) )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'MOD_OLD_LINE_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ODREC.ODACTIVE = 'N'
     C                   EVAL      ODREC.ODCANCEL = 0
     C                   EVAL      ODREC.ODSHIPPED = 0
     C                   EVAL      ODREC.ODSHPAMT = 0
     C                   UPDATE    ORDDTLR       ODREC
     C                   ENDFOR
     C                   ENDIF
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      KODORDER = CTXDS.CXORDER
     C                   EVAL      KODLINE = NORMROWS(I).NRLINE
     C     KORDD         CHAIN     ORDDTLPF      ODREC
     C                   EVAL      MISSING = not %found(ORDDTLPF)
     C                   CLEAR     ODREC
     C                   EVAL      ODREC.ODORDER = CTXDS.CXORDER
     C                   EVAL      ODREC.ODLINE = NORMROWS(I).NRLINE
     C                   EVAL      ODREC.ODITEM = NORMROWS(I).NRITEM
     C                   EVAL      ODREC.ODQTY = NORMROWS(I).NRQTY
     C                   EVAL      ODREC.ODUNIT = PROUT(I).POUNIT
     C                   EVAL      ODREC.ODRATE = PROUT(I).PORATE
     C                   EVAL      ODREC.ODAMOUNT = PROUT(I).POAMOUNT
     C                   EVAL      ODREC.ODVERSION = VERSION
     C                   EVAL      ODREC.ODACTIVE = 'Y'
     C                   IF        MISSING
     C                   WRITE     ORDDTLR       ODREC
     C                   ELSE
     C                   UPDATE    ORDDTLR       ODREC
     C                   ENDIF
     C                   EVAL      ORDLINES(I) = ODREC
     C                   EVAL      AUDKIND = 'VERSION_AFTER'
     C                   EXSR      AORDDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      ORDCNT = CHKHEAD.CHCOUNT
     C                   EVAL      OHREC = ORDERKEEP
     C                   EVAL      OHREC.OHVERSION = VERSION
     C                   EVAL      OHREC.OHCUST = HDRDS.IHCUST
     C                   EVAL      OHREC.OHTIER = CHKHEAD.CHTIER
     C                   EVAL      OHREC.OHPART = HDRDS.IHPART
     C                   EVAL      OHREC.OHPRCDAY = CTXDS.CXDAY
     C                   EVAL      OHREC.OHNLINE = ORDCNT
     C                   EVAL      OHREC.OHAMOUNT = ORDERAMT
     C                   EVAL      OHREC.OHSTATE = 'ACTIVE'
     C                   EVAL      OHREC.OHSRC = CTXDS.CXSRC
     C                   EVAL      OHREC.OHREQ = CTXDS.CXREQ
     C                   EVAL      ORDERKEEP = OHREC
     C                   IF        CTXDS.CXEVENT = 'NEW'
     C                   WRITE     ORDHDRR       OHREC
     C                   ELSE
     C                   EVAL      KOHORDER = CTXDS.CXORDER
     C     KORDH         CHAIN     ORDHDRPF      OHREC
     C                   EVAL      OHREC = ORDERKEEP
     C                   UPDATE    ORDHDRR       OHREC
     C                   ENDIF
     C                   EVAL      HASCHANGE = *on
     C                   EVAL      RESDS.RSVERSION = VERSION
     C                   EVAL      AUDKIND = 'VERSION_AFTER'
     C                   EXSR      AORDHDR
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        STOCKWAIT
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON = 'STOCK_WAIT'
     C                   ENDIF
     C                   ENDSR


     C     MFINDLINE     BEGSR
     C                   EVAL      LINEIX = 0
     C                   FOR       J = 1 to ORDCNT
     C                   IF        ORDLINES(J).ODLINE = NORMROWS(I).NRLINE
     C                   EVAL      LINEIX = J
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        not ( LINEIX > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_LINE_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MALLOC        BEGSR
     C                   IF        not ( ORDERKEEP.OHSTATE = 'ACTIVE' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_ORDER_CLOSED'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     STKIN
     C                   EVAL      CTXDS.CXCOUNT = ORDCNT
     C                   FOR       I = 1 to ORDCNT
     C                   EVAL      STKIN(I).SILINE = ORDLINES(I).ODLINE
     C                   EVAL      STKIN(I).SIITEM = ORDLINES(I).ODITEM
     C                   EVAL      STKIN(I).SIQTY = ORDLINES(I).ODQTY -
     C                             ORDLINES(I).ODCANCEL - ORDLINES(I).ODSHIPPED
     C                   ENDFOR
     C                   EVAL      CTXDS.CXACTION = 'ALLOC'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STOCKWAIT = RESDS.RSRC = RCWAIT
     C                   EVAL      CTXDS.CXACTION = 'APPLY'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MADVANCE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        STOCKWAIT
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON = 'STOCK_WAIT'
     C                   ENDIF
     C                   ENDSR



     C     MCANCEL       BEGSR
     C                   CLEAR     STKIN
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EXSR      MFINDLINE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORDERQ = ORDLINES(LINEIX).ODQTY -
     C                             ORDLINES(LINEIX).ODCANCEL -
     C                             ORDLINES(LINEIX).ODSHIPPED
     C                   IF        not ( NORMROWS(I).NRQTY <= ORDERQ )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_EXCEEDS_REMAINING'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STKIN(I).SILINE = NORMROWS(I).NRLINE
     C                   EVAL      STKIN(I).SIITEM = ORDLINES(LINEIX).ODITEM
     C                   EVAL      STKIN(I).SIQTY = NORMROWS(I).NRQTY
     C                   EVAL      STKIN(I).SIREMAIN = ORDERQ
     C                   ENDFOR
     C                   EVAL      CTXDS.CXACTION = 'CANCEL'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXACTION = 'APPLY'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EXSR      MFINDLINE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORDLINES(LINEIX).ODCANCEL =
     C                             ORDLINES(LINEIX).ODCANCEL + NORMROWS(I).NRQTY
     C                   ENDFOR
     C                   EXSR      MADVANCE
     C                   ENDSR


     C     MADVANCE      BEGSR
     C                   EVAL      VERSION = ORDERKEEP.OHVERSION + 1
     C                   EVAL      ANYCANCEL = *off
     C                   EVAL      ANYREMAIN = *off
     C                   FOR       I = 1 to ORDCNT
     C                   EVAL      KODORDER = CTXDS.CXORDER
     C                   EVAL      KODLINE = ORDLINES(I).ODLINE
     C     KORDD         CHAIN     ORDDTLPF      ODREC
     C                   IF        not ( %found(ORDDTLPF) and ODREC.ODVERSION =
     C                             ORDERKEEP.OHVERSION )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'ACTIVE_LINE_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORDLINES(I).ODVERSION = VERSION
     C                   EVAL      ODREC = ORDLINES(I)
     C                   UPDATE    ORDDTLR       ODREC
     C                   IF        ODREC.ODCANCEL > 0
     C                   EVAL      ANYCANCEL = *on
     C                   ENDIF
     C                   IF        ODREC.ODQTY - ODREC.ODCANCEL -
     C                             ODREC.ODSHIPPED > 0
     C                   EVAL      ANYREMAIN = *on
     C                   ENDIF
     C                   EVAL      AUDKIND = 'FULFILMENT_AFTER'
     C                   EXSR      AORDDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      KOHORDER = CTXDS.CXORDER
     C     KORDH         CHAIN     ORDHDRPF      OHREC
     C                   IF        not ( %found(ORDHDRPF) and OHREC.OHVERSION =
     C                             ORDERKEEP.OHVERSION )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OHREC.OHVERSION = VERSION
     C                   EVAL      OHREC.OHSTATE = 'CLOSED'
     C                   IF        ANYCANCEL
     C                   EVAL      OHREC.OHSTATE = 'CANCEL'
     C                   ENDIF
     C                   IF        ANYREMAIN
     C                   EVAL      OHREC.OHSTATE = 'ACTIVE'
     C                   ENDIF
     C                   IF        CTXDS.CXEVENT = 'SHIP'
     C                   EVAL      OHREC.OHSHIPANY = 'Y'
     C                   ENDIF
     C                   EVAL      OHREC.OHSRC = CTXDS.CXSRC
     C                   EVAL      OHREC.OHREQ = CTXDS.CXREQ
     C                   UPDATE    ORDHDRR       OHREC
     C                   EVAL      ORDERKEEP = OHREC
     C                   EVAL      RESDS.RSVERSION = VERSION
     C                   EVAL      HASCHANGE = *on
     C                   EVAL      AUDKIND = 'FULFILMENT_AFTER'
     C                   EXSR      AORDHDR
     C                   ENDSR



     C     MSHIPID       BEGSR
     C                   EVAL      KSHSHIP = CTXDS.CXSHIP
     C     KSHIPH        CHAIN(N)  SHIPHDPF      SHREC
     C                   IF        not ( not %found(SHIPHDPF) )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'SHIPMENT_ALREADY_EXISTS'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHCOUNT >= 1 and
     C                             CHKHEAD.CHCOUNT <= 100 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIPMENT_ROW_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MSHIPPLAN     BEGSR
     C                   CLEAR     PRIN
     C                   CLEAR     STKIN
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EXSR      MFINDLINE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORDERQ = NORMROWS(I).NRQTY
     C                   FOR       J = 1 to I - 1
     C                   IF        NORMROWS(J).NRLINE = NORMROWS(I).NRLINE
     C                   EVAL      ORDERQ = ORDERQ + NORMROWS(J).NRQTY
     C                   ENDIF
     C                   ENDFOR
     C                   IF        not ( ORDERQ <= ORDLINES(LINEIX).ODQTY -
     C                             ORDLINES(LINEIX).ODCANCEL -
     C                             ORDLINES(LINEIX).ODSHIPPED )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_EXCEEDS_DEMAND'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      PRIN(I).PIGROUP = %char(NORMROWS(I).NRLINE)
     C                   EVAL      PRIN(I).PILINE = NORMROWS(I).NRLINE
     C                   EVAL      PRIN(I).PIITEM = ORDLINES(LINEIX).ODITEM
     C                   EVAL      PRIN(I).PIQTY = NORMROWS(I).NRQTY
     C                   EVAL      PRIN(I).PIBASEQTY = ORDLINES(LINEIX).ODQTY
     C                   EVAL      PRIN(I).PIPRIORQ = ORDLINES(LINEIX).ODSHIPPED
     C                   EVAL      PRIN(I).PIBASEAMT = ORDLINES(LINEIX).ODAMOUNT
     C                   EVAL      PRIN(I).PIPRIORA = ORDLINES(LINEIX).ODSHPAMT
     C                   EVAL      STKIN(I).SILINE = NORMROWS(I).NRLINE
     C                   EVAL      STKIN(I).SIITEM = ORDLINES(LINEIX).ODITEM
     C                   EVAL      STKIN(I).SIWH = NORMROWS(I).NRWH
     C                   EVAL      STKIN(I).SIQTY = NORMROWS(I).NRQTY
     C                   ENDFOR
     C                   EVAL      CTXDS.CXACTION = 'SHIP'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR




     C     MSHIPAMT      BEGSR
     C                   EVAL      CTXDS.CXACTION = 'SHIP'
     C                   CALL      'ORDPRICE'
     C                   PARM                    CTXDS
     C                   PARM                    PRIN
     C                   PARM                    PROUT
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MPRICEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SHIPAMT = RESDS.RSAMOUNT
     C                   ENDSR




     C     MSHIPAP       BEGSR
     C                   EVAL      CTXDS.CXACTION = 'APPLY'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     SHREC
     C                   EVAL      SETTLEKEY = 'S:' + %trim(CTXDS.CXSHIP)
     C                   EVAL      SHREC.SHSHIP = CTXDS.CXSHIP
     C                   EVAL      SHREC.SHORDER = CTXDS.CXORDER
     C                   EVAL      SHREC.SHVERSION = ORDERKEEP.OHVERSION + 1
     C                   EVAL      SHREC.SHDAY = CTXDS.CXDAY
     C                   EVAL      SHREC.SHSRC = CTXDS.CXSRC
     C                   EVAL      SHREC.SHREQ = CTXDS.CXREQ
     C                   EVAL      SHREC.SHNLINE = CHKHEAD.CHCOUNT
     C                   EVAL      SHREC.SHSETTL = SETTLEKEY
     C                   EVAL      SHREC.SHAMOUNT = SHIPAMT
     C                   WRITE     SHIPHDR       SHREC
     C                   EVAL      AUDKIND = 'SHIPMENT_CREATED'
     C                   EXSR      ASHIPH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     SETHEAD
     C                   CLEAR     SETROWS
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EXSR      MFINDLINE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     SDREC
     C                   EVAL      SDREC.SDSHIP = CTXDS.CXSHIP
     C                   EVAL      SDREC.SDLINE = I
     C                   EVAL      SDREC.SDORDER = CTXDS.CXORDER
     C                   EVAL      SDREC.SDORDLINE = NORMROWS(I).NRLINE
     C                   EVAL      SDREC.SDITEM = ORDLINES(LINEIX).ODITEM
     C                   EVAL      SDREC.SDWH = NORMROWS(I).NRWH
     C                   EVAL      SDREC.SDQTY = NORMROWS(I).NRQTY
     C                   EVAL      SDREC.SDAMOUNT = PROUT(I).POAMOUNT
     C                   WRITE     SHIPDTR       SDREC
     C                   EVAL      SHIPBASE(I) = SDREC
     C                   EVAL      ORDLINES(LINEIX).ODSHIPPED =
     C                             ORDLINES(LINEIX).ODSHIPPED + SDREC.SDQTY
     C                   EVAL      ORDLINES(LINEIX).ODSHPAMT =
     C                             ORDLINES(LINEIX).ODSHPAMT + SDREC.SDAMOUNT
     C                   EXSR      ASHIPD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SETROWS(I).SLSETTL = SETTLEKEY
     C                   EVAL      SETROWS(I).SLLINE = I
     C                   EVAL      SETROWS(I).SLSHIP = SDREC.SDSHIP
     C                   EVAL      SETROWS(I).SLSHLINE = SDREC.SDLINE
     C                   EVAL      SETROWS(I).SLORDER = CTXDS.CXORDER
     C                   EVAL      SETROWS(I).SLORDLINE = SDREC.SDORDLINE
     C                   EVAL      SETROWS(I).SLQTY = SDREC.SDQTY
     C                   EVAL      SETROWS(I).SLAMOUNT = SDREC.SDAMOUNT
     C                   ENDFOR
     C                   EXSR      MADVANCE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SETHEAD.SEID = SETTLEKEY
     C                   EVAL      SETHEAD.SEKIND = 'P'
     C                   EVAL      SETHEAD.SESHIP = CTXDS.CXSHIP
     C                   EVAL      SETHEAD.SEORDER = CTXDS.CXORDER
     C                   EVAL      SETHEAD.SECREATED = CTXDS.CXPROCDAY
     C                   EVAL      SETHEAD.SESTATE = 'NEW'
     C                   EVAL      SETHEAD.SEAMOUNT = SHIPAMT
     C                   EVAL      SETHEAD.SEATTEMPT = 1
     C                   EVAL      SETHEAD.SENLINE = CHKHEAD.CHCOUNT
     C                   EVAL      SETHEAD.SERETRY = 'N'
     C                   EXSR      MNEXTMSG
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXSETTL = SETTLEKEY
     C                   EVAL      CTXDS.CXACTION = 'CREATE'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      HASCHANGE = *on
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON = 'SHIPMENT_SETTLEMENT_PENDING'
     C                   ENDSR



     C     MRETURN       BEGSR
     C                   EVAL      KRHRETURN = CTXDS.CXRETURN
     C     KRTNH         CHAIN(N)  RTNHDRPF      RHREC
     C                   IF        not ( not %found(RTNHDRPF) )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'RETURN_ALREADY_EXISTS'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     SHIPBASE
     C                   CLEAR     SHIPHEADS
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      KSHSHIP = NORMROWS(I).NRSHIP
     C     KSHIPH        CHAIN(N)  SHIPHDPF      SHREC
     C                   IF        not ( %found(SHIPHDPF) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ORIGINAL_SHIPMENT_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SHREC.SHORDER = CTXDS.CXORDER )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_ORDER_MISMATCH'
     C                   LEAVESR
     C                   ENDIF
     C                   MONITOR
     C                   EVAL      WORKDAY = %date(SHREC.SHDAY:*ISO0)
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIPMENT_DAY_DATA'
     C                   LEAVESR
     C                   ENDMON
     C                   EVAL      N =
     C                             %diff(%date(CTXDS.CXDAY:*ISO0):WORKDAY:*D)
     C                   IF        not ( N >= 0 and N <= 30 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_WINDOW'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SHIPHEADS(I) = SHREC
     C                   EVAL      KSDSHIP = NORMROWS(I).NRSHIP
     C                   EVAL      KSDLINE = NORMROWS(I).NRSHLINE
     C     KSHIPD        CHAIN(N)  SHIPDTPF      SDREC
     C                   IF        not ( %found(SHIPDTPF) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ORIGINAL_SHIPMENT_DETAIL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDORDER = CTXDS.CXORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_DETAIL_ORDER_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SHIPBASE(I) = SDREC
     C                   ENDFOR
     C                   ENDSR




     C     MRETBASE      BEGSR
     C                   CLEAR     RETPRIOR
     C                   CLEAR     RETSUCC
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      CTXDS.CXSETTL = SHIPHEADS(I).SHSETTL
     C                   EVAL      CTXDS.CXSHIP = SHIPHEADS(I).SHSHIP
     C                   EVAL      CTXDS.CXMSG = *blanks
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEKIND = 'P' and
     C                             SETHEAD.SESTATE = 'OK' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_REQUIRES_SETTLED_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXACTION = 'LOOKUP'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      PREVQ = 0
     C                   EVAL      SUCCAMT = 0
     C                   EVAL      RETURNQ = 0
     C                   FOR       J = 1 to 100
     C                   IF        SETVIEW(J).SVSHLINE = SHIPBASE(I).SDLINE
     C                   IF        SETVIEW(J).SVPENDING = 'Y'
     C                   EVAL      RETRYABLE = *on
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON =
     C                             'ORIGINAL_DETAIL_ADJUSTMENT_PENDING'
     C                   EVAL      RESDS.RSRC = RCWAIT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      PREVQ = SETVIEW(J).SVSUCCQTY
     C                   EVAL      SUCCAMT = SETVIEW(J).SVSUCCAMT
     C                   ENDIF
     C                   ENDFOR
     C     *LOVAL        SETLL     RTNDTLPF
     C                   READ      RTNDTLPF      RDREC
     C                   DOW       not %eof(RTNDTLPF)
     C                   IF        RDREC.RDSHIP = SHIPBASE(I).SDSHIP and
     C                             RDREC.RDSHLINE = SHIPBASE(I).SDLINE
     C                   EVAL      RETURNQ = RETURNQ + RDREC.RDQTY
     C                   ENDIF
     C                   READ      RTNDTLPF      RDREC
     C                   ENDDO
     C                   IF        not ( RETURNQ = PREVQ )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_HISTORY_ADJUSTMENT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RETURNQ + NORMROWS(I).NRQTY <=
     C                             SHIPBASE(I).SDQTY )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_EXCEEDS_SHIPPED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RETPRIOR(I) = RETURNQ
     C                   EVAL      RETSUCC(I) = SUCCAMT
     C                   ENDFOR
     C                   ENDSR



     C     MRETAMT       BEGSR
     C                   CLEAR     PRIN
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      PRIN(I).PIGROUP = %trim(SHIPBASE(I).SDSHIP) +
     C                             ':' + %char(SHIPBASE(I).SDLINE)
     C                   EVAL      PRIN(I).PILINE = NORMROWS(I).NRLINE
     C                   EVAL      PRIN(I).PIITEM = SHIPBASE(I).SDITEM
     C                   EVAL      PRIN(I).PIQTY = NORMROWS(I).NRQTY
     C                   EVAL      PRIN(I).PIBASEQTY = SHIPBASE(I).SDQTY
     C                   EVAL      PRIN(I).PIPRIORQ = RETPRIOR(I)
     C                   EVAL      PRIN(I).PIBASEAMT = SHIPBASE(I).SDAMOUNT
     C                   EVAL      PRIN(I).PIPRIORA = RETSUCC(I)
     C                   ENDFOR
     C                   EVAL      CTXDS.CXACTION = 'RETURN'
     C                   CALL      'ORDPRICE'
     C                   PARM                    CTXDS
     C                   PARM                    PRIN
     C                   PARM                    PROUT
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MPRICEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RETURNAMT = RESDS.RSAMOUNT
     C                   ENDSR




     C     MRETAP        BEGSR
     C                   CLEAR     STKIN
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      STKIN(I).SILINE = NORMROWS(I).NRLINE
     C                   EVAL      STKIN(I).SIITEM = SHIPBASE(I).SDITEM
     C                   EVAL      STKIN(I).SIWH = SHIPBASE(I).SDWH
     C                   EVAL      STKIN(I).SIQTY = NORMROWS(I).NRQTY
     C                   ENDFOR
     C                   EVAL      CTXDS.CXACTION = 'RETURN'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXACTION = 'APPLY'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     RHREC
     C                   EVAL      RHREC.RHRETURN = CTXDS.CXRETURN
     C                   EVAL      RHREC.RHORDER = CTXDS.CXORDER
     C                   EVAL      RHREC.RHDAY = CTXDS.CXDAY
     C                   EVAL      RHREC.RHSRC = CTXDS.CXSRC
     C                   EVAL      RHREC.RHREQ = CTXDS.CXREQ
     C                   EVAL      RHREC.RHNLINE = CHKHEAD.CHCOUNT
     C                   EVAL      RHREC.RHAMOUNT = RETURNAMT
     C                   WRITE     RTNHDRR       RHREC
     C                   EVAL      AUDKIND = 'RETURN_CREATED'
     C                   EXSR      ARTNH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      GROUPN = 0
     C                   CLEAR     GROUPSHIP
     C                   CLEAR     GROUPIDX
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      GI = 0
     C                   FOR       J = 1 to GROUPN
     C                   IF        GROUPSHIP(J) = SHIPBASE(I).SDSHIP
     C                   EVAL      GI = J
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        GI = 0
     C                   IF        not ( GROUPN < 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_SHIP_GROUP_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      GROUPN = GROUPN + 1
     C                   EVAL      GI = GROUPN
     C                   EVAL      GROUPSHIP(GI) = SHIPBASE(I).SDSHIP
     C                   ENDIF
     C                   EVAL      GROUPIDX(I) = GI
     C                   CLEAR     RDREC
     C                   EVAL      SETTLEKEY = 'A:' + %trim(CTXDS.CXRETURN) +
     C                             ':' + %trim(SHIPBASE(I).SDSHIP)
     C                   EVAL      RDREC.RDRETURN = CTXDS.CXRETURN
     C                   EVAL      RDREC.RDLINE = NORMROWS(I).NRLINE
     C                   EVAL      RDREC.RDSHIP = SHIPBASE(I).SDSHIP
     C                   EVAL      RDREC.RDSHLINE = SHIPBASE(I).SDLINE
     C                   EVAL      RDREC.RDORDER = CTXDS.CXORDER
     C                   EVAL      RDREC.RDITEM = SHIPBASE(I).SDITEM
     C                   EVAL      RDREC.RDWH = SHIPBASE(I).SDWH
     C                   EVAL      RDREC.RDQTY = NORMROWS(I).NRQTY
     C                   EVAL      RDREC.RDAMOUNT = PROUT(I).POAMOUNT
     C                   EVAL      RDREC.RDSETTL = SETTLEKEY
     C                   WRITE     RTNDTLR       RDREC
     C                   EVAL      RETROWS(I) = RDREC
     C                   EXSR      ARTND
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   FOR       GI = 1 to GROUPN
     C                   CLEAR     SETHEAD
     C                   CLEAR     SETROWS
     C                   EVAL      SETTLEKEY = 'A:' + %trim(CTXDS.CXRETURN) +
     C                             ':' + %trim(GROUPSHIP(GI))
     C                   EVAL      GROUPAMT = 0
     C                   EVAL      N = 0
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   IF        GROUPIDX(I) = GI
     C                   EVAL      N = N + 1
     C                   EVAL      SETROWS(N).SLSETTL = SETTLEKEY
     C                   EVAL      SETROWS(N).SLLINE = N
     C                   EVAL      SETROWS(N).SLSHIP = RETROWS(I).RDSHIP
     C                   EVAL      SETROWS(N).SLSHLINE = RETROWS(I).RDSHLINE
     C                   EVAL      SETROWS(N).SLRETURN = CTXDS.CXRETURN
     C                   EVAL      SETROWS(N).SLRTLINE = RETROWS(I).RDLINE
     C                   EVAL      SETROWS(N).SLORDER = CTXDS.CXORDER
     C                   EVAL      SETROWS(N).SLORDLINE = SHIPBASE(I).SDORDLINE
     C                   EVAL      SETROWS(N).SLQTY = RETROWS(I).RDQTY
     C                   EVAL      SETROWS(N).SLAMOUNT = RETROWS(I).RDAMOUNT
     C                   EVAL      GROUPAMT = GROUPAMT + RETROWS(I).RDAMOUNT
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      SETHEAD.SEID = SETTLEKEY
     C                   EVAL      SETHEAD.SEKIND = 'R'
     C                   EVAL      SETHEAD.SESHIP = GROUPSHIP(GI)
     C                   EVAL      SETHEAD.SERETURN = CTXDS.CXRETURN
     C                   EVAL      SETHEAD.SEORIG = 'S:' + %trim(GROUPSHIP(GI))
     C                   EVAL      SETHEAD.SEORDER = CTXDS.CXORDER
     C                   EVAL      SETHEAD.SECREATED = CTXDS.CXPROCDAY
     C                   EVAL      SETHEAD.SESTATE = 'NEW'
     C                   EVAL      SETHEAD.SEAMOUNT = GROUPAMT
     C                   EVAL      SETHEAD.SEATTEMPT = 1
     C                   EVAL      SETHEAD.SENLINE = N
     C                   EVAL      SETHEAD.SERETRY = 'N'
     C                   EXSR      MNEXTMSG
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXSETTL = SETTLEKEY
     C                   EVAL      CTXDS.CXSHIP = GROUPSHIP(GI)
     C                   EVAL      CTXDS.CXACTION = 'CREATE'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      HASCHANGE = *on
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON = 'RETURN_ADJUSTMENT_PENDING'
     C                   ENDSR



     C     MSETGET       BEGSR
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBBIZID = SETHEAD.SEID and
     C                             OUTREC.OBORDER = SETHEAD.SEORDER )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'FEEDBACK_LINK_CONFLICT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBKIND = 'SETTLE' or
     C                             OUTREC.OBKIND = 'ADJUST' or OUTREC.OBKIND =
     C                             'VERIFY' )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'FEEDBACK_MESSAGE_KIND'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXORDER = SETHEAD.SEORDER
     C                   EVAL      CTXDS.CXSHIP = SETHEAD.SESHIP
     C                   EVAL      CTXDS.CXRETURN = SETHEAD.SERETURN
     C                   EVAL      CTXDS.CXEXPECT = SETHEAD.SESTATE
     C                   EVAL      CTXDS.CXATTEMPT = SETHEAD.SEATTEMPT
     C                   EVAL      BEFORESTATE = SETHEAD.SESTATE
     C                   EVAL      SETKEEP = SETHEAD
     C                   EVAL      MSGRESULT = OUTREC
     C                   ENDSR



     C     MSETSTATE     BEGSR
     C                   EVAL      SKIPAPPLY = *off
     C                   EVAL      FEEDBACK = HDRDS.IHRESULT
     C                   IF        not ( FEEDBACK = 'OK' or FEEDBACK = 'FAIL' or
     C                             FEEDBACK = 'UNKNOWN' or FEEDBACK = 'RETRYOK'
     C                             )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_FEEDBACK'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SETHEAD.SESTATE = 'OK'
     C                   EVAL      SKIPAPPLY = *on
     C                   EVAL      BUSRC = RCDUP
     C                   EVAL      BUSREASON = 'SUCCESS_ALREADY_RECORDED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        FEEDBACK = 'OK'
     C                   EVAL      SETHEAD.SESTATE = 'OK'
     C                   EVAL      SETHEAD.SEFIRSTDAY = RUNDAY
     C                   EVAL      SETHEAD.SERETRY = 'N'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        OUTREC.OBATTEMPT <> SETHEAD.SEATTEMPT or
     C                             OUTREC.OBID <> SETHEAD.SELASTMSG
     C                   EVAL      SKIPAPPLY = *on
     C                   EVAL      BUSRC = RCDUP
     C                   EVAL      BUSREASON = 'STALE_ATTEMPT_FEEDBACK'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SETHEAD.SESTATE = 'UNKNOWN'
     C                   IF        OUTREC.OBKIND = 'VERIFY' and (FEEDBACK =
     C                             'FAIL' or FEEDBACK = 'RETRYOK' )
     C                   EVAL      SETHEAD.SESTATE = 'FAIL'
     C                   EVAL      SETHEAD.SERETRY = 'Y'
     C                   ELSE
     C                   EVAL      SKIPAPPLY = *on
     C                   ENDIF
     C                   ELSE
     C                   IF        FEEDBACK = 'UNKNOWN'
     C                   EVAL      SETHEAD.SESTATE = 'UNKNOWN'
     C                   EVAL      SETHEAD.SERETRY = 'N'
     C                   ELSE
     C                   IF        not ( FEEDBACK = 'FAIL' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETRYOK_REQUIRES_VERIFICATION'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SETHEAD.SESTATE = 'FAIL'
     C                   EVAL      SETHEAD.SERETRY = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON = SETHEAD.SESTATE
     C                   ENDSR



     C     MSETAP        BEGSR
     C                   IF        not SKIPAPPLY
     C                   EVAL      SETHEAD.SEREASON = CTXDS.CXREASON
     C                   EVAL      CTXDS.CXACTION = 'APPLY'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      AFTERSTATE = SETHEAD.SESTATE
     C                   EVAL      HASCHANGE = not SKIPAPPLY
     C                   ENDSR



     C     MDELIV        BEGSR
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDREPLY'
     C                   PARM                    CTXDS
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MREPLYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHORDER = *blanks or
     C                             HDRDS.IHORDER = OUTREC.OBORDER )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'DELIVERY_ORDER_CONFLICT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXORDER = OUTREC.OBORDER
     C                   IF        OUTREC.OBKIND = 'SETTLE' or OUTREC.OBKIND =
     C                             'ADJUST' or OUTREC.OBKIND = 'VERIFY'
     C                   EVAL      CTXDS.CXSETTL = OUTREC.OBBIZID
     C                   EVAL      CTXDS.CXACTION = 'DELIVERY'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CTXDS.CXACTION = 'DELIVERY'
     C                   CALL      'ORDREPLY'
     C                   PARM                    CTXDS
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MREPLYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      HASCHANGE = *on
     C                   ENDSR



     C     MRECCHK       BEGSR
     C                   IF        not ( HDRDS.IHACTOR <> *blanks and
     C                             HDRDS.IHREASON <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVERY_ACTOR_REASON'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( not RECOVERING )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NESTED_RECOVERY_FORBIDDEN'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MRECROUTE     BEGSR
     C                   SELECT
     C                   WHEN      HDRDS.IHACTION = 'LOCAL'
     C                   EXSR      MLOCAL
     C                   WHEN      HDRDS.IHACTION = 'RETRY'
     C                   EXSR      MRETRY
     C                   WHEN      HDRDS.IHACTION = 'VERIFY'
     C                   EXSR      MVERIFY
     C                   WHEN      HDRDS.IHACTION = 'REPLY'
     C                   EXSR      MREPLY
     C                   OTHER
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVERY_ACTION'
     C                   LEAVESR
     C                   ENDSL
     C                   ENDSR




     C     MLOCAL        BEGSR
     C                   EVAL      KRQSRC = HDRDS.IHREFSRC
     C                   EVAL      KRQREQ = HDRDS.IHREFREQ
     C     KREQ          CHAIN     REQPF         RQREC
     C                   IF        not ( %found(REQPF) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ORIGINAL_REQUEST_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RQREC.RQSTATE = 'RETRY' and
     C                             RQREC.RQEVENT <> 'RECOVER' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'LOCAL_RECOVERY_NOT_ELIGIBLE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ORIGRQ = RQREC
     C                   EVAL      RECFOUND = *on
     C                   EVAL      RECCTX = CTXDS
     C                   EVAL      RECHDR = HDRDS
     C                   EVAL      RECRAW = RAWROWS
     C                   EVAL      RECCHK = CHKHEAD
     C                   EVAL      RESTCOUNT = ROWCOUNT
     C                   EVAL      RECOVERING = *on
     C                   MONITOR
     C                   EVAL      KIHBATCH = ORIGRQ.RQBATCH
     C                   EVAL      KIHSEQ = ORIGRQ.RQINPUT
     C     KINHDR        CHAIN     INHDRPF       IHREC
     C                   IF        not %found(INHDRPF)
     C                   EVAL      RESDS.RSRC = RCDATA
     C                   EVAL      RESDS.RSREASON = 'ORIGINAL_INPUT_MISSING'
     C                   ELSE
     C                   EVAL      HDRDS = IHREC
     C                   EVAL      INPUTBATCH = ORIGRQ.RQBATCH
     C                   EXSR      MREADROWS
     C                   IF        RESDS.RSRC < RCREJECT
     C                   EXSR      MCONTEXT
     C                   EVAL      CTXDS.CXACTOR = RECCTX.CXACTOR
     C                   EVAL      CTXDS.CXREASON = RECCTX.CXREASON
     C                   EVAL      CTXDS.CXPROCDAY = RUNDAY
     C                   EXSR      MRECANON
     C                   IF        RESDS.RSRC < RCREJECT
     C                   EXSR      MENVELOPE
     C                   ENDIF
     C                   IF        RESDS.RSRC < RCREJECT
     C                   EXSR      MDISPATCH
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = RCLOCAL
     C                   EVAL      RESDS.RSREASON = 'RECOVERY_IO_OR_CONVERSION'
     C                   ENDMON
     C                   EVAL      BUSCTX = CTXDS
     C                   EVAL      RECOVERYRC = RESDS.RSRC
     C                   EVAL      RECOVERYREASON = RESDS.RSREASON
     C                   EVAL      CTXDS = RECCTX
     C                   EVAL      HDRDS = RECHDR
     C                   EVAL      RAWROWS = RECRAW
     C                   EVAL      CHKHEAD = RECCHK
     C                   EVAL      ROWCOUNT = RESTCOUNT
     C                   EVAL      INPUTBATCH = RUNBATCH
     C                   EVAL      RECOVERING = *off
     C                   EVAL      CTXDS.CXORDER = BUSCTX.CXORDER
     C                   EVAL      CTXDS.CXSHIP = BUSCTX.CXSHIP
     C                   EVAL      CTXDS.CXRETURN = BUSCTX.CXRETURN
     C                   EVAL      CTXDS.CXSETTL = BUSCTX.CXSETTL
     C                   EVAL      RESDS.RSRC = RECOVERYRC
     C                   EVAL      RESDS.RSREASON = RECOVERYREASON
     C                   ENDSR


     C     MRECANON      BEGSR
     C                   EVAL      CTXDS.CXACTION = 'CANON'
     C                   CALL      'ORDCHECK'
     C                   PARM                    CTXDS
     C                   PARM                    HDRDS
     C                   PARM                    RAWROWS
     C                   PARM                    CHKHEAD
     C                   PARM                    NORMROWS
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MCHECKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHLEN = ORIGRQ.RQCANLEN and
     C                             CHKHEAD.CHCANON = ORIGRQ.RQCANON )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON =
     C                             'ORIGINAL_INPUT_CONTENT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MRETRY        BEGSR
     C                   EVAL      CTXDS.CXMSG = *blanks
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SESTATE = 'FAIL' and
     C                             SETHEAD.SERETRY = 'Y' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETRY_NOT_PERMITTED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXORDER = SETHEAD.SEORDER
     C                   EVAL      CTXDS.CXSHIP = SETHEAD.SESHIP
     C                   EVAL      CTXDS.CXRETURN = SETHEAD.SERETURN
     C                   EXSR      MNEXTMSG
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXACTION = 'RETRY'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON = 'SETTLEMENT_RETRY_PENDING'
     C                   ENDSR



     C     MVERIFY       BEGSR
     C                   EVAL      CTXDS.CXMSG = *blanks
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SESTATE = 'UNKNOWN' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'VERIFY_NOT_PERMITTED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXORDER = SETHEAD.SEORDER
     C                   EVAL      CTXDS.CXSHIP = SETHEAD.SESHIP
     C                   EVAL      CTXDS.CXRETURN = SETHEAD.SERETURN
     C                   EXSR      MNEXTMSG
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXACTION = 'VERIFY'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON = 'VERIFICATION_PENDING'
     C                   ENDSR



     C     MREPLY        BEGSR
     C                   EVAL      CTXDS.CXACTION = 'RESEND'
     C                   CALL      'ORDREPLY'
     C                   PARM                    CTXDS
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MREPLYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXORDER = OUTREC.OBORDER
     C                   EVAL      BUSRC = RESDS.RSRC
     C                   EVAL      BUSREASON = 'RECEIPT_RESEND_REGISTERED'
     C                   ENDSR




     C     MQUERY        BEGSR
     C                   EVAL      BUSCTX = CTXDS
     C                   EVAL      ORIGEVENT = CTXDS.CXEVENT
     C                   IF        DUPLICATE
     C                   EVAL      ORIGEVENT = RQKEEP.RQEVENT
     C                   ELSE
     C                   IF        HDRDS.IHREFSRC <> *blanks and HDRDS.IHREFREQ
     C                             <> *blanks
     C                   EVAL      KRQSRC = HDRDS.IHREFSRC
     C                   EVAL      KRQREQ = HDRDS.IHREFREQ
     C     KREQ          CHAIN(N)  REQPF         RQREC
     C                   IF        not ( %found(REQPF) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_REQUEST_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RQKEEP = RQREC
     C                   EVAL      CTXDS.CXORDER = RQREC.RQORDER
     C                   EVAL      CTXDS.CXSHIP = RQREC.RQSHIP
     C                   EVAL      CTXDS.CXRETURN = RQREC.RQRETURN
     C                   EVAL      CTXDS.CXSETTL = RQREC.RQSETTL
     C                   EVAL      ORIGEVENT = RQREC.RQEVENT
     C                   EVAL      OLDMSG = RQREC.RQMSG
     C                   ENDIF
     C                   ENDIF
     C                   IF        ORIGEVENT = 'DAYEND'
     C                   EVAL      CTXDS.CXSRC = RQKEEP.RQSRC
     C                   EVAL      CTXDS.CXREQ = RQKEEP.RQREQ
     C                   EVAL      CTXDS.CXDAY = RQKEEP.RQDAY
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDDAILY'
     C                   PARM                    CTXDS
     C                   PARM                    DAYHEAD
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MDAILYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS = BUSCTX
     C                   EXSR      PDAYHEAD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXORDER <> *blanks
     C                   EVAL      KOHORDER = CTXDS.CXORDER
     C     KORDH         CHAIN(N)  ORDHDRPF      OHREC
     C                   IF        not %found(ORDHDRPF)
     C                   IF        not ( RQKEEP.RQSTATE = 'REJECT' or
     C                             RQKEEP.RQSTATE = 'RETRY' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_ORDER_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CTXDS.CXEVENT = 'QUERY'
     C                   EXSR      MORDER
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   EVAL      CTXDS = BUSCTX
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXEVENT = ORIGEVENT
     C                   EVAL      OHREC = ORDERKEEP
     C                   EXSR      PORDHDR
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to ORDCNT
     C                   EVAL      ODREC = ORDLINES(I)
     C                   EXSR      PORDDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      CTXDS.CXCOUNT = 0
     C                   EVAL      CTXDS.CXACTION = 'VIEW'
     C                   CALL      'ORDSTOCK'
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSTOCKABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      PSTOCKVIEW
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MQUERYSHIP
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MQUERYRETURN
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MQUERYSETTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      MQUERYAUDIT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXEVENT = BUSCTX.CXEVENT
     C                   EVAL      CTXDS.CXDAY = BUSCTX.CXDAY
     C                   EVAL      CTXDS.CXSRC = BUSCTX.CXSRC
     C                   EVAL      CTXDS.CXREQ = BUSCTX.CXREQ
     C                   EVAL      CTXDS.CXMSG = BUSCTX.CXMSG
     C                   ENDSR



     C     MQUERYSHIP    BEGSR
     C     *LOVAL        SETLL     SHIPHDPF
     C                   READ      SHIPHDPF      SHREC
     C                   DOW       not %eof(SHIPHDPF)
     C                   IF        SHREC.SHORDER = CTXDS.CXORDER
     C                   EVAL      SHIPKEY = SHREC.SHSHIP
     C                   EXSR      PSHIPH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSDSHIP = SHIPKEY
     C     KSHIPD1       SETLL     SHIPDTPF
     C                   EVAL      KSDSHIP = SHIPKEY
     C     KSHIPD1       READE     SHIPDTPF      SDREC
     C                   DOW       not %eof(SHIPDTPF)
     C                   EXSR      PSHIPD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSDSHIP = SHIPKEY
     C     KSHIPD1       READE     SHIPDTPF      SDREC
     C                   ENDDO
     C                   ENDIF
     C                   READ      SHIPHDPF      SHREC
     C                   ENDDO
     C                   ENDSR



     C     MQUERYRETURN  BEGSR
     C     *LOVAL        SETLL     RTNHDRPF
     C                   READ      RTNHDRPF      RHREC
     C                   DOW       not %eof(RTNHDRPF)
     C                   IF        RHREC.RHORDER = CTXDS.CXORDER
     C                   EVAL      RETURNKEY = RHREC.RHRETURN
     C                   EXSR      PRTNH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KRDRETURN = RETURNKEY
     C     KRTND1        SETLL     RTNDTLPF
     C                   EVAL      KRDRETURN = RETURNKEY
     C     KRTND1        READE     RTNDTLPF      RDREC
     C                   DOW       not %eof(RTNDTLPF)
     C                   EXSR      PRTND
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KRDRETURN = RETURNKEY
     C     KRTND1        READE     RTNDTLPF      RDREC
     C                   ENDDO
     C                   ENDIF
     C                   READ      RTNHDRPF      RHREC
     C                   ENDDO
     C                   ENDSR



     C     MQUERYSETTL   BEGSR
     C     *LOVAL        SETLL     SETLHDPF
     C                   READ      SETLHDPF      SEREC
     C                   DOW       not %eof(SETLHDPF)
     C                   IF        SEREC.SEORDER = CTXDS.CXORDER
     C                   EVAL      CTXDS.CXSETTL = SEREC.SEID
     C                   EVAL      CTXDS.CXMSG = *blanks
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDSETTL'
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MSETTLEABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      MSGRESULT = OUTREC
     C                   EXSR      PSETHEAD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to SETHEAD.SENLINE
     C                   EVAL      SLREC = SETROWS(I)
     C                   EXSR      PSETDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      OUTREC = MSGRESULT
     C                   EXSR      POUTREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   READ      SETLHDPF      SEREC
     C                   ENDDO
     C                   ENDSR


     C     MQUERYAUDIT   BEGSR
     C     *LOVAL        SETLL     AUDITPF
     C                   READ      AUDITPF       AUREC
     C                   DOW       not %eof(AUDITPF)
     C                   IF        (CTXDS.CXORDER <> *blanks and AUREC.AUORDER =
     C                             CTXDS.CXORDER) or (AUREC.AUSRC = RQKEEP.RQSRC
     C                             and AUREC.AUREQ = RQKEEP.RQREQ and
     C                             RQKEEP.RQSRC <> *blanks)
     C                   EXSR      PAUDIT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   READ      AUDITPF       AUREC
     C                   ENDDO
     C                   ENDSR



     C     MDAY          BEGSR
     C                   IF        not ( CTXDS.CXDAY = RUNDAY )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_DAY_MISMATCH'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CTXDS.CXACTION = 'SNAPSHOT'
     C                   CALL      'ORDDAILY'
     C                   PARM                    CTXDS
     C                   PARM                    DAYHEAD
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MDAILYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      BUSRC = RCOK
     C                   EVAL      BUSREASON = 'DAY_SNAPSHOT_READY'
     C                   EXSR      PDAYHEAD
     C                   ENDSR


     C     MCLOSE        BEGSR
     C                   EVAL      BUSRES = RESDS
     C                   IF        BUSRC = RCOK and RESDS.RSRC <> RCOK
     C                   EVAL      BUSRC = RESDS.RSRC
     C                   EVAL      BUSREASON = RESDS.RSREASON
     C                   ENDIF
     C                   EXSR      MPROJECT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MAUDIT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MLEDGER
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR




     C     MPROJECT      BEGSR
     C                   EVAL      BUSRES = RESDS
     C                   EVAL      WIREKEEP = OUTREC
     C                   EXSR      MOPDETAIL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      MSGRESULT.OBSTATE = *blanks
     C                   EVAL      MSGRESULT.OBID = OLDMSG
     C                   IF        OLDMSG <> *blanks
     C                   EVAL      CTXDS.CXMSG = OLDMSG
     C                   EVAL      CTXDS.CXACTION = 'FETCH'
     C                   CALL      'ORDREPLY'
     C                   PARM                    CTXDS
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MREPLYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      MSGRESULT = OUTREC
     C                   ENDIF
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'RESULT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = REQSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SEAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEFIRSTDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = MSGRESULT.OBID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = MSGRESULT.OBSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(MSGRESULT.OBATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      FINALMSG = OUTREC.OBID
     C                   IF        HASCHANGE and (CTXDS.CXEVENT = 'NEW' or
     C                             CTXDS.CXEVENT = 'MOD' or CTXDS.CXEVENT =
     C                             'ALLOC' or CTXDS.CXEVENT = 'CANCEL' or
     C                             CTXDS.CXEVENT = 'SHIP' or CTXDS.CXEVENT =
     C                             'RETURN' or RECFOUND)
     C                   EXSR      MWHRESULT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      RESDS.RSRC = RCOK
     C                   ENDSR


     C     MNEXTMSG      BEGSR
     C                   IF        not ( MSGSEQ < 99999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTPUT_MESSAGE_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      MSGSEQ = MSGSEQ + 1
     C                   EVAL      CTXDS.CXOUTSEQ = MSGSEQ
     C                   ENDSR


     C     MSENDREC      BEGSR
     C                   EXSR      MNEXTMSG
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     OUTREC
     C                   EVAL      OUTREC.OBKIND = 'RECEIPT'
     C                   EVAL      OUTREC.OBBIZID = CTXDS.CXORDER
     C                   EVAL      OUTREC.OBLEN = PAYLEN
     C                   EVAL      OUTREC.OBPAYLOAD = PAYLOAD
     C                   EVAL      CTXDS.CXACTION = 'CREATE'
     C                   CALL      'ORDREPLY'
     C                   PARM                    CTXDS
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MREPLYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     MWHRESULT     BEGSR
     C                   FOR       I = 1 to 300
     C                   IF        STKOLD(I).SPUSE = 'Y' and
     C                             (STKOLD(I).SPONDELTA <> 0 or
     C                             STKOLD(I).SPRSDELTA <> 0)
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'WAREHOUSE_DELTA'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPONHAND)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPRESVD)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPONDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPRSDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPOLDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPOLDRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPOLDSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPOLDREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPNEWRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPNEWSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPNEWREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPUSE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MNEXTMSG
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     OUTREC
     C                   EVAL      OUTREC.OBKIND = 'WHRESULT'
     C                   EVAL      OUTREC.OBBIZID = CTXDS.CXORDER
     C                   EVAL      OUTREC.OBLEN = PAYLEN
     C                   EVAL      OUTREC.OBPAYLOAD = PAYLOAD
     C                   EVAL      CTXDS.CXACTION = 'CREATE'
     C                   CALL      'ORDREPLY'
     C                   PARM                    CTXDS
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MREPLYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   FOR       I = 1 to 300
     C                   IF        STKNEW(I).SPUSE = 'Y' and
     C                             (STKNEW(I).SPONDELTA <> 0 or
     C                             STKNEW(I).SPRSDELTA <> 0)
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'WAREHOUSE_DELTA'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPONHAND)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPRESVD)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPONDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPRSDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPOLDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPOLDRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPOLDSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPOLDREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPNEWRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPNEWSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPNEWREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPUSE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MNEXTMSG
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     OUTREC
     C                   EVAL      OUTREC.OBKIND = 'WHRESULT'
     C                   EVAL      OUTREC.OBBIZID = CTXDS.CXORDER
     C                   EVAL      OUTREC.OBLEN = PAYLEN
     C                   EVAL      OUTREC.OBPAYLOAD = PAYLOAD
     C                   EVAL      CTXDS.CXACTION = 'CREATE'
     C                   CALL      'ORDREPLY'
     C                   PARM                    CTXDS
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C                   IF        RESDS.RSRC < '1000'
     C                   EXSR      MREPLYABI
     C                   ENDIF
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR




     C     MAUDIT        BEGSR
     C                   EVAL      AUDKIND = 'EVENT_RESULT'
     C                   EVAL      AUDKEY = FINALMSG
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = REQSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(INPUTNO)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHACTION
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXACTOR
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = FINALMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MAPPENDAUD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      AINPUT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MAPPENDAUD    BEGSR
     C                   EVAL      SNAPTEXT = PAYLOAD
     C                   EVAL      SNAPLEN = PAYLEN
     C                   EVAL      SNAPPOS = 1
     C                   EVAL      SEGNO = 0
     C                   DOW       SNAPPOS <= SNAPLEN
     C                   IF        not ( AUDSEQ < 999999999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'AUDIT_SEQUENCE_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDSEQ = AUDSEQ + 1
     C                   EVAL      SEGNO = SEGNO + 1
     C                   EVAL      SNAPLEFT = SNAPLEN - SNAPPOS + 1
     C                   IF        SNAPLEFT > 23000
     C                   EVAL      SNAPLEFT = 23000
     C                   ENDIF
     C                   CLEAR     AUREC
     C                   EVAL      AUREC.AUID = 'A:' + %trim(RUNBATCH) + ':' +
     C                             %editc(INPUTNO:'X') + ':' +
     C                             %editc(AUDSEQ:'X')
     C                   EVAL      AUREC.AUBATCH = RUNBATCH
     C                   EVAL      AUREC.AUINPUT = INPUTNO
     C                   EVAL      AUREC.AUSRC = CTXDS.CXSRC
     C                   EVAL      AUREC.AUREQ = CTXDS.CXREQ
     C                   EVAL      AUREC.AUDAY = RUNDAY
     C                   EVAL      AUREC.AUEVENT = CTXDS.CXEVENT
     C                   EVAL      AUREC.AUORDER = CTXDS.CXORDER
     C                   EVAL      AUREC.AUSHIP = CTXDS.CXSHIP
     C                   EVAL      AUREC.AURETURN = CTXDS.CXRETURN
     C                   EVAL      AUREC.AUSETTL = CTXDS.CXSETTL
     C                   EVAL      AUREC.AUMSG = FINALMSG
     C                   EVAL      AUREC.AUACTOR = CTXDS.CXACTOR
     C                   EVAL      AUREC.AUREASON = CTXDS.CXREASON
     C                   EVAL      AUREC.AURC = BUSRC
     C                   EVAL      AUREC.AUBEFORE = BEFORESTATE
     C                   EVAL      AUREC.AUAFTER = AFTERSTATE
     C                   EVAL      AUREC.AUDETAIL = %trim(AUDKIND) + '|' +
     C                             %trim(AUDKEY) + '|' + %char(SEGNO) + '|' +
     C                             %char(SNAPLEN) + '|' + %char(SNAPPOS) + '|' +
     C                             %subst(SNAPTEXT:SNAPPOS:SNAPLEFT)
     C                   WRITE     AUDITR        AUREC
     C                   EVAL      SNAPPOS = SNAPPOS + SNAPLEFT
     C                   ENDDO
     C                   ENDSR




     C     MLEDGER       BEGSR
     C                   IF        HASKEY and not CONFLICT
     C                   EVAL      KRQSRC = CTXDS.CXSRC
     C                   EVAL      KRQREQ = CTXDS.CXREQ
     C     KREQ          CHAIN     REQPF         RQREC
     C                   EVAL      MISSING = not %found(REQPF)
     C                   IF        NEWLEDGER
     C                   IF        not ( MISSING )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'REQUEST_APPEARED'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     RQREC
     C                   EVAL      RQREC.RQSRC = CTXDS.CXSRC
     C                   EVAL      RQREC.RQREQ = CTXDS.CXREQ
     C                   EVAL      RQREC.RQBATCH = RUNBATCH
     C                   EVAL      RQREC.RQINPUT = INPUTNO
     C                   EVAL      RQREC.RQEVENT = HDRDS.IHEVENT
     C                   EVAL      RQREC.RQDAY = HDRDS.IHDAY
     C                   EVAL      RQREC.RQCANLEN = CHKHEAD.CHLEN
     C                   EVAL      RQREC.RQCANON = CHKHEAD.CHCANON
     C                   EVAL      RQREC.RQORDER = CTXDS.CXORDER
     C                   EVAL      RQREC.RQSHIP = CTXDS.CXSHIP
     C                   EVAL      RQREC.RQRETURN = CTXDS.CXRETURN
     C                   EVAL      RQREC.RQSETTL = CTXDS.CXSETTL
     C                   EVAL      RQREC.RQSTATE = REQSTATE
     C                   EVAL      RQREC.RQRC = BUSRC
     C                   EVAL      RQREC.RQREASON = BUSREASON
     C                   EVAL      RQREC.RQVERSION = ORDERKEEP.OHVERSION
     C                   EVAL      RQREC.RQMSG = FINALMSG
     C                   WRITE     REQR          RQREC
     C                   ELSE
     C                   IF        not ( not MISSING )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ORIGINAL_REQUEST_DISAPPEARED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RQREC.RQCANLEN = CHKHEAD.CHLEN and
     C                             RQREC.RQCANON = CHKHEAD.CHCANON )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'LEDGER_CONTENT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RQREC.RQMSG = FINALMSG
     C                   UPDATE    REQR          RQREC
     C                   ENDIF
     C                   ENDIF
     C                   IF        RECFOUND
     C                   EVAL      KRQSRC = ORIGRQ.RQSRC
     C                   EVAL      KRQREQ = ORIGRQ.RQREQ
     C     KREQ          CHAIN     REQPF         RQREC
     C                   IF        not ( %found(REQPF) and RQREC.RQSTATE =
     C                             'RETRY' )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'RECOVERY_ORIGINAL_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RQREC.RQSTATE = REQSTATE
     C                   EVAL      RQREC.RQRC = BUSRC
     C                   EVAL      RQREC.RQREASON = BUSREASON
     C                   EVAL      RQREC.RQVERSION = ORDERKEEP.OHVERSION
     C                   EVAL      RQREC.RQMSG = FINALMSG
     C                   EVAL      RQREC.RQSHIP = CTXDS.CXSHIP
     C                   EVAL      RQREC.RQRETURN = CTXDS.CXRETURN
     C                   EVAL      RQREC.RQSETTL = CTXDS.CXSETTL
     C                   UPDATE    REQR          RQREC
     C                   ENDIF
     C                   EVAL      KBTID = RUNBATCH
     C     KBATCH        CHAIN     BATCHPF       BTREC
     C                   IF        not ( %found(BATCHPF) and BTREC.BTLAST =
     C                             LASTNO )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'CHECKPOINT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( BTREC.BTCOUNT < 999999999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'BATCH_COUNTER_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      BTREC.BTLAST = INPUTNO
     C                   EVAL      BTREC.BTCOUNT = BTREC.BTCOUNT + 1
     C                   IF        BUSRC >= RCREJECT
     C                   EVAL      BTREC.BTREJECT = BTREC.BTREJECT + 1
     C                   ELSE
     C                   IF        BUSRC = RCWAIT
     C                   EVAL      BTREC.BTWAIT = BTREC.BTWAIT + 1
     C                   ELSE
     C                   EVAL      BTREC.BTACCEPT = BTREC.BTACCEPT + 1
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      BTREC.BTRC = RCOK
     C                   UPDATE    BATCHR        BTREC
     C                   ENDSR



     C     MCOMMIT       BEGSR
     C                   EVAL      RESULT = RCSTOP
     C                   MONITOR
     C                   COMMIT
     C                   EVAL      RESULT = RCOK
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = RCSTOP
     C                   EVAL      RESDS.RSREASON = 'COMMIT_OUTCOME_UNCERTAIN'
     C                   ENDMON
     C                   ENDSR



     C     MROLL         BEGSR
     C                   EVAL      BUSRC = RESDS.RSRC
     C                   EVAL      BUSREASON = RESDS.RSREASON
     C                   IF        RETRYABLE
     C                   EVAL      BUSRC = RCWAIT
     C                   EVAL      BUSREASON =
     C                             'ORIGINAL_DETAIL_ADJUSTMENT_PENDING'
     C                   ENDIF
     C                   MONITOR
     C                   ROLBK
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = RCSTOP
     C                   EVAL      RESDS.RSREASON = 'ROLLBACK_OUTCOME_UNCERTAIN'
     C                   LEAVESR
     C                   ENDMON
     C                   EVAL      ERRORUNIT = *on
     C                   EVAL      HASCHANGE = *off
     C                   EVAL      AUDSEQ = 0
     C                   EVAL      MSGSEQ = 0
     C                   EVAL      FINALMSG = *blanks
     C                   EVAL      OLDMSG = *blanks
     C                   EVAL      RESDS.RSRC = RCOK
     C                   EVAL      REQSTATE = 'REJECT'
     C                   IF        BUSRC = RCLOCAL or RETRYABLE
     C                   EVAL      REQSTATE = 'RETRY'
     C                   ENDIF
     C                   CLEAR     PRIN
     C                   CLEAR     PROUT
     C                   CLEAR     STKIN
     C                   CLEAR     STKOLD
     C                   CLEAR     STKNEW
     C                   CLEAR     SETHEAD
     C                   CLEAR     SETROWS
     C                   CLEAR     SETVIEW
     C                   CLEAR     OUTREC
     C                   CLEAR     DAYHEAD
     C                   CLEAR     ORDERKEEP
     C                   CLEAR     ORDLINES
     C                   CLEAR     OLDLINES
     C                   CLEAR     SHIPBASE
     C                   CLEAR     SHIPHEADS
     C                   CLEAR     RETROWS
     C                   CLEAR     OHREC
     C                   CLEAR     ODREC
     C                   CLEAR     SHREC
     C                   CLEAR     SDREC
     C                   CLEAR     RHREC
     C                   CLEAR     RDREC
     C                   CLEAR     SEREC
     C                   CLEAR     SLREC
     C                   MONITOR
     C                   EXSR      MCLOSE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   EVAL      RESDS.RSRC = RCSTOP
     C                   ENDIF
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = RCSTOP
     C                   EVAL      RESDS.RSREASON = 'RESULT_UNIT_FAILED'
     C                   ENDMON
     C                   ENDSR




     C     MFINISH       BEGSR
     C                   EVAL      RESULT = RCSTOP
     C                   EVAL      KBTID = RUNBATCH
     C     KBATCH        CHAIN     BATCHPF       BTREC
     C                   IF        not ( %found(BATCHPF) and BTREC.BTLAST =
     C                             LASTNO )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'FINISH_CHECKPOINT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      BTREC.BTSTATE = 'DONE'
     C                   EVAL      BTREC.BTRC = RCOK
     C                   UPDATE    BATCHR        BTREC
     C                   EXSR      MCOMMIT
     C                   ENDSR


     C     MEVENTFIELDS  BEGSR
     C                   EVAL      IDENT = HDRDS.IHSRC
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHREQ
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHORDER
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHCUST
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHSHIP
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHRETURN
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHREFSRC
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHREFREQ
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = HDRDS.IHACTOR
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   SELECT
     C                   WHEN      HDRDS.IHEVENT = 'NEW'
     C                   IF        not ( HDRDS.IHORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_REQUIRED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_REQUIRED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_REQUIRED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = 'Y' or HDRDS.IHPART =
     C                             'N' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_PARTIAL_POLICY'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'MOD'
     C                   IF        not ( HDRDS.IHORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_REQUIRED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_REQUIRED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_REQUIRED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_REQUIRED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = 'Y' or HDRDS.IHPART =
     C                             'N' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_PARTIAL_POLICY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHVERSION > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_POSITIVE_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'ALLOC'
     C                   IF        not ( HDRDS.IHORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_REQUIRED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_REQUIRED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHVERSION > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ALLOC_POSITIVE_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'CANCEL'
     C                   IF        not ( HDRDS.IHORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_REQUIRED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_REQUIRED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHVERSION > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_POSITIVE_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'SHIP'
     C                   IF        not ( HDRDS.IHORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_REQUIRED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_REQUIRED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_REQUIRED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHVERSION > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_POSITIVE_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'RETURN'
     C                   IF        not ( HDRDS.IHORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_REQUIRED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_UNEXPECTED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_REQUIRED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'SETRES'
     C                   IF        not ( HDRDS.IHORDER = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_UNEXPECTED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'SETRES_UNEXPECTED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_REQUIRED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_REQUIRED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_REQUIRED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETRES_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'DELIVER'
     C                   IF        not ( HDRDS.IHVERSION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DELIVER_UNEXPECTED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DELIVER_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DELIVER_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DELIVER_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DELIVER_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DELIVER_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DELIVER_REQUIRED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DELIVER_REQUIRED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DELIVER_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DELIVER_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DELIVER_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'RECOVER'
     C                   IF        not ( HDRDS.IHORDER = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_UNEXPECTED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RECOVER_UNEXPECTED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RECOVER_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RECOVER_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_REQUIRED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   SELECT
     C                   WHEN      HDRDS.IHACTION = 'LOCAL'
     C                   IF        not ( HDRDS.IHREFSRC <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_LOCAL_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_LOCAL_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_LOCAL_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_LOCAL_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHACTION = 'RETRY'
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_RETRY_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_RETRY_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_RETRY_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_RETRY_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHACTION = 'VERIFY'
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_VERIFY_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_VERIFY_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_VERIFY_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_VERIFY_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHACTION = 'REPLY'
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_REPLY_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_REPLY_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_REPLY_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVER_REPLY_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   OTHER
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RECOVERY_ACTION'
     C                   LEAVESR
     C                   ENDSL
     C                   WHEN      HDRDS.IHEVENT = 'QUERY'
     C                   IF        not ( HDRDS.IHVERSION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( (HDRDS.IHORDER <> *blanks and
     C                             HDRDS.IHREFSRC = *blanks and HDRDS.IHREFREQ =
     C                             *blanks) or (HDRDS.IHORDER = *blanks and
     C                             HDRDS.IHREFSRC <> *blanks and HDRDS.IHREFREQ
     C                             <> *blanks) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'QUERY_ONE_TARGET'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'DAYEND'
     C                   IF        not ( HDRDS.IHORDER = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHVERSION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DAYEND_UNEXPECTED_IHVERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHCUST = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHCUST'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHPART = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHPART'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSHIP = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRETURN = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHRETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHSETTL = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHSETTL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHMSG = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHRESULT = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHRESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHACTION = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFSRC = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHREFSRC'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( HDRDS.IHREFREQ = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAYEND_UNEXPECTED_IHREFREQ'
     C                   LEAVESR
     C                   ENDIF
     C                   OTHER
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'UNKNOWN_EVENT'
     C                   LEAVESR
     C                   ENDSL
     C                   FOR       I = 1 to CHKHEAD.CHCOUNT
     C                   EVAL      IDENT = NORMROWS(I).NRITEM
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      IDENT = NORMROWS(I).NRSHIP
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   SELECT
     C                   WHEN      HDRDS.IHEVENT = 'NEW'
     C                   IF        not ( NORMROWS(I).NRITEM <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_ITEM_REQUIRED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRWH = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_WAREHOUSE_FROM_RULE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRSHIP = *blanks and
     C                             NORMROWS(I).NRSHLINE = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'NEW_NO_ORIGINAL_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'MOD'
     C                   IF        not ( NORMROWS(I).NRITEM <> *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_ITEM_REQUIRED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRWH = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_WAREHOUSE_FROM_RULE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRSHIP = *blanks and
     C                             NORMROWS(I).NRSHLINE = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_NO_ORIGINAL_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'SHIP'
     C                   IF        not ( NORMROWS(I).NRITEM = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_ITEM_FROM_ORIGINAL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRWH = 'A' or
     C                             NORMROWS(I).NRWH = 'B' or NORMROWS(I).NRWH =
     C                             'C' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_WAREHOUSE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRSHIP = *blanks and
     C                             NORMROWS(I).NRSHLINE = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_NO_ORIGINAL_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'CANCEL'
     C                   IF        not ( NORMROWS(I).NRITEM = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_ITEM_FROM_ORIGINAL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRWH = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_WAREHOUSE_FROM_RULE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRSHIP = *blanks and
     C                             NORMROWS(I).NRSHLINE = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_NO_ORIGINAL_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      HDRDS.IHEVENT = 'RETURN'
     C                   IF        not ( NORMROWS(I).NRITEM = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_ITEM_FROM_ORIGINAL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRWH = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_WAREHOUSE_FROM_RULE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(I).NRSHIP <> *blanks and
     C                             NORMROWS(I).NRSHLINE > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_ORIGINAL_REFERENCE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSL
     C                   ENDFOR
     C                   ENDSR


     C     MIDENT        BEGSR
     C                   IF        IDENT = *blanks
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( %check('ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
     C                             'abcdefghijklmnopqrstuvwxyz0123456789_-'
     C                             :%trimr(IDENT)) = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'IDENTITY_CHARACTER_SET'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MORDERFACTS   BEGSR
     C                   IF        not ( ORDERKEEP.OHORDER = CTXDS.CXORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_KEY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDERKEEP.OHVERSION >= 1 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_VERSION_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDERKEEP.OHTIER = 'S' or
     C                             ORDERKEEP.OHTIER = 'P' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_TIER_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDERKEEP.OHPART = 'Y' or
     C                             ORDERKEEP.OHPART = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_PARTIAL_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDERKEEP.OHSHIPANY = 'Y' or
     C                             ORDERKEEP.OHSHIPANY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_SHIPMENT_FLAG_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDERKEEP.OHSTATE = 'ACTIVE' or
     C                             ORDERKEEP.OHSTATE = 'CANCEL' or
     C                             ORDERKEEP.OHSTATE = 'CLOSED' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_STATE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDCNT >= 1 and ORDCNT <= 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ACTIVE_LINE_COUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ANYCANCEL = *off
     C                   EVAL      ANYREMAIN = *off
     C                   FOR       I = 1 to ORDCNT
     C                   IF        not ( ORDLINES(I).ODORDER = ORDERKEEP.OHORDER
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DETAIL_ORDER_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDLINES(I).ODLINE > 0 and
     C                             ORDLINES(I).ODITEM <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DETAIL_IDENTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDLINES(I).ODQTY >= 1 and
     C                             ORDLINES(I).ODQTY <= 9999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DETAIL_QUANTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDLINES(I).ODCANCEL >= 0 and
     C                             ORDLINES(I).ODSHIPPED >= 0 and
     C                             ORDLINES(I).ODCANCEL + ORDLINES(I).ODSHIPPED
     C                             <= ORDLINES(I).ODQTY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DETAIL_REMAINING_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDLINES(I).ODUNIT > 0 and
     C                             ORDLINES(I).ODAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DETAIL_PRICE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ORDLINES(I).ODSHPAMT >= 0 and
     C                             ORDLINES(I).ODSHPAMT <= ORDLINES(I).ODAMOUNT
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DETAIL_ALLOCATED_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        ORDERKEEP.OHTIER = 'S'
     C                   IF        not ( ORDLINES(I).ODRATE = 1.0000 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STANDARD_RATE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( ORDLINES(I).ODRATE = 0.9500 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PREFERRED_RATE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WIDE = ORDLINES(I).ODQTY * ORDLINES(I).ODUNIT
     C                             * ORDLINES(I).ODRATE
     C                   IF        not ( %dech(WIDE:15:2) = ORDLINES(I).ODAMOUNT
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'FROZEN_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      WIDE = ORDLINES(I).ODAMOUNT *
     C                             ORDLINES(I).ODSHIPPED / ORDLINES(I).ODQTY
     C                   IF        not ( %dech(WIDE:15:2) = ORDLINES(I).ODSHPAMT
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'CUMULATIVE_SHIP_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        ORDLINES(I).ODCANCEL > 0
     C                   EVAL      ANYCANCEL = *on
     C                   ENDIF
     C                   IF        ORDLINES(I).ODQTY - ORDLINES(I).ODCANCEL -
     C                             ORDLINES(I).ODSHIPPED > 0
     C                   EVAL      ANYREMAIN = *on
     C                   ENDIF
     C                   IF        ORDLINES(I).ODSHIPPED > 0
     C                   IF        not ( ORDERKEEP.OHSHIPANY = 'Y' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_FLAG_INCONSISTENT'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   IF        ANYREMAIN
     C                   IF        not ( ORDERKEEP.OHSTATE = 'ACTIVE' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ACTIVE_STATE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        ANYCANCEL
     C                   IF        not ( ORDERKEEP.OHSTATE = 'CANCEL' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_STATE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( ORDERKEEP.OHSTATE = 'CLOSED' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CLOSED_STATE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      MRECONCILE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SORDHDR       BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'ORDHDRPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHVERSION'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OHREC.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHCUST'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHCUST
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHTIER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHTIER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHPART'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHPART
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHPRCDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHPRCDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHNLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OHREC.OHNLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OHREC.OHAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHSTATE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHSHIPANY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHSHIPANY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OHREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OHREC.OHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     AORDHDR       BEGSR
     C                   EXSR      SORDHDR
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'ORDHDRPF'
     C                   EXSR      MAPPENDAUD
     C                   ENDSR


     C     PORDHDR       BEGSR
     C                   EXSR      SORDHDR
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SORDDTL       BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'ORDDTLPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ODREC.ODORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ODREC.ODITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODQTY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODQTY)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODCANCEL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODCANCEL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODSHIPPED'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODSHIPPED)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODUNIT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODUNIT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODRATE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODRATE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODSHPAMT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODSHPAMT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODVERSION'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ODREC.ODVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ODACTIVE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ODREC.ODACTIVE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     AORDDTL       BEGSR
     C                   EXSR      SORDDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'ORDDTLPF'
     C                   EXSR      MAPPENDAUD
     C                   ENDSR


     C     PORDDTL       BEGSR
     C                   EXSR      SORDDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SSHIPH        BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'SHIPHDPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SHREC.SHSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SHREC.SHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHVERSION'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SHREC.SHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SHREC.SHDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SHREC.SHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SHREC.SHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHNLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SHREC.SHNLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHSETTL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SHREC.SHSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SHAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SHREC.SHAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     ASHIPH        BEGSR
     C                   EXSR      SSHIPH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'SHIPHDPF'
     C                   EXSR      MAPPENDAUD
     C                   ENDSR


     C     PSHIPH        BEGSR
     C                   EXSR      SSHIPH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SSHIPD        BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'SHIPDTPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SDREC.SDSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SDREC.SDLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SDREC.SDORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDORDLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SDREC.SDORDLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SDREC.SDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDWH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SDREC.SDWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDQTY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SDREC.SDQTY)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SDAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SDREC.SDAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     ASHIPD        BEGSR
     C                   EXSR      SSHIPD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'SHIPDTPF'
     C                   EXSR      MAPPENDAUD
     C                   ENDSR


     C     PSHIPD        BEGSR
     C                   EXSR      SSHIPD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SRTNH         BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'RTNHDRPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RHRETURN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RHREC.RHRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RHORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RHREC.RHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RHDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RHREC.RHDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RHSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RHREC.RHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RHREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RHREC.RHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RHNLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RHREC.RHNLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RHAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RHREC.RHAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     ARTNH         BEGSR
     C                   EXSR      SRTNH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'RTNHDRPF'
     C                   EXSR      MAPPENDAUD
     C                   ENDSR


     C     PRTNH         BEGSR
     C                   EXSR      SRTNH
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SRTND         BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'RTNDTLPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDRETURN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RDREC.RDRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RDREC.RDLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RDREC.RDSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDSHLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RDREC.RDSHLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RDREC.RDORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RDREC.RDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDWH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RDREC.RDWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDQTY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RDREC.RDQTY)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RDREC.RDAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'RDSETTL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RDREC.RDSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     ARTND         BEGSR
     C                   EXSR      SRTND
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'RTNDTLPF'
     C                   EXSR      MAPPENDAUD
     C                   ENDSR


     C     PRTND         BEGSR
     C                   EXSR      SRTND
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SSETHEAD      BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'SETLHDPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEID'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEKIND'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEKIND
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SESHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SERETURN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SERETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEORIG'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEORIG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SECREATED'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SECREATED
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SESTATE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SEAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEFIRSTDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEFIRSTDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEATTEMPT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SEATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SELASTMSG'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SELASTMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SENLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SENLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SERETRY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SERETRY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SEREASON'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     PSETHEAD      BEGSR
     C                   EXSR      SSETHEAD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SSETDTL       BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'SETLDTPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLSETTL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SLREC.SLSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SLREC.SLLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SLREC.SLSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLSHLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SLREC.SLSHLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLRETURN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SLREC.SLRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLRTLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SLREC.SLRTLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SLREC.SLORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLORDLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SLREC.SLORDLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLQTY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SLREC.SLQTY)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SLAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SLREC.SLAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     PSETDTL       BEGSR
     C                   EXSR      SSETDTL
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SOUTREC       BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'OUTBOXPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBID'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBKIND'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBKIND
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBBIZID'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBBIZID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBBATCH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBBATCH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBINPUT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OUTREC.OBINPUT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBSTATE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBRESULT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBRESULT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBRESDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBRESDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBATTEMPT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OUTREC.OBATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBLEN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OUTREC.OBLEN)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBREASON'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = OUTREC.OBREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     POUTREC       BEGSR
     C                   EVAL      WIREKEEP = OUTREC
     C                   EVAL      WIRESAVE = OUTREC.OBPAYLOAD
     C                   EXSR      SOUTREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STARTPOS = 1
     C                   EVAL      SEGMAX = %len(%trimr(WIRESAVE))
     C                   DOW       STARTPOS <= SEGMAX
     C                   EVAL      HLEN = SEGMAX - STARTPOS + 1
     C                   IF        HLEN > 8000
     C                   EVAL      HLEN = 8000
     C                   ENDIF
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'OUTBOXPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'OBPAYLOAD'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STARTPOS)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SEGMAX)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %subst(WIRESAVE:STARTPOS:HLEN)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STARTPOS = STARTPOS + HLEN
     C                   ENDDO
     C                   ENDSR


     C     SDAYHEAD      BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'DAYRPTPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYSNAP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYSNAP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYKIND'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYKIND
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYSTATE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYSETTL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYAMOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYPOS'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYPOS)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYNEG'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYNEG)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYCOUNT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYCOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'DYRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     PDAYHEAD      BEGSR
     C                   EXSR      SDAYHEAD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     SAUDIT        BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'AUDITPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUID'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUBATCH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUBATCH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUINPUT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(AUREC.AUINPUT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUEVENT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AURETURN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AURETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUSETTL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUMSG'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUACTOR'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUACTOR
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUREASON'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AURC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AURC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUBEFORE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUBEFORE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUAFTER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUAFTER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     PAUDIT        BEGSR
     C                   EXSR      SAUDIT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STARTPOS = 1
     C                   EVAL      SEGMAX = %len(%trimr(AUREC.AUDETAIL))
     C                   DOW       STARTPOS <= SEGMAX
     C                   EVAL      HLEN = SEGMAX - STARTPOS + 1
     C                   IF        HLEN > 8000
     C                   EVAL      HLEN = 8000
     C                   ENDIF
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'AUDITPF'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'AUDETAIL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STARTPOS)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SEGMAX)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = AUREC.AUID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %subst(AUREC.AUDETAIL:STARTPOS:HLEN)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STARTPOS = STARTPOS + HLEN
     C                   ENDDO
     C                   ENDSR



     C     AOLDALLOC     BEGSR
     C                   FOR       I = 1 to 300
     C                   IF        STKOLD(I).SPUSE = 'Y'
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'ALLOCATION_BEFORE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPWH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPONHAND'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPONHAND)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPRESVD'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPRESVD)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPONDELTA'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPONDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPRSDELTA'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPRSDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPOLDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDRES'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPOLDRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPOLDSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDREL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPOLDREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPNEWRES'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPNEWRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPNEWSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPNEWSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPNEWREL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKOLD(I).SPNEWREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPUSE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKOLD(I).SPUSE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'ALLOCPF'
     C                   EXSR      MAPPENDAUD
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR



     C     PSTOCKVIEW    BEGSR
     C                   FOR       I = 1 to 300
     C                   IF        STKNEW(I).SPUSE = 'Y'
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'STOCK_ALLOCATION_VIEW'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPWH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPONHAND'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPONHAND)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPRESVD'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPRESVD)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPONDELTA'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPONDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPRSDELTA'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPRSDELTA)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPOLDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDRES'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPOLDRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPOLDSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPOLDREL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPOLDREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPNEWRES'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPNEWRES)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPNEWSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPNEWSHIP)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPNEWREL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(STKNEW(I).SPNEWREL)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'SPUSE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = STKNEW(I).SPUSE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR



     C     MRECONCILE    BEGSR
     C                   CLEAR     RECSHIPQ
     C                   CLEAR     RECSHIPA
     C                   EXSR      MRECSHIPS
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MRECRETURNS
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MRECSETTLES
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to ORDCNT
     C                   IF        not ( RECSHIPQ(I) = ORDLINES(I).ODSHIPPED )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_HISTORY_QUANTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RECSHIPA(I) = ORDLINES(I).ODSHPAMT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_HISTORY_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR


     C     MRECSHIPS     BEGSR
     C     *LOVAL        SETLL     SHIPHDPF
     C                   READ      SHIPHDPF      SHREC
     C                   DOW       not %eof(SHIPHDPF)
     C                   IF        SHREC.SHORDER = CTXDS.CXORDER
     C                   EVAL      SHSAVED = SHREC
     C                   EVAL      SHIPKEY = SHREC.SHSHIP
     C                   EVAL      CHECKCOUNT = 0
     C                   EVAL      CHECKAMT = 0
     C                   EVAL      IDENT = SHREC.SHSHIP
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SHREC.SHSHIP <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_IDENTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SHREC.SHNLINE >= 1 and SHREC.SHNLINE <=
     C                             100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DOCUMENT_COUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SHREC.SHAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DOCUMENT_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SHREC.SHVERSION > 1 and SHREC.SHVERSION
     C                             <= ORDERKEEP.OHVERSION )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_VERSION_HISTORY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SHREC.SHSRC <> *blanks and SHREC.SHREQ
     C                             <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_REQUEST_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKDAY = SHREC.SHDAY
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SHREC.SHDAY >= ORDERKEEP.OHDAY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_BEFORE_ORDER_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKID = 'S:' + %trim(SHREC.SHSHIP)
     C                   IF        not ( SHREC.SHSETTL = CHECKID )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_SETTLEMENT_ID_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSDSHIP = SHIPKEY
     C     KSHIPD1       SETLL     SHIPDTPF
     C                   EVAL      KSDSHIP = SHIPKEY
     C     KSHIPD1       READE     SHIPDTPF      SDREC
     C                   DOW       not %eof(SHIPDTPF)
     C                   EVAL      SDSAVED = SDREC
     C                   EVAL      CHECKCOUNT = CHECKCOUNT + 1
     C                   IF        not ( CHECKCOUNT <= 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DETAIL_CAPACITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDLINE = CHECKCOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DETAIL_SEQUENCE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDSHIP = SHIPKEY and
     C                             SDREC.SDORDER = CTXDS.CXORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DETAIL_OWNER_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDQTY > 0 and SDREC.SDQTY <= 9999
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DETAIL_QUANTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DETAIL_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDWH = 'A' or SDREC.SDWH = 'B' or
     C                             SDREC.SDWH = 'C' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DETAIL_WAREHOUSE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      LINEIX = 0
     C                   FOR       J = 1 to ORDCNT
     C                   IF        ORDLINES(J).ODLINE = SDREC.SDORDLINE
     C                   EVAL      LINEIX = J
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        not ( LINEIX > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_ORDER_LINE_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDITEM = ORDLINES(LINEIX).ODITEM
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_ITEM_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RECSHIPQ(LINEIX) = RECSHIPQ(LINEIX) +
     C                             SDREC.SDQTY
     C                   EVAL      RECSHIPA(LINEIX) = RECSHIPA(LINEIX) +
     C                             SDREC.SDAMOUNT
     C                   IF        not ( RECSHIPQ(LINEIX) <=
     C                             ORDLINES(LINEIX).ODQTY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_HISTORY_EXCEEDS_ORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RECSHIPA(LINEIX) <=
     C                             ORDLINES(LINEIX).ODAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'SHIP_HISTORY_EXCEEDS_AMOUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKAMT = CHECKAMT + SDREC.SDAMOUNT
     C                   EXSR      MRECRETQ
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SDREC = SDSAVED
     C                   EVAL      KSDSHIP = SHIPKEY
     C     KSHIPD1       READE     SHIPDTPF      SDREC
     C                   ENDDO
     C                   IF        not ( CHECKCOUNT = SHSAVED.SHNLINE and
     C                             CHECKAMT = SHSAVED.SHAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_DOCUMENT_TOTAL_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSEID = SHSAVED.SHSETTL
     C     KSETLH        CHAIN     SETLHDPF      SEREC
     C                   IF        not ( %found(SETLHDPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_SETTLEMENT_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SEREC.SEKIND = 'P' and SEREC.SESHIP =
     C                             SHSAVED.SHSHIP and SEREC.SERETURN = *blanks
     C                             and SEREC.SEORIG = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'POSITIVE_SETTLEMENT_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SEREC.SEORDER = SHSAVED.SHORDER and
     C                             SEREC.SEAMOUNT = SHSAVED.SHAMOUNT and
     C                             SEREC.SENLINE = SHSAVED.SHNLINE )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'POSITIVE_SETTLEMENT_TOTAL_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   READ      SHIPHDPF      SHREC
     C                   ENDDO
     C                   ENDSR



     C     MRECRETQ      BEGSR
     C                   EVAL      REFQTY = 0
     C                   EVAL      REFAMT = 0
     C     *LOVAL        SETLL     RTNDTLPF
     C                   READ      RTNDTLPF      RDREC
     C                   DOW       not %eof(RTNDTLPF)
     C                   IF        RDREC.RDSHIP = SDSAVED.SDSHIP and
     C                             RDREC.RDSHLINE = SDSAVED.SDLINE
     C                   IF        not ( RDREC.RDQTY > 0 and RDREC.RDAMOUNT >= 0
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_DETAIL_RANGE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RDREC.RDITEM = SDSAVED.SDITEM and
     C                             RDREC.RDWH = SDSAVED.SDWH and RDREC.RDORDER =
     C                             SDSAVED.SDORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_ORIGINAL_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      REFQTY = REFQTY + RDREC.RDQTY
     C                   EVAL      REFAMT = REFAMT + RDREC.RDAMOUNT
     C                   ENDIF
     C                   READ      RTNDTLPF      RDREC
     C                   ENDDO
     C                   IF        not ( REFQTY <= SDSAVED.SDQTY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_HISTORY_EXCEEDS_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( REFAMT <= SDSAVED.SDAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_HISTORY_EXCEEDS_AMOUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      WIDE = SDSAVED.SDAMOUNT * REFQTY /
     C                             SDSAVED.SDQTY
     C                   IF        not ( %dech(WIDE:15:2) = REFAMT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_CUMULATIVE_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MRECRETURNS   BEGSR
     C     *LOVAL        SETLL     RTNHDRPF
     C                   READ      RTNHDRPF      RHREC
     C                   DOW       not %eof(RTNHDRPF)
     C                   IF        RHREC.RHORDER = CTXDS.CXORDER
     C                   EVAL      RHSAVED = RHREC
     C                   EVAL      RETURNKEY = RHREC.RHRETURN
     C                   EVAL      CHECKCOUNT = 0
     C                   EVAL      CHECKAMT = 0
     C                   EVAL      IDENT = RHREC.RHRETURN
     C                   EXSR      MIDENT
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RHREC.RHRETURN <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_IDENTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RHREC.RHNLINE >= 1 and RHREC.RHNLINE <=
     C                             100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_DOCUMENT_COUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RHREC.RHAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_DOCUMENT_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RHREC.RHSRC <> *blanks and RHREC.RHREQ
     C                             <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_REQUEST_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKDAY = RHREC.RHDAY
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KRDRETURN = RETURNKEY
     C     KRTND1        SETLL     RTNDTLPF
     C                   EVAL      KRDRETURN = RETURNKEY
     C     KRTND1        READE     RTNDTLPF      RDREC
     C                   DOW       not %eof(RTNDTLPF)
     C                   EVAL      RDSAVED = RDREC
     C                   EVAL      CHECKCOUNT = CHECKCOUNT + 1
     C                   IF        not ( CHECKCOUNT <= 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_DOCUMENT_CAPACITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RDREC.RDLINE > 0 and RDREC.RDRETURN =
     C                             RETURNKEY and RDREC.RDORDER = CTXDS.CXORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_DETAIL_IDENTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RDREC.RDQTY > 0 and RDREC.RDQTY <= 9999
     C                             and RDREC.RDAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_DETAIL_VALUES_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSDSHIP = RDREC.RDSHIP
     C                   EVAL      KSDLINE = RDREC.RDSHLINE
     C     KSHIPD        CHAIN(N)  SHIPDTPF      SDREC
     C                   IF        not ( %found(SHIPDTPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_ORIGINAL_DETAIL_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDORDER = RDSAVED.RDORDER and
     C                             SDREC.SDITEM = RDSAVED.RDITEM and SDREC.SDWH
     C                             = RDSAVED.RDWH )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_ORIGINAL_DETAIL_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSHSHIP = RDSAVED.RDSHIP
     C     KSHIPH        CHAIN(N)  SHIPHDPF      SHREC
     C                   IF        not ( %found(SHIPHDPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_ORIGINAL_HEADER_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKDAY = SHREC.SHDAY
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      N =
     C                             %diff(%date(RHSAVED.RHDAY:*ISO0):WORKDAY:*D)
     C                   IF        not ( N >= 0 and N <= 30 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_HISTORY_WINDOW_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKID = 'A:' + %trim(RETURNKEY) + ':' +
     C                             %trim(RDSAVED.RDSHIP)
     C                   IF        not ( RDSAVED.RDSETTL = CHECKID )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_ADJUSTMENT_ID_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSEID = CHECKID
     C     KSETLH        CHAIN     SETLHDPF      SEREC
     C                   IF        not ( %found(SETLHDPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_ADJUSTMENT_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SEREC.SEKIND = 'R' and SEREC.SERETURN =
     C                             RETURNKEY and SEREC.SESHIP = RDSAVED.RDSHIP
     C                             and SEREC.SEORDER = CTXDS.CXORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETURN_ADJUSTMENT_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKAMT = CHECKAMT + RDSAVED.RDAMOUNT
     C                   EVAL      RDREC = RDSAVED
     C                   EVAL      KRDRETURN = RETURNKEY
     C     KRTND1        READE     RTNDTLPF      RDREC
     C                   ENDDO
     C                   IF        not ( CHECKCOUNT = RHSAVED.RHNLINE and
     C                             CHECKAMT = RHSAVED.RHAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_DOCUMENT_TOTAL_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   READ      RTNHDRPF      RHREC
     C                   ENDDO
     C                   ENDSR



     C     MRECSETTLES   BEGSR
     C     *LOVAL        SETLL     SETLHDPF
     C                   READ      SETLHDPF      SEREC
     C                   DOW       not %eof(SETLHDPF)
     C                   IF        SEREC.SEORDER = CTXDS.CXORDER
     C                   EVAL      SESAVED = SEREC
     C                   EVAL      CHECKID = SEREC.SEID
     C                   EXSR      MRECSESTATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKCOUNT = 0
     C                   EVAL      CHECKAMT = 0
     C                   EVAL      KSLSETTL = CHECKID
     C     KSETLD1       SETLL     SETLDTPF
     C                   EVAL      KSLSETTL = CHECKID
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   DOW       not %eof(SETLDTPF)
     C                   EVAL      SLTRACE = SLREC
     C                   EVAL      CHECKCOUNT = CHECKCOUNT + 1
     C                   IF        not ( CHECKCOUNT <= 100 and SLREC.SLLINE =
     C                             CHECKCOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_DETAIL_SEQUENCE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SLREC.SLORDER = CTXDS.CXORDER and
     C                             SLREC.SLSHIP = SESAVED.SESHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_DETAIL_OWNER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SLREC.SLQTY > 0 and SLREC.SLAMOUNT >= 0
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_DETAIL_VALUES'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSDSHIP = SLREC.SLSHIP
     C                   EVAL      KSDLINE = SLREC.SLSHLINE
     C     KSHIPD        CHAIN(N)  SHIPDTPF      SDREC
     C                   IF        not ( %found(SHIPDTPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'SETTLEMENT_SHIP_DETAIL_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SDREC.SDORDER = SLTRACE.SLORDER and
     C                             SDREC.SDORDLINE = SLTRACE.SLORDLINE )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_ORDER_LINE_LINK'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SESAVED.SEKIND = 'P'
     C                   IF        not ( SLTRACE.SLRETURN = *blanks and
     C                             SLTRACE.SLRTLINE = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'POSITIVE_RETURN_FIELDS_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SLTRACE.SLQTY = SDREC.SDQTY and
     C                             SLTRACE.SLAMOUNT = SDREC.SDAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'POSITIVE_SOURCE_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( SLTRACE.SLRETURN = SESAVED.SERETURN and
     C                             SLTRACE.SLRTLINE > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_RETURN_REFERENCE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KRDRETURN = SLTRACE.SLRETURN
     C                   EVAL      KRDLINE = SLTRACE.SLRTLINE
     C     KRTND         CHAIN(N)  RTNDTLPF      RDREC
     C                   IF        not ( %found(RTNDTLPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_RETURN_DETAIL_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RDREC.RDSETTL = SESAVED.SEID and
     C                             RDREC.RDSHIP = SLTRACE.SLSHIP and
     C                             RDREC.RDSHLINE = SLTRACE.SLSHLINE )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_PHYSICAL_LINK_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RDREC.RDQTY = SLTRACE.SLQTY and
     C                             RDREC.RDAMOUNT = SLTRACE.SLAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_SOURCE_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CHECKAMT = CHECKAMT + SLTRACE.SLAMOUNT
     C                   EVAL      SLREC = SLTRACE
     C                   EVAL      KSLSETTL = CHECKID
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   ENDDO
     C                   IF        not ( CHECKCOUNT = SESAVED.SENLINE and
     C                             CHECKAMT = SESAVED.SEAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_DOCUMENT_TOTAL'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   READ      SETLHDPF      SEREC
     C                   ENDDO
     C                   ENDSR



     C     MRECSESTATE   BEGSR
     C                   IF        not ( SESAVED.SEID <> *blanks and
     C                             SESAVED.SESHIP <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_IDENTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SEKIND = 'P' or SESAVED.SEKIND
     C                             = 'R' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_KIND_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SENLINE >= 1 and
     C                             SESAVED.SENLINE <= 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_COUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SEAMOUNT >= 0 and
     C                             SESAVED.SEATTEMPT >= 1 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'SETTLEMENT_AMOUNT_ATTEMPT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SELASTMSG <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'SETTLEMENT_OUTBOX_LINK_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SERETRY = 'Y' or
     C                             SESAVED.SERETRY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_RETRY_FLAG_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKDAY = SESAVED.SECREATED
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SESAVED.SEKIND = 'P'
     C                   EVAL      REFID = 'S:' + %trim(SESAVED.SESHIP)
     C                   IF        not ( SESAVED.SEID = REFID and
     C                             SESAVED.SERETURN = *blanks and SESAVED.SEORIG
     C                             = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'POSITIVE_IDENTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      REFID = 'A:' + %trim(SESAVED.SERETURN) + ':'
     C                             + %trim(SESAVED.SESHIP)
     C                   IF        not ( SESAVED.SEID = REFID and
     C                             SESAVED.SERETURN <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ADJUSTMENT_IDENTITY_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      REFID = 'S:' + %trim(SESAVED.SESHIP)
     C                   IF        not ( SESAVED.SEORIG = REFID )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_ORIGINAL_ID_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   SELECT
     C                   WHEN      SESAVED.SESTATE = 'NEW'
     C                   IF        not ( SESAVED.SEFIRSTDAY = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'NEW_HAS_SUCCESS_DATE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SERETRY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'NEW_RETRY_FLAG_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      SESAVED.SESTATE = 'SENT'
     C                   IF        not ( SESAVED.SEFIRSTDAY = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SENT_HAS_SUCCESS_DATE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SERETRY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SENT_RETRY_FLAG_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      SESAVED.SESTATE = 'OK'
     C                   IF        not ( SESAVED.SEFIRSTDAY >= SESAVED.SECREATED
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SUCCESS_DATE_ORDER_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKDAY = SESAVED.SEFIRSTDAY
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SERETRY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OK_RETRY_FLAG_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      SESAVED.SESTATE = 'FAIL'
     C                   IF        not ( SESAVED.SEFIRSTDAY = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'FAIL_HAS_SUCCESS_DATE'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      SESAVED.SESTATE = 'UNKNOWN'
     C                   IF        not ( SESAVED.SEFIRSTDAY = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'UNKNOWN_HAS_SUCCESS_DATE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SESAVED.SERETRY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'UNKNOWN_RETRY_FLAG_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   OTHER
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_STATE_DATA'
     C                   LEAVESR
     C                   ENDSL
     C                   ENDSR



     C     MCHECKDATE    BEGSR
     C                   MONITOR
     C                   EVAL      WORKDAY = %date(CHECKDAY:*ISO0)
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PERSISTED_DAY_INVALID'
     C                   LEAVESR
     C                   ENDMON
     C                   ENDSR



     C     AINPUT        BEGSR
     C                   EVAL      AUDKIND = 'INPUT_HEADER'
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'IHBATCH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHBATCH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHSEQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(HDRDS.IHSEQ)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHEVENT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHARRDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHARRDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHARRTIME'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHARRTIME
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHVERSION'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHVERSION
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHCUST'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHCUST
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHPART'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHPART
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHRETURN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHSETTL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHMSG'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHRESULT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHRESULT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHACTION'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHACTION
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHREFSRC'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHREFREQ'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHACTOR'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHACTOR
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHREASON'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IHNLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHNLINE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'INHDRPF'
     C                   EXSR      MAPPENDAUD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to ROWCOUNT
     C                   EVAL      AUDKIND = 'INPUT_DETAIL'
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'IDBATCH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(I).IDBATCH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDINPUT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RAWROWS(I).IDINPUT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDPOS'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RAWROWS(I).IDPOS)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(I).IDLINE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDITEM'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(I).IDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDQTY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(I).IDQTY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDWH'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(I).IDWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(I).IDSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'IDSHLINE'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(I).IDSHLINE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      AUDKEY = 'INDTLPF'
     C                   EXSR      MAPPENDAUD
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR



     C     MCHECKABI     BEGSR
     C                   IF        not ( CHKHEAD.CHLEN >= 4 and CHKHEAD.CHLEN <=
     C                             24000 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_CANON_LENGTH'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( %subst(CHKHEAD.CHCANON:1:4) = '0001' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_CANON_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      POSN = 5
     C                   EVAL      N = 0
     C                   DOW       POSN <= CHKHEAD.CHLEN
     C                   IF        not ( POSN + 3 <= CHKHEAD.CHLEN )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CANON_PARTIAL_LENGTH'
     C                   LEAVESR
     C                   ENDIF
     C                   MONITOR
     C                   EVAL      FLEN =
     C                             %dec(%subst(CHKHEAD.CHCANON:POSN:4):4:0)
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CANON_NONNUMERIC_LENGTH'
     C                   LEAVESR
     C                   ENDMON
     C                   IF        not ( FLEN >= 0 and POSN + 3 + FLEN <=
     C                             CHKHEAD.CHLEN )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CANON_FIELD_RANGE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      POSN = POSN + 4 + FLEN
     C                   EVAL      N = N + 1
     C                   ENDDO
     C                   IF        not ( POSN = CHKHEAD.CHLEN + 1 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'CANON_TRAILING_PARTIAL_FIELD'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( N = 19 + CTXDS.CXCOUNT * 6 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CANON_FIELD_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'CANON'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHCOUNT = CTXDS.CXCOUNT and
     C                             RESDS.RSCOUNT = CTXDS.CXCOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHVERSION >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       X = 1 to CHKHEAD.CHCOUNT
     C                   IF        not ( NORMROWS(X).NRLINE > 0 and
     C                             NORMROWS(X).NRLINE <= 99999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(X).NRQTY > 0 and
     C                             NORMROWS(X).NRQTY <= 9999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_QUANTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NORMROWS(X).NRSHLINE >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_ORIGINAL_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        HDRDS.IHEVENT = 'NEW' or HDRDS.IHEVENT =
     C                             'MOD'
     C                   IF        not ( NORMROWS(X).NRITEM <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_ITEM'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CHKHEAD.CHTIER = 'S' or CHKHEAD.CHTIER
     C                             = 'P' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_TIER'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   FOR       Y = 1 to X - 1
     C                   IF        HDRDS.IHEVENT = 'SHIP'
     C                   IF        not ( NORMROWS(Y).NRLINE <>
     C                             NORMROWS(X).NRLINE or NORMROWS(Y).NRWH <>
     C                             NORMROWS(X).NRWH )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_DUPLICATE_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( NORMROWS(Y).NRLINE <>
     C                             NORMROWS(X).NRLINE )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ABI_DUPLICATE_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   ENDFOR
     C                   ENDSR


     C     MPRICEABI     BEGSR
     C                   IF        not ( RESDS.RSCOUNT = CTXDS.CXCOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( RESDS.RSAMOUNT >= 0 and RESDS.RSAMOUNT
     C                             <= 9999999999999.99 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_TOTAL'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      REFAMT = 0
     C                   FOR       X = 1 to CTXDS.CXCOUNT
     C                   IF        not ( PROUT(X).POLINE = PRIN(X).PILINE )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_LINE_ID'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PROUT(X).POAMOUNT >= 0 and
     C                             PROUT(X).POCUMAMT >= PROUT(X).POAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_AMOUNT_RANGE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PROUT(X).POCUMQTY >= PRIN(X).PIQTY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'PRICE_ABI_CUMULATIVE_QUANTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'QUOTE'
     C                   IF        not ( PROUT(X).POUNIT > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_UNIT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXTIER = 'S'
     C                   IF        not ( PROUT(X).PORATE = 1.0000 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_STANDARD_RATE'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( PROUT(X).PORATE = 0.9500 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_PREFERRED_RATE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WIDE = PRIN(X).PIQTY * PROUT(X).POUNIT *
     C                             PROUT(X).PORATE
     C                   IF        not ( %dech(WIDE:15:2) = PROUT(X).POAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_ROUNDED_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PROUT(X).POCUMAMT = PROUT(X).POAMOUNT
     C                             and PROUT(X).POCUMQTY = PRIN(X).PIQTY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_QUOTE_CUMULATIVE'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      REFQTY = PRIN(X).PIPRIORQ
     C                   EVAL      PREVAMT = PRIN(X).PIPRIORA
     C                   FOR       Y = 1 to X - 1
     C                   IF        PRIN(Y).PIGROUP = PRIN(X).PIGROUP
     C                   EVAL      REFQTY = PROUT(Y).POCUMQTY
     C                   EVAL      PREVAMT = PROUT(Y).POCUMAMT
     C                   ENDIF
     C                   ENDFOR
     C                   IF        not ( PROUT(X).POCUMQTY = REFQTY +
     C                             PRIN(X).PIQTY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_GROUP_QUANTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PROUT(X).POCUMQTY <= PRIN(X).PIBASEQTY
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_ORIGINAL_LIMIT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PROUT(X).POCUMAMT <= PRIN(X).PIBASEAMT
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_ORIGINAL_AMOUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PROUT(X).POAMOUNT = PROUT(X).POCUMAMT -
     C                             PREVAMT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_DELTA_AMOUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      WIDE = PRIN(X).PIBASEAMT * PROUT(X).POCUMQTY
     C                             / PRIN(X).PIBASEQTY
     C                   IF        not ( %dech(WIDE:15:2) = PROUT(X).POCUMAMT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_PROPORTION'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      REFAMT = REFAMT + PROUT(X).POAMOUNT
     C                   ENDFOR
     C                   IF        not ( REFAMT = RESDS.RSAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ABI_DOCUMENT_TOTAL'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     MSTOCKABI     BEGSR
     C                   IF        not ( RESDS.RSCOUNT >= 0 and RESDS.RSCOUNT <=
     C                             300 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_ABI_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       X = 1 to 300
     C                   IF        not ( STKOLD(X).SPUSE = 'N' or
     C                             STKOLD(X).SPUSE = 'Y' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_USE_FLAG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        STKOLD(X).SPUSE = 'Y'
     C                   IF        not ( STKOLD(X).SPLINE > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPITEM <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_ITEM'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPWH = 'A' or STKOLD(X).SPWH
     C                             = 'B' or STKOLD(X).SPWH = 'C' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_WAREHOUSE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPONHAND >= STKOLD(X).SPRESVD
     C                             and STKOLD(X).SPRESVD >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_STOCK_SNAPSHOT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPOLDRES >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_SPOLDRES'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPOLDSHIP >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_SPOLDSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPOLDREL >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_SPOLDREL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPNEWRES >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_SPNEWRES'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPNEWSHIP >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_SPNEWSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPNEWREL >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_SPNEWREL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXEVENT <> 'MOD' and CTXDS.CXEVENT <>
     C                             'RETURN'
     C                   IF        not ( STKOLD(X).SPOLDITEM = *blanks or
     C                             STKOLD(X).SPOLDITEM = STKOLD(X).SPITEM )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_ITEM_SNAPSHOT'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'VIEW'
     C                   IF        not ( STKOLD(X).SPONDELTA = 0 and
     C                             STKOLD(X).SPRSDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_READONLY_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPNEWRES = STKOLD(X).SPOLDRES
     C                             and STKOLD(X).SPNEWSHIP = STKOLD(X).SPOLDSHIP
     C                             and STKOLD(X).SPNEWREL = STKOLD(X).SPOLDREL )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_READONLY_ALLOCATION'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   SELECT
     C                   WHEN      CTXDS.CXEVENT = 'NEW'
     C                   IF        not ( STKOLD(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_NEW_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPRSDELTA >= 0 and
     C                             STKOLD(X).SPNEWSHIP = STKOLD(X).SPOLDSHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKOLD_NEW_RESERVATION_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'MOD'
     C                   IF        not ( STKOLD(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_MOD_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'ALLOC'
     C                   IF        not ( STKOLD(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_ALLOC_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPRSDELTA >= 0 and
     C                             STKOLD(X).SPNEWSHIP = STKOLD(X).SPOLDSHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKOLD_ALLOC_RESERVATION_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'CANCEL'
     C                   IF        not ( STKOLD(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_CANCEL_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPRSDELTA <= 0 and
     C                             STKOLD(X).SPNEWSHIP = STKOLD(X).SPOLDSHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKOLD_CANCEL_NO_SHIPMENT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPNEWREL - STKOLD(X).SPOLDREL
     C                             = - STKOLD(X).SPRSDELTA )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKOLD_CANCEL_RELEASE_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'SHIP'
     C                   IF        not ( STKOLD(X).SPONDELTA =
     C                             STKOLD(X).SPRSDELTA and STKOLD(X).SPONDELTA
     C                             <= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKOLD_SHIP_DOUBLE_DECREMENT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKOLD(X).SPNEWSHIP -
     C                             STKOLD(X).SPOLDSHIP = - STKOLD(X).SPONDELTA )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKOLD_SHIP_ALLOCATION_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'RETURN'
     C                   IF        not ( STKOLD(X).SPONDELTA > 0 and
     C                             STKOLD(X).SPRSDELTA = 0 and
     C                             STKOLD(X).SPNEWRES = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKOLD_RETURN_NO_ALLOCATION'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   FOR       Y = 1 to X - 1
     C                   IF        STKOLD(Y).SPUSE = 'Y'
     C                   IF        not ( STKOLD(Y).SPLINE <> STKOLD(X).SPLINE or
     C                             STKOLD(Y).SPWH <> STKOLD(X).SPWH )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKOLD_DUPLICATE_ALLOCATION'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   ENDIF
     C                   ENDFOR
     C                   FOR       X = 1 to 300
     C                   IF        not ( STKNEW(X).SPUSE = 'N' or
     C                             STKNEW(X).SPUSE = 'Y' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_USE_FLAG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        STKNEW(X).SPUSE = 'Y'
     C                   IF        not ( STKNEW(X).SPLINE > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPITEM <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_ITEM'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPWH = 'A' or STKNEW(X).SPWH
     C                             = 'B' or STKNEW(X).SPWH = 'C' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_WAREHOUSE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPONHAND >= STKNEW(X).SPRESVD
     C                             and STKNEW(X).SPRESVD >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_STOCK_SNAPSHOT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPOLDRES >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_SPOLDRES'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPOLDSHIP >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_SPOLDSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPOLDREL >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_SPOLDREL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPNEWRES >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_SPNEWRES'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPNEWSHIP >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_SPNEWSHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPNEWREL >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_SPNEWREL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXEVENT <> 'MOD' and CTXDS.CXEVENT <>
     C                             'RETURN'
     C                   IF        not ( STKNEW(X).SPOLDITEM = *blanks or
     C                             STKNEW(X).SPOLDITEM = STKNEW(X).SPITEM )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_ITEM_SNAPSHOT'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'VIEW'
     C                   IF        not ( STKNEW(X).SPONDELTA = 0 and
     C                             STKNEW(X).SPRSDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_READONLY_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPNEWRES = STKNEW(X).SPOLDRES
     C                             and STKNEW(X).SPNEWSHIP = STKNEW(X).SPOLDSHIP
     C                             and STKNEW(X).SPNEWREL = STKNEW(X).SPOLDREL )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_READONLY_ALLOCATION'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   SELECT
     C                   WHEN      CTXDS.CXEVENT = 'NEW'
     C                   IF        not ( STKNEW(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_NEW_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPRSDELTA >= 0 and
     C                             STKNEW(X).SPNEWSHIP = STKNEW(X).SPOLDSHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKNEW_NEW_RESERVATION_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'MOD'
     C                   IF        not ( STKNEW(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_MOD_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'ALLOC'
     C                   IF        not ( STKNEW(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_ALLOC_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPRSDELTA >= 0 and
     C                             STKNEW(X).SPNEWSHIP = STKNEW(X).SPOLDSHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKNEW_ALLOC_RESERVATION_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'CANCEL'
     C                   IF        not ( STKNEW(X).SPONDELTA = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_CANCEL_ONHAND_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPRSDELTA <= 0 and
     C                             STKNEW(X).SPNEWSHIP = STKNEW(X).SPOLDSHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STKNEW_CANCEL_NO_SHIPMENT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPNEWREL - STKNEW(X).SPOLDREL
     C                             = - STKNEW(X).SPRSDELTA )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKNEW_CANCEL_RELEASE_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'SHIP'
     C                   IF        not ( STKNEW(X).SPONDELTA =
     C                             STKNEW(X).SPRSDELTA and STKNEW(X).SPONDELTA
     C                             <= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKNEW_SHIP_DOUBLE_DECREMENT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKNEW(X).SPNEWSHIP -
     C                             STKNEW(X).SPOLDSHIP = - STKNEW(X).SPONDELTA )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKNEW_SHIP_ALLOCATION_DELTA'
     C                   LEAVESR
     C                   ENDIF
     C                   WHEN      CTXDS.CXEVENT = 'RETURN'
     C                   IF        not ( STKNEW(X).SPONDELTA > 0 and
     C                             STKNEW(X).SPRSDELTA = 0 and
     C                             STKNEW(X).SPNEWRES = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKNEW_RETURN_NO_ALLOCATION'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   FOR       Y = 1 to X - 1
     C                   IF        STKNEW(Y).SPUSE = 'Y'
     C                   IF        not ( STKNEW(Y).SPLINE <> STKNEW(X).SPLINE or
     C                             STKNEW(Y).SPWH <> STKNEW(X).SPWH )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'STKNEW_DUPLICATE_ALLOCATION'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR



     C     MSETTLEABI    BEGSR
     C                   IF        CTXDS.CXACTION = 'LOOKUP'
     C                   EXSR      MSETVIEWABI
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEID <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_ID'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEKIND = 'P' or SETHEAD.SEKIND
     C                             = 'R' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_KIND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SESHIP <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_SHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_ORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SENLINE >= 1 and
     C                             SETHEAD.SENLINE <= 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_AMOUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEATTEMPT >= 1 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_ATTEMPT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SELASTMSG <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_LAST_MESSAGE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SERETRY = 'Y' or
     C                             SETHEAD.SERETRY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_RETRY_FLAG'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKDAY = SETHEAD.SECREATED
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SETHEAD.SESTATE = 'OK'
     C                   EVAL      CHECKDAY = SETHEAD.SEFIRSTDAY
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEFIRSTDAY >= SETHEAD.SECREATED
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_SUCCESS_DATE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SERETRY = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_SUCCESS_RETRY'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( SETHEAD.SEFIRSTDAY = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_PENDING_DATE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SESTATE = 'NEW' or
     C                             SETHEAD.SESTATE = 'SENT' or SETHEAD.SESTATE =
     C                             'FAIL' or SETHEAD.SESTATE = 'UNKNOWN' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_PENDING_STATE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        SETHEAD.SEKIND = 'P'
     C                   EVAL      REFID = 'S:' + %trim(SETHEAD.SESHIP)
     C                   IF        not ( SETHEAD.SEID = REFID and
     C                             SETHEAD.SERETURN = *blanks and SETHEAD.SEORIG
     C                             = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_POSITIVE_ID'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      REFID = 'A:' + %trim(SETHEAD.SERETURN) + ':'
     C                             + %trim(SETHEAD.SESHIP)
     C                   IF        not ( SETHEAD.SEID = REFID and
     C                             SETHEAD.SERETURN <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_ADJUSTMENT_ID'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      REFID = 'S:' + %trim(SETHEAD.SESHIP)
     C                   IF        not ( SETHEAD.SEORIG = REFID )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_ORIGINAL_ID'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        not ( OUTREC.OBBIZID = SETHEAD.SEID and
     C                             OUTREC.OBORDER = SETHEAD.SEORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_MESSAGE_OWNER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBKIND = 'SETTLE' or
     C                             OUTREC.OBKIND = 'ADJUST' or OUTREC.OBKIND =
     C                             'VERIFY' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_MESSAGE_KIND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBATTEMPT <= SETHEAD.SEATTEMPT
     C                             and OUTREC.OBATTEMPT > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_MESSAGE_ATTEMPT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'FETCH' or CTXDS.CXACTION =
     C                             'CREATE' or CTXDS.CXACTION = 'RETRY' or
     C                             CTXDS.CXACTION = 'VERIFY'
     C                   EVAL      REFAMT = 0
     C                   FOR       X = 1 to SETHEAD.SENLINE
     C                   IF        not ( SETROWS(X).SLSETTL = SETHEAD.SEID and
     C                             SETROWS(X).SLLINE = X )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_DETAIL_KEY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETROWS(X).SLSHIP = SETHEAD.SESHIP and
     C                             SETROWS(X).SLORDER = SETHEAD.SEORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_DETAIL_OWNER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETROWS(X).SLSHLINE > 0 and
     C                             SETROWS(X).SLORDLINE > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_ORIGINAL_LINES'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETROWS(X).SLQTY > 0 and
     C                             SETROWS(X).SLAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_DETAIL_AMOUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SETHEAD.SEKIND = 'P'
     C                   IF        not ( SETROWS(X).SLRETURN = *blanks and
     C                             SETROWS(X).SLRTLINE = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_POSITIVE_DETAIL'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( SETROWS(X).SLRETURN = SETHEAD.SERETURN
     C                             and SETROWS(X).SLRTLINE > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_RETURN_DETAIL'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      REFAMT = REFAMT + SETROWS(X).SLAMOUNT
     C                   ENDFOR
     C                   IF        not ( REFAMT = SETHEAD.SEAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLE_ABI_DETAIL_TOTAL'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR



     C     MSETVIEWABI   BEGSR
     C                   FOR       X = 1 to 100
     C                   IF        SETVIEW(X).SVSHLINE > 0
     C                   IF        not ( SETVIEW(X).SVSUCCQTY >= 0 and
     C                             SETVIEW(X).SVSUCCAMT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_VIEW_SUCCEEDED_RANGE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETVIEW(X).SVPENDING = *blanks or
     C                             SETVIEW(X).SVPENDING = 'Y' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_VIEW_PENDING_FLAG'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       Y = 1 to X - 1
     C                   IF        not ( SETVIEW(Y).SVSHLINE <>
     C                             SETVIEW(X).SVSHLINE )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ADJUSTMENT_VIEW_DUPLICATE_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ELSE
     C                   IF        not ( SETVIEW(X).SVSHLINE = 0 and
     C                             SETVIEW(X).SVSUCCQTY = 0 and
     C                             SETVIEW(X).SVSUCCAMT = 0 and
     C                             SETVIEW(X).SVPENDING = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ADJUSTMENT_VIEW_UNUSED_ROW'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR



     C     MREPLYABI     BEGSR
     C                   IF        CTXDS.CXACTION = 'LIST' and RESDS.RSCOUNT = 0
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBID <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_ID'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBBATCH <> *blanks and
     C                             OUTREC.OBINPUT > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_INPUT_LINK'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBATTEMPT > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_ATTEMPT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBLEN >= 4 and OUTREC.OBLEN <=
     C                             30000 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_LENGTH'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( %subst(OUTREC.OBPAYLOAD:1:4) = '0001' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBKIND = 'RECEIPT' or
     C                             OUTREC.OBKIND = 'WHRESULT' or OUTREC.OBKIND =
     C                             'SETTLE' or OUTREC.OBKIND = 'ADJUST' or
     C                             OUTREC.OBKIND = 'VERIFY' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_KIND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBSTATE = 'NEW' or
     C                             OUTREC.OBSTATE = 'SENT' or OUTREC.OBSTATE =
     C                             'OK' or OUTREC.OBSTATE = 'FAIL' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_DELIVERY_STATE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBRESULT = 'NONE' or
     C                             OUTREC.OBRESULT = 'OK' or OUTREC.OBRESULT =
     C                             'FAIL' or OUTREC.OBRESULT = 'UNKNOWN' or
     C                             OUTREC.OBRESULT = 'RETRYOK' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_BUSINESS_RESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHECKDAY = OUTREC.OBDAY
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        OUTREC.OBRESULT = 'NONE'
     C                   IF        not ( OUTREC.OBRESDAY = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OUTBOX_ABI_UNREPORTED_DAY'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CHECKDAY = OUTREC.OBRESDAY
     C                   EXSR      MCHECKDATE
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        OUTREC.OBKIND = 'RECEIPT' or OUTREC.OBKIND =
     C                             'WHRESULT'
     C                   IF        not ( OUTREC.OBRESULT = 'NONE' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'REPLY_ABI_NO_BUSINESS_FEEDBACK'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( OUTREC.OBBIZID <> *blanks and
     C                             OUTREC.OBORDER <> *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'FINANCIAL_MESSAGE_BUSINESS_LINK'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'CREATE'
     C                   IF        not ( OUTREC.OBBATCH = RUNBATCH and
     C                             OUTREC.OBINPUT = INPUTNO )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'CREATED_MESSAGE_INPUT_OWNER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OUTREC.OBSRC = CTXDS.CXSRC and
     C                             OUTREC.OBREQ = CTXDS.CXREQ )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'CREATED_MESSAGE_REQUEST_OWNER'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR


     C     MDAILYABI     BEGSR
     C                   IF        not ( DAYHEAD.DYKIND = 'HEADER' and
     C                             DAYHEAD.DYSTATE = 'READY' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_PUBLICATION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( DAYHEAD.DYLINE = 0 and DAYHEAD.DYCOUNT
     C                             >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_LINE_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( DAYHEAD.DYPOS >= 0 and DAYHEAD.DYNEG >=
     C                             0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_TOTAL_SIGNS'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( DAYHEAD.DYAMOUNT = DAYHEAD.DYPOS -
     C                             DAYHEAD.DYNEG )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_NET_EQUATION'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( DAYHEAD.DYSRC = CTXDS.CXSRC and
     C                             DAYHEAD.DYREQ = CTXDS.CXREQ )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_REQUEST_OWNER'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      REFID = %trim(CTXDS.CXSRC) + ':' +
     C                             %trim(CTXDS.CXREQ)
     C                   IF        not ( DAYHEAD.DYSNAP = REFID )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_SNAPSHOT_ID'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'FETCH'
     C                   IF        not ( DAYHEAD.DYDAY = CTXDS.CXDAY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_ORIGINAL_DAY'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( DAYHEAD.DYDAY = CTXDS.CXPROCDAY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_PROCESS_DAY'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        not ( RESDS.RSAMOUNT = DAYHEAD.DYAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ABI_RETURN_TOTAL'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPDETAIL     BEGSR
     C                   IF        ERRORUNIT
     C                   EXSR      MOPREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        DUPLICATE
     C                   EXSR      MOPDUP
     C                   LEAVESR
     C                   ENDIF
     C                   SELECT
     C                   WHEN      HDRDS.IHEVENT = 'NEW'
     C                   EXSR      MOPORDER
     C                   WHEN      HDRDS.IHEVENT = 'MOD'
     C                   EXSR      MOPORDER
     C                   WHEN      HDRDS.IHEVENT = 'ALLOC'
     C                   EXSR      MOPFULFIL
     C                   WHEN      HDRDS.IHEVENT = 'CANCEL'
     C                   EXSR      MOPFULFIL
     C                   WHEN      HDRDS.IHEVENT = 'SHIP'
     C                   EXSR      MOPSHIP
     C                   WHEN      HDRDS.IHEVENT = 'RETURN'
     C                   EXSR      MOPRETURN
     C                   WHEN      HDRDS.IHEVENT = 'SETRES'
     C                   EXSR      MOPSETRES
     C                   WHEN      HDRDS.IHEVENT = 'DELIVER'
     C                   EXSR      MOPDELIVER
     C                   WHEN      HDRDS.IHEVENT = 'RECOVER'
     C                   EXSR      MOPRECOVER
     C                   WHEN      HDRDS.IHEVENT = 'QUERY'
     C                   EXSR      MOPQUERY
     C                   WHEN      HDRDS.IHEVENT = 'DAYEND'
     C                   EXSR      MOPDAY
     C                   ENDSL
     C                   ENDSR



     C     MOPORDER      BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPORDER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'event'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'priorVersion'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OLDHEAD.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'acceptedVersion'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'customer'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHCUST
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'pricingTier'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHTIER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'partialAllowed'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHPART
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'pricingDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHPRCDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'lineCount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHNLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'roundedOrderAmount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'businessState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'reason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPFULFIL     BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPFULFIL'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'event'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'priorVersion'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(OLDHEAD.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'newVersion'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'lineCount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHNLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'frozenOrderAmount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'businessState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'hasPriorShipment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHSHIPANY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestSource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'request'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'reason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     MOPSHIP       BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPSHIP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'shipment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'orderVersion'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'businessDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'shipmentLines'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(CHKHEAD.CHCOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'allocatedShipmentAmount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SHIPAMT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'settlement'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'settlementState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'settlementAttempt'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SEATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'outgoingMessage'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SELASTMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'firstSuccessDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEFIRSTDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'remainingOrderState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPRETURN     BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPRETURN'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'return'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'returnDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'returnLines'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(CHKHEAD.CHCOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'adjustmentGroups'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(GROUPN)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'totalAdjustmentAmount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RETURNAMT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'lastAdjustment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'lastOriginalShipment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'lastAdjustmentState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'orderVersionUnchanged'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'orderDemandState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORDERKEEP.OHSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'reason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPSETRES     BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPSETRES'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'settlement'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'kind'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEKIND
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'shipment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'return'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SERETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalSettlement'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEORIG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'amount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SEAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'previousBusinessState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETKEEP.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'currentBusinessState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'feedbackMessage'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = MSGRESULT.OBID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'feedbackMessageKind'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = MSGRESULT.OBKIND
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'feedbackAttempt'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(MSGRESULT.OBATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'currentBusinessAttempt'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SEATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'feedback'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHRESULT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'firstSuccessDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEFIRSTDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'retryAllowed'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SERETRY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'reason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPDELIVER    BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPDELIVER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'message'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'messageKind'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBKIND
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'businessIdentity'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBBIZID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'deliveryState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'recordedBusinessFeedback'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBRESULT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'businessFeedbackDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = WIREKEEP.OBRESDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'messageAttempt'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(WIREKEEP.OBATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'businessState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'firstBusinessSuccessDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEFIRSTDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestedDeliveryResult'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHRESULT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPRECOVER    BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPRECOVER'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'action'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHACTION
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'actor'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHACTOR
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'reason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'recoverySource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'recoveryRequest'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalSource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalRequest'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalEvent'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORIGRQ.RQEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalBusinessDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = ORIGRQ.RQDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'processingDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RUNDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'shipment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'return'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'settlement'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'message'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'businessState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'resultReason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPQUERY      BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPQUERY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'querySource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'queryRequest'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'referencedSource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'referencedRequest'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREFREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalEvent'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalLedgerState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalResult'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalReason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'order'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'shipment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'return'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'settlement'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'previousReceipt'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     MOPDAY        BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPDAY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'snapshotDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'snapshotIdentity'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYSNAP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'publicationState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'positiveTotal'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYPOS)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'negativeAbsoluteTotal'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYNEG)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'netTotal'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'componentCount'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(DAYHEAD.DYCOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'snapshotSource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'snapshotRequest'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = DAYHEAD.DYREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'processingDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RUNDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPREJECT     BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPREJECT'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'inputBatch'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RUNBATCH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'inputSequence'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(INPUTNO)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestSource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'request'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'event'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestedOrder'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestedShipment'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestedReturn'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestedSettlement'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'requestedMessage'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'result'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'reason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = BUSREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'ledgerState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = REQSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'actor'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXACTOR
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'actorReason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = CTXDS.CXREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     MOPDUP        BEGSR
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   EVAL      TOKEN = 'MOPDUP'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalSource'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalRequest'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalBatch'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQBATCH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalInput'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RQKEEP.RQINPUT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalEvent'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalBusinessDay'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalLedgerState'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQSTATE
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalResult'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalReason'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'originalVersion'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(RQKEEP.RQVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'currentOrderVersion'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(ORDERKEEP.OHVERSION)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'previousReceipt'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RQKEEP.RQMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'currentInputBatch'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RUNBATCH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = 'currentInputSequence'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(INPUTNO)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      MSENDREC
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR


     C     FRAME         BEGSR
     C                   EVAL      TOKLEN = %len(%trimr(TOKEN))
     C                   IF        not ( TOKLEN <= 9999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'FRAME_FIELD_TOO_LONG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PAYLEN + 4 + TOKLEN <= 30000 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PAYLOAD_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      LEN4 = TOKLEN
     C                   EVAL      POSN = PAYLEN + 1
     C                   EVAL      %subst(PAYLOAD:POSN:4) = %editc(LEN4:'X')
     C                   EVAL      PAYLEN = PAYLEN + 4
     C                   IF        TOKLEN > 0
     C                   EVAL      POSN = PAYLEN + 1
     C                   EVAL      %subst(PAYLOAD:POSN:TOKLEN) =
     C                             %subst(TOKEN:1:TOKLEN)
     C                   EVAL      PAYLEN = PAYLEN + TOKLEN
     C                   ENDIF
     C                   ENDSR
