

     H DFTACTGRP(*NO) ACTGRP('ORDBENCH')
     H OPTION(*SRCSTMT:*NODEBUGIO) DECEDIT('0.')
     FCUSTPF    IF   E           K DISK    COMMIT
     FITEMPF    IF   E           K DISK    COMMIT
      /DEFINE U_CTXDS
      /DEFINE U_HDRDS
      /DEFINE U_RAWROWS
      /DEFINE U_CHKHEAD
      /DEFINE U_NORMROWS
      /DEFINE U_RESDS
      /COPY QRPGLESRC,ORDCTX
      /COPY QRPGLESRC,ORDRES
      /COPY QRPGLESRC,ORDSTS
     DCUREC            DS                  LIKEREC(CUSTR)
     DKCUID            S             12A
     DITREC            DS                  LIKEREC(ITEMR)
     DKITID            S             12A
     DSEQ              S              5P 0 DIM(100)
     DTMPSEQ           S              5P 0
     DSORTKEY          S             64A   DIM(100)
     DNUMTEXT          S            120A
     DNUMVAL           S             31P 9
     DNUMGOOD          S               N
     DI                S              9P 0
     DJ                S              9P 0
     DK                S              9P 0
     DX                S              9P 0
     DY                S              9P 0
     DPOSN             S              9P 0
     DTOKEN            S          30000A
     DPAYLOAD          S          30000A
     DTOKLEN           S              9P 0
     DPAYLEN           S              9P 0
     DLEN4             S              4S 0

     C     *ENTRY        PLIST
     C                   PARM                    CTXDS
     C                   PARM                    HDRDS
     C                   PARM                    RAWROWS
     C                   PARM                    CHKHEAD
     C                   PARM                    NORMROWS
     C                   PARM                    RESDS
     C     KCUST         KLIST
     C                   KFLD                    KCUID
     C     KITEM         KLIST
     C                   KFLD                    KITID
     C                   MONITOR
     C                   EXSR      CINIT
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'LOCAL_IO_OR_CONVERSION'
     C                   ENDMON
     C                   EVAL      *inlr = *on
     C                   RETURN



     C     CINIT         BEGSR
     C                   CLEAR     CHKHEAD
     C                   CLEAR     NORMROWS
     C                   CLEAR     RESDS
     C                   EVAL      RESDS.RSRC = RCOK
     C                   IF        not ( CTXDS.CXABI = ABI )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'ABI_MISMATCH'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CTXDS.CXCOUNT >= 0 and CTXDS.CXCOUNT <=
     C                             100 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ROW_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CTXDS.CXACTION = 'CANON' or
     C                             CTXDS.CXACTION = 'VALIDATE' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CHECK_ACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      CCANON
     C                   IF        RESDS.RSRC >= RCREJECT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      CMODE
     C                   ENDSR



     C     CCANON        BEGSR
     C                   CLEAR     SEQ
     C                   CLEAR     SORTKEY
     C                   EVAL      PAYLOAD = '0001'
     C                   EVAL      PAYLEN = 4
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      SEQ(I) = I
     C                   EVAL      NUMTEXT = RAWROWS(I).IDLINE
     C                   EXSR      CNUMBER
     C                   EVAL      SORTKEY(I) = NUMTEXT
     C                   IF        NUMGOOD
     C                   EVAL      SORTKEY(I) = %editc(%dec(NUMVAL:5:0):'X')
     C                   ENDIF
     C                   IF        HDRDS.IHEVENT = 'SHIP'
     C                   EVAL      SORTKEY(I) = %trimr(SORTKEY(I)) +
     C                             RAWROWS(I).IDWH
     C                   ENDIF
     C                   ENDFOR
     C                   FOR       I = 2 to CTXDS.CXCOUNT
     C                   EVAL      J = I
     C                   DOW       J > 1
     C                   EVAL      K = J - 1
     C                   IF        SORTKEY(SEQ(K)) <= SORTKEY(SEQ(J))
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      TMPSEQ = SEQ(K)
     C                   EVAL      SEQ(K) = SEQ(J)
     C                   EVAL      SEQ(J) = TMPSEQ
     C                   EVAL      J = K
     C                   ENDDO
     C                   ENDFOR
     C                   EVAL      TOKEN = HDRDS.IHSRC
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREQ
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHEVENT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHDAY
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHORDER
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NUMTEXT = HDRDS.IHVERSION
     C                   EXSR      CNUMBER
     C                   EVAL      TOKEN = NUMTEXT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHCUST
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHPART
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHRETURN
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHSETTL
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHMSG
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHRESULT
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
     C                   EVAL      TOKEN = HDRDS.IHACTOR
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = HDRDS.IHREASON
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NUMTEXT = HDRDS.IHNLINE
     C                   EXSR      CNUMBER
     C                   EVAL      TOKEN = NUMTEXT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      J = SEQ(I)
     C                   EVAL      NUMTEXT = RAWROWS(J).IDLINE
     C                   EXSR      CNUMBER
     C                   EVAL      TOKEN = NUMTEXT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(J).IDITEM
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NUMTEXT = RAWROWS(J).IDQTY
     C                   EXSR      CNUMBER
     C                   EVAL      TOKEN = NUMTEXT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(J).IDWH
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOKEN = RAWROWS(J).IDSHIP
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NUMTEXT = RAWROWS(J).IDSHLINE
     C                   EXSR      CNUMBER
     C                   EVAL      TOKEN = NUMTEXT
     C                   EXSR      FRAME
     C                   IF        RESDS.RSRC >= '1000'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   IF        not ( PAYLEN <= 24000 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANON_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHKHEAD.CHLEN = PAYLEN
     C                   EVAL      CHKHEAD.CHCANON = %subst(PAYLOAD:1:PAYLEN)
     C                   ENDSR


     C     CNUMBER       BEGSR
     C                   EVAL      NUMTEXT = %trim(NUMTEXT)
     C                   EVAL      NUMGOOD = *off
     C                   EVAL      NUMVAL = 0
     C                   IF        NUMTEXT = *blanks
     C                   LEAVESR
     C                   ENDIF
     C                   MONITOR
     C                   EVAL      NUMVAL = %dec(NUMTEXT:31:9)
     C                   EVAL      NUMTEXT = %char(NUMVAL)
     C                   EVAL      NUMGOOD = *on
     C                   ON-ERROR
     C                   EVAL      NUMGOOD = *off
     C                   ENDMON
     C                   ENDSR



     C     CMODE         BEGSR
     C                   IF        CTXDS.CXACTION = 'CANON'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      CROWS
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   IF        HDRDS.IHEVENT = 'NEW' or HDRDS.IHEVENT =
     C                             'MOD'
     C                   EXSR      CCUST
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      CITEM
     C                   ENDIF
     C                   EXSR      CRET
     C                   ENDSR



     C     CROWS         BEGSR
     C                   EVAL      NUMTEXT = HDRDS.IHNLINE
     C                   EXSR      CNUMBER
     C                   IF        not ( NUMGOOD and NUMVAL = CTXDS.CXCOUNT )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'HEADER_ROW_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHKHEAD.CHCOUNT = CTXDS.CXCOUNT
     C                   IF        HDRDS.IHVERSION <> *blanks
     C                   EVAL      NUMTEXT = HDRDS.IHVERSION
     C                   EXSR      CNUMBER
     C                   IF        not ( NUMGOOD and NUMVAL >= 0 and NUMVAL <=
     C                             999999999 and %rem(NUMVAL:1) = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ORDER_VERSION'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHKHEAD.CHVERSION = NUMVAL
     C                   ENDIF
     C                   IF        HDRDS.IHEVENT = 'NEW' or HDRDS.IHEVENT =
     C                             'MOD' or HDRDS.IHEVENT = 'SHIP' or
     C                             HDRDS.IHEVENT = 'CANCEL' or HDRDS.IHEVENT =
     C                             'RETURN'
     C                   IF        not ( CTXDS.CXCOUNT >= 1 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'BUSINESS_ROWS_REQUIRED'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( CTXDS.CXCOUNT = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'UNEXPECTED_DETAIL_ROWS'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      J = SEQ(I)
     C                   EVAL      RESDS.RSINDEX = I
     C                   EVAL      NUMTEXT = RAWROWS(J).IDLINE
     C                   EXSR      CNUMBER
     C                   IF        not ( NUMGOOD and NUMVAL >= 1 and NUMVAL <=
     C                             99999 and %rem(NUMVAL:1) = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'INVALID_IDLINE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NORMROWS(I).NRLINE = NUMVAL
     C                   EVAL      NUMTEXT = RAWROWS(J).IDQTY
     C                   EXSR      CNUMBER
     C                   IF        not ( NUMGOOD and NUMVAL >= 1 and NUMVAL <=
     C                             9999 and %rem(NUMVAL:1) = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'INVALID_IDQTY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NORMROWS(I).NRQTY = NUMVAL
     C                   EVAL      NORMROWS(I).NRITEM = RAWROWS(J).IDITEM
     C                   EVAL      NORMROWS(I).NRWH = RAWROWS(J).IDWH
     C                   EVAL      NORMROWS(I).NRSHIP = RAWROWS(J).IDSHIP
     C                   IF        HDRDS.IHEVENT <> 'RETURN'
     C                   IF        not ( RAWROWS(J).IDSHLINE = *blanks )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON =
     C                             'UNEXPECTED_ORIGINAL_SHIP_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        HDRDS.IHEVENT = 'RETURN'
     C                   EVAL      NUMTEXT = RAWROWS(J).IDSHLINE
     C                   EXSR      CNUMBER
     C                   IF        not ( NUMGOOD and NUMVAL >= 1 and NUMVAL <=
     C                             99999 and %rem(NUMVAL:1) = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ORIGINAL_SHIPMENT_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NORMROWS(I).NRSHLINE = NUMVAL
     C                   ENDIF
     C                   FOR       K = 1 to I - 1
     C                   IF        HDRDS.IHEVENT = 'SHIP'
     C                   IF        not ( NORMROWS(K).NRLINE <>
     C                             NORMROWS(I).NRLINE or NORMROWS(K).NRWH <>
     C                             NORMROWS(I).NRWH )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DUPLICATE_SHIP_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( NORMROWS(K).NRLINE <>
     C                             NORMROWS(I).NRLINE )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DUPLICATE_LINE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        HDRDS.IHEVENT = 'RETURN'
     C                   IF        not ( NORMROWS(K).NRSHIP <>
     C                             NORMROWS(I).NRSHIP or NORMROWS(K).NRSHLINE <>
     C                             NORMROWS(I).NRSHLINE )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'DUPLICATE_ORIGINAL_DETAIL'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   ENDFOR
     C                   EVAL      RESDS.RSINDEX = 0
     C                   ENDSR



     C     CCUST         BEGSR
     C                   EVAL      KCUID = HDRDS.IHCUST
     C     KCUST         CHAIN     CUSTPF        CUREC
     C                   IF        not ( %found(CUSTPF) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CUSTOMER_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CUREC.CUACTIVE = 'Y' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CUSTOMER_INACTIVE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CUREC.CUTIER = 'S' or CUREC.CUTIER =
     C                             'P' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CUSTOMER_TIER_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      CHKHEAD.CHTIER = CUREC.CUTIER
     C                   ENDSR



     C     CITEM         BEGSR
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      KITID = NORMROWS(I).NRITEM
     C     KITEM         CHAIN     ITEMPF        ITREC
     C                   IF        not ( %found(ITEMPF) )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ITEM_NOT_FOUND'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ITREC.ITACTIVE = 'Y' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'ITEM_INACTIVE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR



     C     CRET          BEGSR
     C                   IF        RESDS.RSRC = RCOK
     C                   EVAL      RESDS.RSCOUNT = CHKHEAD.CHCOUNT
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
