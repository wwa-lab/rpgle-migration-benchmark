

     H DFTACTGRP(*NO) ACTGRP('ORDBENCH')
     H OPTION(*SRCSTMT:*NODEBUGIO) DECEDIT('0.')
     FOUTBOXPF  UF A E           K DISK    COMMIT
     FSETLBYREF IF   E           K DISK    COMMIT
     F                                     RENAME(SETLHDR:SETLRFR)
     FSETLDTPF  UF A E           K DISK    COMMIT
     FSETLHDPF  UF A E           K DISK    COMMIT
      /DEFINE U_CTXDS
      /DEFINE U_SETHEAD
      /DEFINE U_SETROWS
      /DEFINE U_SETVIEW
      /DEFINE U_OUTREC
      /DEFINE U_RESDS
      /COPY QRPGLESRC,ORDCTX
      /COPY QRPGLESRC,ORDRES
      /COPY QRPGLESRC,ORDSTS
     DOBREC            DS                  LIKEREC(OUTBOXR)
     DKOBID            S             80A
     DSFREC            DS                  LIKEREC(SETLRFR)
     DKSESHIP          S             20A
     DKSEKIND          S              1A
     DKSEID            S             48A
     DSLREC            DS                  LIKEREC(SETLDTR)
     DKSLSETTL         S             48A
     DKSLLINE          S              5P 0
     DSEREC            DS                  LIKEREC(SETLHDR)
     DSID              S             48A
     DORIGSHIP         S             20A
     DOLDSEND          S             80A
     DOLDSTATE         S              8A
     DOLDTRY           S              9P 0
     DFOUNDROW         S              5P 0
     DCNT              S              5P 0
     DI                S              9P 0
     DJ                S              9P 0
     DK                S              9P 0
     DN                S              9P 0
     DX                S              9P 0
     DY                S              9P 0
     DPOSN             S              9P 0
     DTOKEN            S          30000A
     DPAYLOAD          S          30000A
     DTOKLEN           S              9P 0
     DPAYLEN           S              9P 0
     DLEN4             S              4S 0
     DTOTAL            S             19P 2
     DTARGET           DS                  LIKEDS(SETHEAD)
     DMSGKEEP          DS                  LIKEDS(OUTREC)

     C     *ENTRY        PLIST
     C                   PARM                    CTXDS
     C                   PARM                    SETHEAD
     C                   PARM                    SETROWS
     C                   PARM                    SETVIEW
     C                   PARM                    OUTREC
     C                   PARM                    RESDS
     C     KOUT          KLIST
     C                   KFLD                    KOBID
     C     KSETRF1       KLIST
     C                   KFLD                    KSESHIP
     C     KSETRF2       KLIST
     C                   KFLD                    KSESHIP
     C                   KFLD                    KSEKIND
     C     KSETRF        KLIST
     C                   KFLD                    KSESHIP
     C                   KFLD                    KSEKIND
     C                   KFLD                    KSEID
     C     KSETLD1       KLIST
     C                   KFLD                    KSLSETTL
     C     KSETLD        KLIST
     C                   KFLD                    KSLSETTL
     C                   KFLD                    KSLLINE
     C     KSETLH        KLIST
     C                   KFLD                    KSEID
     C                   MONITOR
     C                   EXSR      TINIT
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'LOCAL_IO_OR_CONVERSION'
     C                   ENDMON
     C                   EVAL      *inlr = *on
     C                   RETURN



     C     TINIT         BEGSR
     C                   CLEAR     RESDS
     C                   CLEAR     SETVIEW
     C                   EVAL      RESDS.RSRC = RCOK
     C                   IF        not ( CTXDS.CXABI = ABI )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'ABI_MISMATCH'
     C                   LEAVESR
     C                   ENDIF
     C                   SELECT
     C                   WHEN      CTXDS.CXACTION = 'FETCH'
     C                   EXSR      TFETCH
     C                   WHEN      CTXDS.CXACTION = 'LOOKUP'
     C                   EXSR      TLOOK
     C                   WHEN      CTXDS.CXACTION = 'CREATE'
     C                   EXSR      TCREATE
     C                   WHEN      CTXDS.CXACTION = 'APPLY'
     C                   EXSR      TAPPLY
     C                   WHEN      CTXDS.CXACTION = 'RETRY'
     C                   EXSR      TRETRY
     C                   WHEN      CTXDS.CXACTION = 'VERIFY'
     C                   EXSR      TVERIFY
     C                   WHEN      CTXDS.CXACTION = 'DELIVERY'
     C                   EXSR      TDELIV
     C                   OTHER
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_ACTION'
     C                   LEAVESR
     C                   ENDSL
     C                   EXSR      TRET
     C                   ENDSR



     C     TFETCH        BEGSR
     C                   CLEAR     SETHEAD
     C                   CLEAR     SETROWS
     C                   CLEAR     OUTREC
     C                   EVAL      KSEID = CTXDS.CXSETTL
     C     KSETLH        CHAIN(N)  SETLHDPF      SEREC
     C                   IF        not ( %found(SETLHDPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SETHEAD = SEREC
     C                   EVAL      CNT = 0
     C                   EVAL      TOTAL = 0
     C                   EVAL      KSLSETTL = CTXDS.CXSETTL
     C     KSETLD1       SETLL     SETLDTPF
     C                   EVAL      KSLSETTL = CTXDS.CXSETTL
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   DOW       not %eof(SETLDTPF)
     C                   IF        not ( CNT < 100 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_ROW_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CNT = CNT + 1
     C                   EVAL      SETROWS(CNT) = SLREC
     C                   EVAL      TOTAL = TOTAL + SLREC.SLAMOUNT
     C                   EVAL      KSLSETTL = CTXDS.CXSETTL
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   ENDDO
     C                   IF        not ( CNT = SETHEAD.SENLINE and TOTAL =
     C                             SETHEAD.SEAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_TOTAL_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OLDSEND = CTXDS.CXMSG
     C                   IF        OLDSEND = *blanks
     C                   EVAL      OLDSEND = SETHEAD.SELASTMSG
     C                   ENDIF
     C                   EVAL      KOBID = OLDSEND
     C     KOUT          CHAIN(N)  OUTBOXPF      OBREC
     C                   IF        not ( %found(OUTBOXPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_MESSAGE_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OBREC.OBBIZID = SETHEAD.SEID )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_MESSAGE_LINK'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OUTREC = OBREC
     C                   ENDSR




     C     TLOOK         BEGSR
     C                   EVAL      ORIGSHIP = CTXDS.CXSHIP
     C                   EVAL      KSESHIP = ORIGSHIP
     C     KSETRF1       SETLL     SETLBYREF
     C                   EVAL      KSESHIP = ORIGSHIP
     C     KSETRF1       READE     SETLBYREF     SFREC
     C                   DOW       not %eof(SETLBYREF)
     C                   IF        SFREC.SEKIND = 'R'
     C                   EVAL      SID = SFREC.SEID
     C                   EVAL      OLDSTATE = SFREC.SESTATE
     C                   EVAL      KSLSETTL = SID
     C     KSETLD1       SETLL     SETLDTPF
     C                   EVAL      KSLSETTL = SID
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   DOW       not %eof(SETLDTPF)
     C                   EVAL      FOUNDROW = 0
     C                   FOR       X = 1 to 100
     C                   IF        SETVIEW(X).SVSHLINE = SLREC.SLSHLINE
     C                   EVAL      FOUNDROW = X
     C                   LEAVE
     C                   ENDIF
     C                   IF        FOUNDROW = 0 and SETVIEW(X).SVSHLINE = 0
     C                   EVAL      FOUNDROW = X
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        not ( FOUNDROW > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ADJUSTMENT_VIEW_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SETVIEW(FOUNDROW).SVSHLINE = SLREC.SLSHLINE
     C                   IF        OLDSTATE = 'OK'
     C                   EVAL      SETVIEW(FOUNDROW).SVSUCCQTY =
     C                             SETVIEW(FOUNDROW).SVSUCCQTY + SLREC.SLQTY
     C                   EVAL      SETVIEW(FOUNDROW).SVSUCCAMT =
     C                             SETVIEW(FOUNDROW).SVSUCCAMT + SLREC.SLAMOUNT
     C                   ELSE
     C                   EVAL      SETVIEW(FOUNDROW).SVPENDING = 'Y'
     C                   ENDIF
     C                   EVAL      KSLSETTL = SID
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   ENDDO
     C                   ENDIF
     C                   EVAL      KSESHIP = ORIGSHIP
     C     KSETRF1       READE     SETLBYREF     SFREC
     C                   ENDDO
     C                   ENDSR



     C     TCREATE       BEGSR
     C                   IF        not ( SETHEAD.SEKIND = 'P' or SETHEAD.SEKIND
     C                             = 'R' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_KIND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SENLINE >= 1 and
     C                             SETHEAD.SENLINE <= 100 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_ROW_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SESTATE = 'NEW' and
     C                             SETHEAD.SEATTEMPT = 1 and SETHEAD.SEFIRSTDAY
     C                             = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_INITIAL_STATE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SID = 'S:' + %trim(SETHEAD.SESHIP)
     C                   IF        SETHEAD.SEKIND = 'R'
     C                   EVAL      SID = 'A:' + %trim(SETHEAD.SERETURN) + ':' +
     C                             %trim(SETHEAD.SESHIP)
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEID = SID )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_IDENTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSEID = SID
     C     KSETLH        CHAIN     SETLHDPF      SEREC
     C                   IF        not ( not %found(SETLHDPF) )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_ALREADY_EXISTS'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOTAL = 0
     C                   FOR       I = 1 to SETHEAD.SENLINE
     C                   IF        not ( SETROWS(I).SLSETTL = SID and
     C                             SETROWS(I).SLLINE > 0 and SETROWS(I).SLQTY >
     C                             0 and SETROWS(I).SLAMOUNT >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_DETAIL_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       J = 1 to I - 1
     C                   IF        not ( SETROWS(J).SLLINE <> SETROWS(I).SLLINE
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'DUPLICATE_SETTLEMENT_DETAIL'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      TOTAL = TOTAL + SETROWS(I).SLAMOUNT
     C                   ENDFOR
     C                   IF        not ( TOTAL = SETHEAD.SEAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_AMOUNT_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      TOUT
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      TWRITE
     C                   ENDSR



     C     TWRITE        BEGSR
     C                   EVAL      SETHEAD.SELASTMSG = OUTREC.OBID
     C                   EVAL      SEREC = SETHEAD
     C                   WRITE     SETLHDR       SEREC
     C                   FOR       I = 1 to SETHEAD.SENLINE
     C                   EVAL      SLREC = SETROWS(I)
     C                   WRITE     SETLDTR       SLREC
     C                   ENDFOR
     C                   ENDSR


     C     TOUT          BEGSR
     C                   CLEAR     OUTREC
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   IF        CTXDS.CXACTION = 'VERIFY'
     C                   EVAL      OUTREC.OBKIND = 'VERIFY'
     C                   EVAL      TOKEN = 'QUERY_ONLY'
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SEATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SELASTMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OUTREC.OBKIND = 'SETTLE'
     C                   IF        SETHEAD.SEKIND = 'R'
     C                   EVAL      OUTREC.OBKIND = 'ADJUST'
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEID
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEKIND
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SESHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SERETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEORIG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SECREATED
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
     C                   EVAL      TOKEN = %char(SETHEAD.SEATTEMPT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SELASTMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETHEAD.SENLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SERETRY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETHEAD.SEREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to SETHEAD.SENLINE
     C                   EVAL      TOKEN = SETROWS(I).SLSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETROWS(I).SLLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETROWS(I).SLSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETROWS(I).SLSHLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETROWS(I).SLRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETROWS(I).SLRTLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = SETROWS(I).SLORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETROWS(I).SLORDLINE)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETROWS(I).SLQTY)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = %char(SETROWS(I).SLAMOUNT)
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDIF
     C                   EVAL      OUTREC.OBID = 'M:' + %trim(CTXDS.CXBATCH) +
     C                             ':' + %editc(CTXDS.CXINPUT:'X') + ':' +
     C                             %trim(OUTREC.OBKIND) + ':' +
     C                             %editc(CTXDS.CXOUTSEQ:'X')
     C                   EVAL      OUTREC.OBSRC = CTXDS.CXSRC
     C                   EVAL      OUTREC.OBREQ = CTXDS.CXREQ
     C                   EVAL      OUTREC.OBBATCH = CTXDS.CXBATCH
     C                   EVAL      OUTREC.OBINPUT = CTXDS.CXINPUT
     C                   EVAL      OUTREC.OBORDER = CTXDS.CXORDER
     C                   EVAL      OUTREC.OBSTATE = 'NEW'
     C                   EVAL      OUTREC.OBRESULT = 'NONE'
     C                   EVAL      OUTREC.OBRESDAY = *blanks
     C                   EVAL      OUTREC.OBATTEMPT = 1
     C                   EVAL      OUTREC.OBDAY = CTXDS.CXPROCDAY
     C                   EVAL      OUTREC.OBREASON = CTXDS.CXREASON
     C                   EVAL      OUTREC.OBBIZID = SETHEAD.SEID
     C                   EVAL      OUTREC.OBATTEMPT = SETHEAD.SEATTEMPT
     C                   EVAL      OUTREC.OBPAYLOAD = PAYLOAD
     C                   EVAL      OUTREC.OBLEN = PAYLEN
     C                   EVAL      KOBID = OUTREC.OBID
     C     KOUT          CHAIN     OUTBOXPF      OBREC
     C                   IF        not ( not %found(OUTBOXPF) )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON =
     C                             'SETTLEMENT_MESSAGE_COLLISION'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OBREC = OUTREC
     C                   WRITE     OUTBOXR       OBREC
     C                   ENDSR



     C     TAPPLY        BEGSR
     C                   EVAL      TARGET = SETHEAD
     C                   EVAL      MSGKEEP = OUTREC
     C                   EVAL      KSEID = CTXDS.CXSETTL
     C     KSETLH        CHAIN     SETLHDPF      SEREC
     C                   IF        not ( %found(SETLHDPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SEREC.SESTATE = CTXDS.CXEXPECT and
     C                             SEREC.SEATTEMPT = CTXDS.CXATTEMPT )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON =
     C                             'SETTLEMENT_SNAPSHOT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SEID = SEREC.SEID )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SEID'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SEKIND = SEREC.SEKIND )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SEKIND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SESHIP = SEREC.SESHIP )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SESHIP'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SERETURN = SEREC.SERETURN )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SERETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SEORIG = SEREC.SEORIG )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SEORIG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SEORDER = SEREC.SEORDER )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SEORDER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SECREATED = SEREC.SECREATED )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SECREATED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SEAMOUNT = SEREC.SEAMOUNT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SEAMOUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SEATTEMPT = SEREC.SEATTEMPT )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SEATTEMPT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SELASTMSG = SEREC.SELASTMSG )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SELASTMSG'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( TARGET.SENLINE = SEREC.SENLINE )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'IMMUTABLE_SENLINE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SEREC.SESTATE = 'OK'
     C                   IF        not ( TARGET.SESTATE = 'OK' and
     C                             TARGET.SEFIRSTDAY = SEREC.SEFIRSTDAY )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'SUCCESS_CANNOT_BE_REVERSED'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        not ( TARGET.SESTATE = 'NEW' or
     C                             TARGET.SESTATE = 'SENT' or TARGET.SESTATE =
     C                             'OK' or TARGET.SESTATE = 'FAIL' or
     C                             TARGET.SESTATE = 'UNKNOWN' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_TARGET_STATE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SEREC.SESTATE = TARGET.SESTATE
     C                   EVAL      SEREC.SEFIRSTDAY = TARGET.SEFIRSTDAY
     C                   EVAL      SEREC.SERETRY = TARGET.SERETRY
     C                   EVAL      SEREC.SEREASON = TARGET.SEREASON
     C                   UPDATE    SETLHDR       SEREC
     C                   EVAL      SETHEAD = SEREC
     C                   EVAL      KOBID = CTXDS.CXMSG
     C     KOUT          CHAIN     OUTBOXPF      OBREC
     C                   IF        not ( %found(OUTBOXPF) and OBREC.OBBIZID =
     C                             SETHEAD.SEID )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'FEEDBACK_MESSAGE_LINK'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        OBREC.OBRESULT <> 'OK'
     C                   EVAL      OBREC.OBRESULT = CTXDS.CXFEED
     C                   EVAL      OBREC.OBRESDAY = CTXDS.CXPROCDAY
     C                   EVAL      OBREC.OBREASON = CTXDS.CXREASON
     C                   UPDATE    OUTBOXR       OBREC
     C                   ENDIF
     C                   EVAL      OUTREC = OBREC
     C                   ENDSR



     C     TRETRY        BEGSR
     C                   EXSR      TFETCH
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SESTATE = 'FAIL' and
     C                             SETHEAD.SERETRY = 'Y' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'RETRY_REQUIRES_KNOWN_FAILURE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SEATTEMPT < 999999999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'SETTLEMENT_ATTEMPT_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OLDTRY = SETHEAD.SEATTEMPT
     C                   EVAL      SETHEAD.SEATTEMPT = SETHEAD.SEATTEMPT + 1
     C                   EVAL      SETHEAD.SESTATE = 'NEW'
     C                   EVAL      SETHEAD.SERETRY = 'N'
     C                   EVAL      SETHEAD.SEREASON = CTXDS.CXREASON
     C                   EXSR      TOUT
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SETHEAD.SELASTMSG = OUTREC.OBID
     C                   EVAL      KSEID = SETHEAD.SEID
     C     KSETLH        CHAIN     SETLHDPF      SEREC
     C                   IF        not ( SEREC.SEATTEMPT = OLDTRY and
     C                             SEREC.SESTATE = 'FAIL' )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'RETRY_SNAPSHOT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SEREC = SETHEAD
     C                   UPDATE    SETLHDR       SEREC
     C                   ENDSR



     C     TVERIFY       BEGSR
     C                   EXSR      TFETCH
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SETHEAD.SESTATE = 'UNKNOWN' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'VERIFY_REQUIRES_UNKNOWN'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        OUTREC.OBKIND = 'VERIFY' and (OUTREC.OBRESULT
     C                             = 'NONE' or OUTREC.OBRESULT = 'UNKNOWN' )
     C                   EVAL      RESDS.RSRC = RCWAIT
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OLDSEND = SETHEAD.SELASTMSG
     C                   EXSR      TOUT
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSEID = SETHEAD.SEID
     C     KSETLH        CHAIN     SETLHDPF      SEREC
     C                   IF        not ( SEREC.SELASTMSG = OLDSEND and
     C                             SEREC.SESTATE = 'UNKNOWN' )
     C                   EVAL      RESDS.RSRC = '1100'
     C                   EVAL      RESDS.RSREASON = 'VERIFY_SNAPSHOT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SEREC.SELASTMSG = OUTREC.OBID
     C                   UPDATE    SETLHDR       SEREC
     C                   EVAL      SETHEAD = SEREC
     C                   EVAL      RESDS.RSRC = RCWAIT
     C                   ENDSR



     C     TDELIV        BEGSR
     C                   EVAL      KOBID = CTXDS.CXMSG
     C     KOUT          CHAIN     OUTBOXPF      OBREC
     C                   IF        not ( %found(OUTBOXPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'MESSAGE_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( OBREC.OBKIND = 'SETTLE' or OBREC.OBKIND
     C                             = 'ADJUST' or OBREC.OBKIND = 'VERIFY' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SETTLEMENT_MESSAGE_OWNER'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CTXDS.CXFEED = 'SENT' or CTXDS.CXFEED =
     C                             'OK' or CTXDS.CXFEED = 'FAIL' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DELIVERY_RESULT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        OBREC.OBSTATE <> 'OK'
     C                   EVAL      OBREC.OBSTATE = CTXDS.CXFEED
     C                   UPDATE    OUTBOXR       OBREC
     C                   ENDIF
     C                   EVAL      OUTREC = OBREC
     C                   EVAL      KSEID = OUTREC.OBBIZID
     C     KSETLH        CHAIN     SETLHDPF      SEREC
     C                   IF        not ( %found(SETLHDPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DELIVERY_BUSINESS_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        SEREC.SELASTMSG = OUTREC.OBID and
     C                             SEREC.SESTATE = 'NEW' and (OUTREC.OBSTATE =
     C                             'SENT' or OUTREC.OBSTATE = 'OK' )
     C                   EVAL      SEREC.SESTATE = 'SENT'
     C                   UPDATE    SETLHDR       SEREC
     C                   ENDIF
     C                   EVAL      SETHEAD = SEREC
     C                   ENDSR



     C     TRET          BEGSR
     C                   IF        RESDS.RSRC < RCREJECT
     C                   EVAL      RESDS.RSSTATE = SETHEAD.SESTATE
     C                   EVAL      RESDS.RSAMOUNT = SETHEAD.SEAMOUNT
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
