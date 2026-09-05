

     H DFTACTGRP(*NO) ACTGRP('ORDBENCH')
     H OPTION(*SRCSTMT:*NODEBUGIO) DECEDIT('0.')
     FDAYRPTPF  UF A E           K DISK    COMMIT
     FREQPF     IF   E           K DISK    COMMIT
     FSETLBYDAY IF   E           K DISK    COMMIT
     F                                     RENAME(SETLHDR:SETLDYR)
     FSETLDTPF  IF   E           K DISK    COMMIT
      /DEFINE U_CTXDS
      /DEFINE U_DAYHEAD
      /DEFINE U_RESDS
      /COPY QRPGLESRC,ORDCTX
      /COPY QRPGLESRC,ORDRES
      /COPY QRPGLESRC,ORDSTS
     DDYREC            DS                  LIKEREC(DAYRPTR)
     DKDYDAY           S              8A
     DKDYSNAP          S             40A
     DKDYLINE          S              9P 0
     DRQREC            DS                  LIKEREC(REQR)
     DKRQSRC           S             12A
     DKRQREQ           S             20A
     DSYREC            DS                  LIKEREC(SETLDYR)
     DKSESTATE         S              8A
     DKSEFIRSTDAY      S              8A
     DKSEID            S             48A
     DSLREC            DS                  LIKEREC(SETLDTR)
     DKSLSETTL         S             48A
     DKSLLINE          S              5P 0
     DSNAPDAY          S              8A
     DSNAPID           S             40A
     DDETAILNO         S              9P 0
     DPOSAMT           S             19P 2
     DNEGAMT           S             19P 2
     DSTATEKEY         S              8A
     DSSTATE           S              8A   DIM(4)
     DSID              S             48A
     DEXPECTED         S             15P 2
     DEXPECTEDN        S              5P 0
     DI                S              9P 0
     DK                S              9P 0
     DN                S              9P 0
     DWIDE             S             31P12
     DTOTAL            S             19P 2

     C     *ENTRY        PLIST
     C                   PARM                    CTXDS
     C                   PARM                    DAYHEAD
     C                   PARM                    RESDS
     C     KDAY1         KLIST
     C                   KFLD                    KDYDAY
     C     KDAY2         KLIST
     C                   KFLD                    KDYDAY
     C                   KFLD                    KDYSNAP
     C     KDAY          KLIST
     C                   KFLD                    KDYDAY
     C                   KFLD                    KDYSNAP
     C                   KFLD                    KDYLINE
     C     KREQ1         KLIST
     C                   KFLD                    KRQSRC
     C     KREQ          KLIST
     C                   KFLD                    KRQSRC
     C                   KFLD                    KRQREQ
     C     KSETDY1       KLIST
     C                   KFLD                    KSESTATE
     C     KSETDY2       KLIST
     C                   KFLD                    KSESTATE
     C                   KFLD                    KSEFIRSTDAY
     C     KSETDY        KLIST
     C                   KFLD                    KSESTATE
     C                   KFLD                    KSEFIRSTDAY
     C                   KFLD                    KSEID
     C     KSETLD1       KLIST
     C                   KFLD                    KSLSETTL
     C     KSETLD        KLIST
     C                   KFLD                    KSLSETTL
     C                   KFLD                    KSLLINE
     C                   MONITOR
     C                   EXSR      DINIT
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'LOCAL_IO_OR_CONVERSION'
     C                   ENDMON
     C                   EVAL      *inlr = *on
     C                   RETURN



     C     DINIT         BEGSR
     C                   CLEAR     RESDS
     C                   CLEAR     DAYHEAD
     C                   EVAL      RESDS.RSRC = RCOK
     C                   IF        not ( CTXDS.CXABI = ABI )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'ABI_MISMATCH'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CTXDS.CXACTION = 'SNAPSHOT' or
     C                             CTXDS.CXACTION = 'FETCH' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_ACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      SNAPDAY = CTXDS.CXPROCDAY
     C                   IF        CTXDS.CXACTION = 'FETCH'
     C                   EVAL      SNAPDAY = CTXDS.CXDAY
     C                   ENDIF
     C                   EVAL      SNAPID = %trim(CTXDS.CXSRC) + ':' +
     C                             %trim(CTXDS.CXREQ)
     C                   EVAL      KDYDAY = SNAPDAY
     C                   EVAL      KDYSNAP = SNAPID
     C                   EVAL      KDYLINE = 0
     C     KDAY          CHAIN(N)  DAYRPTPF      DYREC
     C                   IF        %found(DAYRPTPF)
     C                   IF        not ( DYREC.DYSTATE = 'READY' and
     C                             DYREC.DYKIND = 'HEADER' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'INCOMPLETE_DAILY_SNAPSHOT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      DAYHEAD = DYREC
     C                   EVAL      RESDS.RSRC = RCDUP
     C                   EVAL      RESDS.RSAMOUNT = DYREC.DYAMOUNT
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CTXDS.CXACTION = 'SNAPSHOT' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_SNAPSHOT_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      DSTART
     C                   IF        RESDS.RSRC <> RCOK
     C                   EXSR      DFAIL
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      DSUCCESS
     C                   IF        RESDS.RSRC <> RCOK
     C                   EXSR      DFAIL
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      DPENDING
     C                   IF        RESDS.RSRC <> RCOK
     C                   EXSR      DFAIL
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      DLOCAL
     C                   IF        RESDS.RSRC <> RCOK
     C                   EXSR      DFAIL
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      DPUBLISH
     C                   IF        RESDS.RSRC <> RCOK
     C                   EXSR      DFAIL
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR




     C     DSTART        BEGSR
     C                   EVAL      DETAILNO = 0
     C                   EVAL      POSAMT = 0
     C                   EVAL      NEGAMT = 0
     C                   CLEAR     DYREC
     C                   EVAL      DYREC.DYDAY = SNAPDAY
     C                   EVAL      DYREC.DYSNAP = SNAPID
     C                   EVAL      DYREC.DYLINE = 0
     C                   EVAL      DYREC.DYKIND = 'HEADER'
     C                   EVAL      DYREC.DYSTATE = 'DRAFT'
     C                   EVAL      DYREC.DYSRC = CTXDS.CXSRC
     C                   EVAL      DYREC.DYREQ = CTXDS.CXREQ
     C                   EVAL      DYREC.DYRC = RCOK
     C                   WRITE     DAYRPTR       DYREC
     C                   ENDSR



     C     DSUCCESS      BEGSR
     C                   EVAL      KSESTATE = 'OK'
     C                   EVAL      KSEFIRSTDAY = SNAPDAY
     C     KSETDY2       SETLL     SETLBYDAY
     C                   EVAL      KSESTATE = 'OK'
     C                   EVAL      KSEFIRSTDAY = SNAPDAY
     C     KSETDY2       READE     SETLBYDAY     SYREC
     C                   DOW       not %eof(SETLBYDAY)
     C                   EVAL      SID = SYREC.SEID
     C                   EVAL      EXPECTED = SYREC.SEAMOUNT
     C                   EVAL      EXPECTEDN = SYREC.SENLINE
     C                   EVAL      TOTAL = 0
     C                   EVAL      N = 0
     C                   EVAL      KSLSETTL = SID
     C     KSETLD1       SETLL     SETLDTPF
     C                   EVAL      KSLSETTL = SID
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   DOW       not %eof(SETLDTPF)
     C                   EVAL      TOTAL = TOTAL + SLREC.SLAMOUNT
     C                   EVAL      N = N + 1
     C                   EVAL      KSLSETTL = SID
     C     KSETLD1       READE     SETLDTPF      SLREC
     C                   ENDDO
     C                   IF        not ( TOTAL = EXPECTED and N = EXPECTEDN )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_SETTLEMENT_TOTAL'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( SYREC.SEKIND = 'P' or SYREC.SEKIND =
     C                             'R' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_SETTLEMENT_KIND'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     DYREC
     C                   EVAL      DYREC.DYSETTL = SID
     C                   EVAL      DYREC.DYSTATE = 'OK'
     C                   IF        SYREC.SEKIND = 'P'
     C                   EVAL      DYREC.DYKIND = 'POS'
     C                   EVAL      DYREC.DYAMOUNT = EXPECTED
     C                   EVAL      WIDE = POSAMT + EXPECTED
     C                   IF        not ( WIDE <= 99999999999999999.99 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_POSITIVE_OVERFLOW'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      POSAMT = WIDE
     C                   ELSE
     C                   EVAL      DYREC.DYKIND = 'NEG'
     C                   EVAL      DYREC.DYAMOUNT = - EXPECTED
     C                   EVAL      WIDE = NEGAMT + EXPECTED
     C                   IF        not ( WIDE <= 99999999999999999.99 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_NEGATIVE_OVERFLOW'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NEGAMT = WIDE
     C                   ENDIF
     C                   EXSR      DROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSESTATE = 'OK'
     C                   EVAL      KSEFIRSTDAY = SNAPDAY
     C     KSETDY2       READE     SETLBYDAY     SYREC
     C                   ENDDO
     C                   ENDSR



     C     DPENDING      BEGSR
     C                   EVAL      SSTATE(1) = 'NEW'
     C                   EVAL      SSTATE(2) = 'SENT'
     C                   EVAL      SSTATE(3) = 'FAIL'
     C                   EVAL      SSTATE(4) = 'UNKNOWN'
     C                   FOR       I = 1 to 4
     C                   EVAL      STATEKEY = SSTATE(I)
     C                   EVAL      KSESTATE = STATEKEY
     C     KSETDY1       SETLL     SETLBYDAY
     C                   EVAL      KSESTATE = STATEKEY
     C     KSETDY1       READE     SETLBYDAY     SYREC
     C                   DOW       not %eof(SETLBYDAY)
     C                   IF        not ( SYREC.SEFIRSTDAY = *blanks )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PENDING_HAS_SUCCESS_DAY'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     DYREC
     C                   EVAL      DYREC.DYKIND = 'PENDING'
     C                   EVAL      DYREC.DYSTATE = SYREC.SESTATE
     C                   EVAL      DYREC.DYSETTL = SYREC.SEID
     C                   EVAL      DYREC.DYAMOUNT = SYREC.SEAMOUNT
     C                   EXSR      DROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSESTATE = STATEKEY
     C     KSETDY1       READE     SETLBYDAY     SYREC
     C                   ENDDO
     C                   ENDFOR
     C                   ENDSR



     C     DLOCAL        BEGSR
     C     *LOVAL        SETLL     REQPF
     C                   READ      REQPF         RQREC
     C                   DOW       not %eof(REQPF)
     C                   IF        RQREC.RQSTATE = 'RETRY'
     C                   CLEAR     DYREC
     C                   EVAL      DYREC.DYKIND = 'LOCAL'
     C                   EVAL      DYREC.DYSTATE = RQREC.RQSTATE
     C                   EVAL      DYREC.DYSRC = RQREC.RQSRC
     C                   EVAL      DYREC.DYREQ = RQREC.RQREQ
     C                   EVAL      DYREC.DYRC = RQREC.RQRC
     C                   EXSR      DROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   READ      REQPF         RQREC
     C                   ENDDO
     C                   ENDSR


     C     DROW          BEGSR
     C                   IF        not ( DETAILNO < 999999999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_LINE_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      DETAILNO = DETAILNO + 1
     C                   EVAL      DYREC.DYDAY = SNAPDAY
     C                   EVAL      DYREC.DYSNAP = SNAPID
     C                   EVAL      DYREC.DYLINE = DETAILNO
     C                   WRITE     DAYRPTR       DYREC
     C                   ENDSR



     C     DPUBLISH      BEGSR
     C                   EVAL      KDYDAY = SNAPDAY
     C                   EVAL      KDYSNAP = SNAPID
     C                   EVAL      KDYLINE = 0
     C     KDAY          CHAIN     DAYRPTPF      DYREC
     C                   IF        not ( %found(DAYRPTPF) and DYREC.DYSTATE =
     C                             'DRAFT' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DAILY_HEADER_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      DYREC.DYPOS = POSAMT
     C                   EVAL      DYREC.DYNEG = NEGAMT
     C                   EVAL      DYREC.DYAMOUNT = POSAMT - NEGAMT
     C                   EVAL      DYREC.DYCOUNT = DETAILNO
     C                   EVAL      DYREC.DYSTATE = 'READY'
     C                   UPDATE    DAYRPTR       DYREC
     C                   EVAL      DAYHEAD = DYREC
     C                   EVAL      RESDS.RSAMOUNT = DYREC.DYAMOUNT
     C                   EVAL      RESDS.RSSTATE = 'READY'
     C                   ENDSR



     C     DFAIL         BEGSR
     C                   CLEAR     DAYHEAD
     C                   IF        RESDS.RSRC < RCREJECT
     C                   EVAL      RESDS.RSRC = RCDATA
     C                   ENDIF
     C                   ENDSR
