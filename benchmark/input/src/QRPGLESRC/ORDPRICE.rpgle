

     H DFTACTGRP(*NO) ACTGRP('ORDBENCH')
     H OPTION(*SRCSTMT:*NODEBUGIO) DECEDIT('0.')
     FPRICEPF   IF   E           K DISK    COMMIT
      /DEFINE U_CTXDS
      /DEFINE U_PRIN
      /DEFINE U_PROUT
      /DEFINE U_RESDS
      /COPY QRPGLESRC,ORDCTX
      /COPY QRPGLESRC,ORDRES
      /COPY QRPGLESRC,ORDSTS
     DPRREC            DS                  LIKEREC(PRICER)
     DKPRITEM          S             12A
     DKPRFROM          S              8A
     DMATCHES          S              5P 0
     DRATE             S              5P 4
     DUNIT             S             11P 4
     DCUMQ             S              9P 0
     DCUMA             S             15P 2
     DDELTA            S             15P 2
     DBASEI            S              5P 0
     DI                S              9P 0
     DJ                S              9P 0
     DK                S              9P 0
     DWIDE             S             31P12
     DTOTAL            S             19P 2
     DWORKDAY          S               D   DATFMT(*ISO)

     C     *ENTRY        PLIST
     C                   PARM                    CTXDS
     C                   PARM                    PRIN
     C                   PARM                    PROUT
     C                   PARM                    RESDS
     C     KPRICE1       KLIST
     C                   KFLD                    KPRITEM
     C     KPRICE        KLIST
     C                   KFLD                    KPRITEM
     C                   KFLD                    KPRFROM
     C                   MONITOR
     C                   EXSR      PINIT
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'LOCAL_IO_OR_CONVERSION'
     C                   ENDMON
     C                   EVAL      *inlr = *on
     C                   RETURN



     C     PINIT         BEGSR
     C                   CLEAR     PROUT
     C                   CLEAR     RESDS
     C                   EVAL      RESDS.RSRC = RCOK
     C                   EVAL      TOTAL = 0
     C                   IF        not ( CTXDS.CXABI = ABI )
     C                   EVAL      RESDS.RSRC = '9000'
     C                   EVAL      RESDS.RSREASON = 'ABI_MISMATCH'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CTXDS.CXCOUNT >= 1 and CTXDS.CXCOUNT <=
     C                             100 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ROW_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( CTXDS.CXACTION = 'QUOTE' or
     C                             CTXDS.CXACTION = 'SHIP' or CTXDS.CXACTION =
     C                             'RETURN' )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_ACTION'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   IF        not ( PRIN(I).PIQTY > 0 and PRIN(I).PIQTY <=
     C                             9999 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_QUANTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'QUOTE'
     C                   EXSR      PLOOK
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      PQUOTE
     C                   ELSE
     C                   EXSR      PGROUP
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      PSPLIT
     C                   ENDIF
     C                   IF        RESDS.RSRC <> RCOK
     C                   CLEAR     PROUT
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      PSUM
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      RESDS.RSCOUNT = CTXDS.CXCOUNT
     C                   EVAL      RESDS.RSAMOUNT = TOTAL
     C                   ENDSR



     C     PLOOK         BEGSR
     C                   EVAL      MATCHES = 0
     C                   EVAL      UNIT = 0
     C                   EVAL      KPRITEM = PRIN(I).PIITEM
     C     KPRICE1       SETLL     PRICEPF
     C                   EVAL      KPRITEM = PRIN(I).PIITEM
     C     KPRICE1       READE     PRICEPF       PRREC
     C                   DOW       not %eof(PRICEPF)
     C                   MONITOR
     C                   EVAL      WORKDAY = %date(PRREC.PRFROM:*ISO0)
     C                   EVAL      WORKDAY = %date(PRREC.PRTHRU:*ISO0)
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_DATE_DATA'
     C                   LEAVESR
     C                   ENDMON
     C                   IF        not ( PRREC.PRFROM <= PRREC.PRTHRU )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_RANGE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        PRREC.PRFROM <= CTXDS.CXDAY and PRREC.PRTHRU
     C                             >= CTXDS.CXDAY
     C                   IF        not ( PRREC.PRUNIT > 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'NONPOSITIVE_PRICE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      MATCHES = MATCHES + 1
     C                   EVAL      UNIT = PRREC.PRUNIT
     C                   ENDIF
     C                   EVAL      KPRITEM = PRIN(I).PIITEM
     C     KPRICE1       READE     PRICEPF       PRREC
     C                   ENDDO
     C                   IF        not ( MATCHES > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_NOT_EFFECTIVE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( MATCHES = 1 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OVERLAPPING_PRICES'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     PQUOTE        BEGSR
     C                   IF        not ( CTXDS.CXTIER = 'S' or CTXDS.CXTIER =
     C                             'P' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PRICE_TIER'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      RATE = 1.0000
     C                   IF        CTXDS.CXTIER = 'P'
     C                   EVAL      RATE = 0.9500
     C                   ENDIF
     C                   EVAL      WIDE = PRIN(I).PIQTY * UNIT * RATE
     C                   IF        not ( WIDE >= 0 and WIDE <= 9999999999999.99
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'LINE_AMOUNT_RANGE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      PROUT(I).POUNIT = UNIT
     C                   EVAL      PROUT(I).PORATE = RATE
     C                   EVAL      PROUT(I).POAMOUNT = %dech(WIDE:15:2)
     C                   EVAL      PROUT(I).POCUMQTY = PRIN(I).PIQTY
     C                   EVAL      PROUT(I).POCUMAMT = PROUT(I).POAMOUNT
     C                   ENDSR



     C     PGROUP        BEGSR
     C                   IF        not ( PRIN(I).PIBASEQTY > 0 and
     C                             PRIN(I).PIBASEAMT >= 0 and PRIN(I).PIPRIORQ
     C                             >= 0 and PRIN(I).PIPRIORA >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PROPORTION_BASE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      BASEI = 0
     C                   FOR       J = 1 to I - 1
     C                   IF        PRIN(J).PIGROUP = PRIN(I).PIGROUP
     C                   IF        not ( PRIN(J).PIBASEQTY = PRIN(I).PIBASEQTY
     C                             and PRIN(J).PIBASEAMT = PRIN(I).PIBASEAMT and
     C                             PRIN(J).PIPRIORQ = PRIN(I).PIPRIORQ and
     C                             PRIN(J).PIPRIORA = PRIN(I).PIPRIORA )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'GROUP_BASE_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      BASEI = J
     C                   ENDIF
     C                   ENDFOR
     C                   EVAL      CUMQ = PRIN(I).PIPRIORQ
     C                   EVAL      CUMA = PRIN(I).PIPRIORA
     C                   IF        BASEI > 0
     C                   EVAL      CUMQ = PROUT(BASEI).POCUMQTY
     C                   EVAL      CUMA = PROUT(BASEI).POCUMAMT
     C                   ENDIF
     C                   IF        not ( CUMQ + PRIN(I).PIQTY <=
     C                             PRIN(I).PIBASEQTY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'PROPORTION_QUANTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSR



     C     PSPLIT        BEGSR
     C                   EVAL      CUMQ = CUMQ + PRIN(I).PIQTY
     C                   EVAL      WIDE = PRIN(I).PIBASEAMT * CUMQ /
     C                             PRIN(I).PIBASEQTY
     C                   IF        CUMQ = PRIN(I).PIBASEQTY
     C                   EVAL      WIDE = PRIN(I).PIBASEAMT
     C                   ENDIF
     C                   EVAL      PROUT(I).POCUMAMT = %dech(WIDE:15:2)
     C                   EVAL      DELTA = PROUT(I).POCUMAMT - CUMA
     C                   IF        not ( DELTA >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'NEGATIVE_PROPORTION'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      PROUT(I).POAMOUNT = DELTA
     C                   EVAL      PROUT(I).POCUMQTY = CUMQ
     C                   ENDSR



     C     PSUM          BEGSR
     C                   EVAL      PROUT(I).POLINE = PRIN(I).PILINE
     C                   EVAL      WIDE = TOTAL + PROUT(I).POAMOUNT
     C                   IF        not ( WIDE <= 9999999999999.99 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'DOCUMENT_AMOUNT_RANGE'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TOTAL = WIDE
     C                   ENDSR
