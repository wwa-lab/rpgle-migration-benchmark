     * ORDSTOCK - synthetic order processing. Static candidate.
     * ABI 0001; all transaction boundaries belong to ORDMAIN.
     H DFTACTGRP(*NO) ACTGRP('ORDBENCH')
     H OPTION(*SRCSTMT:*NODEBUGIO) DECEDIT('0.')
     FALLOCPF   UF A E           K DISK    COMMIT
     FSTOCKPF   UF A E           K DISK    COMMIT
     FWHSEPF    IF   E           K DISK    COMMIT
      /DEFINE U_CTXDS
      /DEFINE U_STKIN
      /DEFINE U_STKOLD
      /DEFINE U_STKNEW
      /DEFINE U_RESDS
      /COPY QRPGLESRC,ORDCTX
      /COPY QRPGLESRC,ORDRES
      /COPY QRPGLESRC,ORDSTS
     DALREC            DS                  LIKEREC(ALLOCR)
     DKALORDER         S             20A
     DKALLINE          S              5P 0
     DKALWH            S              1A
     DSTREC            DS                  LIKEREC(STOCKR)
     DKSTITEM          S             12A
     DKSTWH            S              1A
     DWHREC            DS                  LIKEREC(WHSER)
     DKWHID            S              1A
     DPCOUNT           S              5P 0
     DACOUNT           S              5P 0
     DNC               S              5P 0
     DOC               S              5P 0
     DPI               S              5P 0
     DAI               S              5P 0
     DWI               S              5P 0
     DNEED             S              9P 0
     DTAKE             S              9P 0
     DHELD             S              9P 0
     DMISSING          S               N
     DWAITING          S               N
     DITEMKEY          S             12A
     DWHKEY            S              1A
     DLINEKEY          S              5P 0
     DWHLIST           S              3A   INZ('ABC')
     DI                S              9P 0
     DK                S              9P 0
     DN                S              9P 0
     DX                S              9P 0
     DY                S              9P 0
     DPOOL             DS                  QUALIFIED
     D                                     DIM(600)
     DITEM                           12A
     DWH                              1A
     DONHAND                          9P 0
     DRESVD                           9P 0
     DDON                             9P 0
     DDRES                            9P 0
     DFINALAL          DS                  QUALIFIED
     D                                     DIM(600)
     DSPLINE                          5P 0
     DSPITEM                         12A
     DSPWH                            1A
     DSPONHAND                        9P 0
     DSPRESVD                         9P 0
     DSPONDELTA                       9P 0
     DSPRSDELTA                       9P 0
     DSPOLDITEM                      12A
     DSPOLDRES                        9P 0
     DSPOLDSHIP                       9P 0
     DSPOLDREL                        9P 0
     DSPNEWRES                        9P 0
     DSPNEWSHIP                       9P 0
     DSPNEWREL                        9P 0
     DSPUSE                           1A
     * ENTRY - positional ABI; exceptions return to transaction owner.
     C     *ENTRY        PLIST
     C                   PARM                    CTXDS
     C                   PARM                    STKIN
     C                   PARM                    STKOLD
     C                   PARM                    STKNEW
     C                   PARM                    RESDS
     C     KALLOC1       KLIST
     C                   KFLD                    KALORDER
     C     KALLOC2       KLIST
     C                   KFLD                    KALORDER
     C                   KFLD                    KALLINE
     C     KALLOC        KLIST
     C                   KFLD                    KALORDER
     C                   KFLD                    KALLINE
     C                   KFLD                    KALWH
     C     KSTOCK1       KLIST
     C                   KFLD                    KSTITEM
     C     KSTOCK        KLIST
     C                   KFLD                    KSTITEM
     C                   KFLD                    KSTWH
     C     KWHSE         KLIST
     C                   KFLD                    KWHID
     C                   MONITOR
     C                   EXSR      SINIT
     C                   ON-ERROR
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'LOCAL_IO_OR_CONVERSION'
     C                   ENDMON
     C                   EVAL      *inlr = *on
     C                   RETURN

     * SINIT - Select read, planning or application path
     * Step 1; BR-14, BR-17, BR-32
     C     SINIT         BEGSR
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
     C                   EVAL      RESDS.RSREASON = 'STOCK_ROW_COUNT'
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     POOL
     C                   CLEAR     FINALAL
     C                   EVAL      PCOUNT = 0
     C                   EVAL      ACOUNT = 0
     C                   EVAL      NC = 0
     C                   EVAL      OC = 0
     C                   EVAL      WAITING = *off
     C                   IF        CTXDS.CXACTION = 'APPLY'
     C                   EXSR      SAPCHECK
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      SAPWRITE
     C                   LEAVESR
     C                   ENDIF
     C                   CLEAR     STKOLD
     C                   CLEAR     STKNEW
     C                   FOR       I = 1 to 300
     C                   EVAL      STKOLD(I).SPUSE = 'N'
     C                   EVAL      STKNEW(I).SPUSE = 'N'
     C                   ENDFOR
     C                   EXSR      SLOAD
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXACTION = 'MOD'
     C                   EXSR      SMOD
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   SELECT
     C                   WHEN      CTXDS.CXACTION = 'NEW' or CTXDS.CXACTION =
     C                             'MOD' or CTXDS.CXACTION = 'ALLOC'
     C                   EXSR      SALLOC
     C                   WHEN      CTXDS.CXACTION = 'CANCEL'
     C                   EXSR      SCANCEL
     C                   WHEN      CTXDS.CXACTION = 'SHIP'
     C                   EXSR      SSHIP
     C                   WHEN      CTXDS.CXACTION = 'RETURN'
     C                   EXSR      SRETURN
     C                   WHEN      CTXDS.CXACTION = 'VIEW'
     C                   EXSR      SVIEW
     C                   OTHER
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_ACTION'
     C                   LEAVESR
     C                   ENDSL
     C                   EXSR      SRET
     C                   ENDSR

     * SLOAD - Validate request keys before planning any inventory movement
     * Step 2; BR-13, BR-14, BR-16
     C     SLOAD         BEGSR
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   IF        not ( STKIN(I).SILINE > 0 and STKIN(I).SIITEM
     C                             <> *blanks and STKIN(I).SIQTY >= 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_INPUT_KEY'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR

     * SPOOL - One virtual inventory pool per item and warehouse
     C     SPOOL         BEGSR
     C                   EVAL      PI = 0
     C                   FOR       X = 1 to PCOUNT
     C                   IF        POOL(X).ITEM = ITEMKEY and POOL(X).WH = WHKEY
     C                   EVAL      PI = X
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        PI > 0
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( PCOUNT < 600 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_POOL_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KSTITEM = ITEMKEY
     C                   EVAL      KSTWH = WHKEY
     C     KSTOCK        CHAIN(N)  STOCKPF       STREC
     C                   IF        not ( %found(STOCKPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_RECORD_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STREC.STONHAND >= STREC.STRESVD and
     C                             STREC.STRESVD >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_BALANCE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      PCOUNT = PCOUNT + 1
     C                   EVAL      PI = PCOUNT
     C                   EVAL      POOL(PI).ITEM = ITEMKEY
     C                   EVAL      POOL(PI).WH = WHKEY
     C                   EVAL      POOL(PI).ONHAND = STREC.STONHAND
     C                   EVAL      POOL(PI).RESVD = STREC.STRESVD
     C                   EVAL      POOL(PI).DON = 0
     C                   EVAL      POOL(PI).DRES = 0
     C                   ENDSR

     * SPLANROW - Snapshot one allocation without changing its database row
     C     SPLANROW      BEGSR
     C                   EVAL      N = 0
     C                   FOR       X = 1 to NC
     C                   IF        STKNEW(X).SPLINE = LINEKEY and STKNEW(X).SPWH
     C                             = WHKEY
     C                   EVAL      N = X
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        N > 0
     C                   EXSR      SPOOL
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( NC < 300 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_PLAN_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NC = NC + 1
     C                   EVAL      N = NC
     C                   EVAL      STKNEW(N).SPUSE = 'Y'
     C                   EVAL      STKNEW(N).SPLINE = LINEKEY
     C                   EVAL      STKNEW(N).SPITEM = ITEMKEY
     C                   EVAL      STKNEW(N).SPWH = WHKEY
     C                   EXSR      SPOOL
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STKNEW(N).SPONHAND = POOL(PI).ONHAND
     C                   EVAL      STKNEW(N).SPRESVD = POOL(PI).RESVD
     C                   IF        CTXDS.CXACTION = 'RETURN'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C                   EVAL      KALLINE = LINEKEY
     C                   EVAL      KALWH = WHKEY
     C     KALLOC        CHAIN(N)  ALLOCPF       ALREC
     C                   IF        %found(ALLOCPF)
     C                   EVAL      STKNEW(N).SPOLDITEM = ALREC.ALITEM
     C                   EVAL      STKNEW(N).SPOLDRES = ALREC.ALRESVD
     C                   EVAL      STKNEW(N).SPOLDSHIP = ALREC.ALSHIPPED
     C                   EVAL      STKNEW(N).SPOLDREL = ALREC.ALRELEASE
     C                   EVAL      STKNEW(N).SPNEWRES = ALREC.ALRESVD
     C                   EVAL      STKNEW(N).SPNEWSHIP = ALREC.ALSHIPPED
     C                   EVAL      STKNEW(N).SPNEWREL = ALREC.ALRELEASE
     C                   IF        not ( ALREC.ALRESVD >= 0 and ALREC.ALSHIPPED
     C                             >= 0 and ALREC.ALRELEASE >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ALLOCATION_NEGATIVE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        CTXDS.CXACTION <> 'MOD'
     C                   IF        not ( ALREC.ALITEM = ITEMKEY )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ALLOCATION_ITEM_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      STKNEW(N).SPNEWRES = 0
     C                   EVAL      STKNEW(N).SPNEWSHIP = 0
     C                   EVAL      STKNEW(N).SPNEWREL = 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR

     * SMOD - Release old reservations into the shared virtual pool
     * Step 3; BR-10, BR-14
     C     SMOD          BEGSR
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C     KALLOC1       SETLL     ALLOCPF
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C     KALLOC1       READE     ALLOCPF       ALREC
     C                   DOW       not %eof(ALLOCPF)
     C                   IF        not ( ALREC.ALSHIPPED = 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'MOD_HAS_SHIPMENT'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        ALREC.ALRESVD > 0 or ALREC.ALRELEASE > 0
     C                   IF        not ( OC < 300 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'OLD_ALLOCATION_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      OC = OC + 1
     C                   EVAL      ITEMKEY = ALREC.ALITEM
     C                   EVAL      WHKEY = ALREC.ALWH
     C                   EXSR      SPOOL
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STKOLD(OC).SPUSE = 'Y'
     C                   EVAL      STKOLD(OC).SPLINE = ALREC.ALLINE
     C                   EVAL      STKOLD(OC).SPITEM = ALREC.ALITEM
     C                   EVAL      STKOLD(OC).SPWH = ALREC.ALWH
     C                   EVAL      STKOLD(OC).SPONHAND = POOL(PI).ONHAND
     C                   EVAL      STKOLD(OC).SPRESVD = POOL(PI).RESVD
     C                   EVAL      STKOLD(OC).SPOLDITEM = ALREC.ALITEM
     C                   EVAL      STKOLD(OC).SPOLDRES = ALREC.ALRESVD
     C                   EVAL      STKOLD(OC).SPOLDSHIP = ALREC.ALSHIPPED
     C                   EVAL      STKOLD(OC).SPOLDREL = ALREC.ALRELEASE
     C                   EVAL      STKOLD(OC).SPRSDELTA = - ALREC.ALRESVD
     C                   EVAL      POOL(PI).DRES = POOL(PI).DRES - ALREC.ALRESVD
     C                   ENDIF
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C     KALLOC1       READE     ALLOCPF       ALREC
     C                   ENDDO
     C                   ENDSR

     * SALLOC - Allocate increasing business line then A B C from a shared pool
     * Step 4; BR-13, BR-14, BR-15, BR-16
     C     SALLOC        BEGSR
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      NEED = STKIN(I).SIQTY
     C                   EVAL      LINEKEY = STKIN(I).SILINE
     C                   EVAL      ITEMKEY = STKIN(I).SIITEM
     C                   FOR       WI = 1 to 3
     C                   EVAL      WHKEY = %subst(WHLIST:WI:1)
     C                   EXSR      SPLANROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NEED = NEED - STKNEW(N).SPNEWRES
     C                   ENDFOR
     C                   IF        not ( NEED >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RESERVATION_EXCEEDS_DEMAND'
     C                   LEAVESR
     C                   ENDIF
     C                   FOR       WI = 1 to 3
     C                   EVAL      WHKEY = %subst(WHLIST:WI:1)
     C                   EVAL      KWHID = WHKEY
     C     KWHSE         CHAIN     WHSEPF        WHREC
     C                   IF        not ( %found(WHSEPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'WAREHOUSE_MISSING'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( WHREC.WHRANK = WI )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'WAREHOUSE_ORDER_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( WHREC.WHACTIVE = 'Y' or WHREC.WHACTIVE
     C                             = 'N' )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'WAREHOUSE_ACTIVE_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        WHREC.WHACTIVE = 'Y' and NEED > 0
     C                   EXSR      SPLANROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TAKE = POOL(PI).ONHAND - POOL(PI).RESVD -
     C                             POOL(PI).DRES
     C                   IF        not ( TAKE >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'VIRTUAL_STOCK_NEGATIVE'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        TAKE > NEED
     C                   EVAL      TAKE = NEED
     C                   ENDIF
     C                   EVAL      STKNEW(N).SPNEWRES = STKNEW(N).SPNEWRES +
     C                             TAKE
     C                   EVAL      STKNEW(N).SPRSDELTA = STKNEW(N).SPRSDELTA +
     C                             TAKE
     C                   EVAL      POOL(PI).DRES = POOL(PI).DRES + TAKE
     C                   EVAL      NEED = NEED - TAKE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        NEED > 0
     C                   EVAL      WAITING = *on
     C                   ENDIF
     C                   ENDFOR
     C                   IF        WAITING and CTXDS.CXPART = 'N'
     C                   FOR       N = 1 to NC
     C                   EVAL      STKNEW(N).SPNEWRES = STKNEW(N).SPNEWRES -
     C                             STKNEW(N).SPRSDELTA
     C                   EVAL      STKNEW(N).SPRSDELTA = 0
     C                   ENDFOR
     C                   ENDIF
     C                   ENDSR

     * SCANCEL - Unallocated demand first; release reserved stock C B A
     * Step 5; BR-18, BR-19
     C     SCANCEL       BEGSR
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      LINEKEY = STKIN(I).SILINE
     C                   EVAL      ITEMKEY = STKIN(I).SIITEM
     C                   EVAL      HELD = 0
     C                   FOR       WI = 1 to 3
     C                   EVAL      WHKEY = %subst(WHLIST:WI:1)
     C                   EXSR      SPLANROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      HELD = HELD + STKNEW(N).SPNEWRES
     C                   ENDFOR
     C                   IF        not ( HELD <= STKIN(I).SIREMAIN )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_RESERVATION_DATA'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( STKIN(I).SIQTY > 0 and STKIN(I).SIQTY
     C                             <= STKIN(I).SIREMAIN )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_QUANTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      NEED = STKIN(I).SIQTY - (STKIN(I).SIREMAIN -
     C                             HELD)
     C                   IF        NEED < 0
     C                   EVAL      NEED = 0
     C                   ENDIF
     C                   FOR       WI = 3 downto 1
     C                   EVAL      WHKEY = %subst(WHLIST:WI:1)
     C                   EXSR      SPLANROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TAKE = STKNEW(N).SPNEWRES
     C                   IF        TAKE > NEED
     C                   EVAL      TAKE = NEED
     C                   ENDIF
     C                   EVAL      STKNEW(N).SPNEWRES = STKNEW(N).SPNEWRES -
     C                             TAKE
     C                   EVAL      STKNEW(N).SPNEWREL = STKNEW(N).SPNEWREL +
     C                             TAKE
     C                   EVAL      STKNEW(N).SPRSDELTA = STKNEW(N).SPRSDELTA -
     C                             TAKE
     C                   EVAL      POOL(PI).DRES = POOL(PI).DRES - TAKE
     C                   EVAL      NEED = NEED - TAKE
     C                   ENDFOR
     C                   IF        not ( NEED = 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'CANCEL_UNRELEASED'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR

     * SSHIP - Validate and plan all shipment rows before any write
     * Step 6; BR-14, BR-17
     C     SSHIP         BEGSR
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      LINEKEY = STKIN(I).SILINE
     C                   EVAL      ITEMKEY = STKIN(I).SIITEM
     C                   EVAL      WHKEY = STKIN(I).SIWH
     C                   EXSR      SPLANROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TAKE = STKIN(I).SIQTY
     C                   IF        not ( TAKE > 0 and TAKE <= STKNEW(N).SPNEWRES
     C                             )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'SHIP_OWN_RESERVATION'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STKNEW(N).SPNEWRES = STKNEW(N).SPNEWRES -
     C                             TAKE
     C                   EVAL      STKNEW(N).SPNEWSHIP = STKNEW(N).SPNEWSHIP +
     C                             TAKE
     C                   EVAL      STKNEW(N).SPONDELTA = STKNEW(N).SPONDELTA -
     C                             TAKE
     C                   EVAL      STKNEW(N).SPRSDELTA = STKNEW(N).SPRSDELTA -
     C                             TAKE
     C                   EVAL      POOL(PI).DON = POOL(PI).DON - TAKE
     C                   EVAL      POOL(PI).DRES = POOL(PI).DRES - TAKE
     C                   ENDFOR
     C                   ENDSR

     * SRETURN - Restore original warehouse stock without allocating demand
     * Step 7; BR-21
     C     SRETURN       BEGSR
     C                   FOR       I = 1 to CTXDS.CXCOUNT
     C                   EVAL      LINEKEY = STKIN(I).SILINE
     C                   EVAL      ITEMKEY = STKIN(I).SIITEM
     C                   EVAL      WHKEY = STKIN(I).SIWH
     C                   IF        not ( STKIN(I).SIQTY > 0 )
     C                   EVAL      RESDS.RSRC = '1000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_QUANTITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EXSR      SPLANROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STKNEW(N).SPONDELTA = STKNEW(N).SPONDELTA +
     C                             STKIN(I).SIQTY
     C                   EVAL      POOL(PI).DON = POOL(PI).DON + STKIN(I).SIQTY
     C                   IF        not ( POOL(PI).ONHAND + POOL(PI).DON <=
     C                             999999999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'RETURN_STOCK_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR

     * SVIEW - Read active or historic nonzero allocation facts without deltas
     * Step 8; BR-32
     C     SVIEW         BEGSR
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C     KALLOC1       SETLL     ALLOCPF
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C     KALLOC1       READE     ALLOCPF       ALREC
     C                   DOW       not %eof(ALLOCPF)
     C                   IF        ALREC.ALRESVD <> 0 or ALREC.ALSHIPPED <> 0 or
     C                             ALREC.ALRELEASE <> 0
     C                   EVAL      LINEKEY = ALREC.ALLINE
     C                   EVAL      ITEMKEY = ALREC.ALITEM
     C                   EVAL      WHKEY = ALREC.ALWH
     C                   EXSR      SPLANROW
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C     KALLOC1       READE     ALLOCPF       ALREC
     C                   ENDDO
     C                   ENDSR

     * SAPCHECK - Reconstruct pooled deltas and final allocations, then lock-
     * check
     * Step 9; BR-10, BR-14, BR-17
     C     SAPCHECK      BEGSR
     C                   FOR       I = 1 to 300
     C                   IF        STKOLD(I).SPUSE = 'Y'
     C                   EVAL      ITEMKEY = STKOLD(I).SPITEM
     C                   EVAL      WHKEY = STKOLD(I).SPWH
     C                   EXSR      SPOOL
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( POOL(PI).ONHAND = STKOLD(I).SPONHAND
     C                             and POOL(PI).RESVD = STKOLD(I).SPRESVD )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_SNAPSHOT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      POOL(PI).DON = POOL(PI).DON +
     C                             STKOLD(I).SPONDELTA
     C                   EVAL      POOL(PI).DRES = POOL(PI).DRES +
     C                             STKOLD(I).SPRSDELTA
     C                   IF        CTXDS.CXEVENT <> 'RETURN'
     C                   EVAL      AI = 0
     C                   FOR       X = 1 to ACOUNT
     C                   IF        FINALAL(X).SPLINE = STKOLD(I).SPLINE and
     C                             FINALAL(X).SPWH = STKOLD(I).SPWH
     C                   EVAL      AI = X
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        AI = 0
     C                   IF        not ( ACOUNT < 600 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'FINAL_ALLOCATION_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ACOUNT = ACOUNT + 1
     C                   EVAL      AI = ACOUNT
     C                   ENDIF
     C                   EVAL      FINALAL(AI) = STKOLD(I)
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   FOR       I = 1 to 300
     C                   IF        STKNEW(I).SPUSE = 'Y'
     C                   EVAL      ITEMKEY = STKNEW(I).SPITEM
     C                   EVAL      WHKEY = STKNEW(I).SPWH
     C                   EXSR      SPOOL
     C                   IF        RESDS.RSRC <> RCOK
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( POOL(PI).ONHAND = STKNEW(I).SPONHAND
     C                             and POOL(PI).RESVD = STKNEW(I).SPRESVD )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_SNAPSHOT_CHANGED'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      POOL(PI).DON = POOL(PI).DON +
     C                             STKNEW(I).SPONDELTA
     C                   EVAL      POOL(PI).DRES = POOL(PI).DRES +
     C                             STKNEW(I).SPRSDELTA
     C                   IF        CTXDS.CXEVENT <> 'RETURN'
     C                   EVAL      AI = 0
     C                   FOR       X = 1 to ACOUNT
     C                   IF        FINALAL(X).SPLINE = STKNEW(I).SPLINE and
     C                             FINALAL(X).SPWH = STKNEW(I).SPWH
     C                   EVAL      AI = X
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
     C                   IF        AI = 0
     C                   IF        not ( ACOUNT < 600 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'FINAL_ALLOCATION_CAPACITY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      ACOUNT = ACOUNT + 1
     C                   EVAL      AI = ACOUNT
     C                   ENDIF
     C                   EVAL      FINALAL(AI) = STKNEW(I)
     C                   ENDIF
     C                   ENDIF
     C                   ENDFOR
     C                   FOR       PI = 1 to PCOUNT
     C                   EVAL      KSTITEM = POOL(PI).ITEM
     C                   EVAL      KSTWH = POOL(PI).WH
     C     KSTOCK        CHAIN     STOCKPF       STREC
     C                   IF        not ( %found(STOCKPF) and STREC.STONHAND =
     C                             POOL(PI).ONHAND and STREC.STRESVD =
     C                             POOL(PI).RESVD )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_CHANGED_BEFORE_APPLY'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( POOL(PI).ONHAND + POOL(PI).DON >=
     C                             POOL(PI).RESVD + POOL(PI).DRES and
     C                             POOL(PI).RESVD + POOL(PI).DRES >= 0 and
     C                             POOL(PI).ONHAND + POOL(PI).DON <= 999999999 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'FINAL_STOCK_RANGE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   FOR       AI = 1 to ACOUNT
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C                   EVAL      KALLINE = FINALAL(AI).SPLINE
     C                   EVAL      KALWH = FINALAL(AI).SPWH
     C     KALLOC        CHAIN     ALLOCPF       ALREC
     C                   IF        FINALAL(AI).SPOLDITEM = *blanks
     C                   IF        not ( not %found(ALLOCPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ALLOCATION_APPEARED'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
     C                   IF        not ( %found(ALLOCPF) )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ALLOCATION_DISAPPEARED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ALREC.ALITEM = FINALAL(AI).SPOLDITEM )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'ALLOCATION_SNAPSHOT_ALITEM'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ALREC.ALRESVD = FINALAL(AI).SPOLDRES )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ALLOCATION_SNAPSHOT_ALRESVD'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ALREC.ALSHIPPED = FINALAL(AI).SPOLDSHIP
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ALLOCATION_SNAPSHOT_ALSHIPPED'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        not ( ALREC.ALRELEASE = FINALAL(AI).SPOLDREL
     C                             )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON =
     C                             'ALLOCATION_SNAPSHOT_ALRELEASE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   IF        not ( FINALAL(AI).SPNEWRES >= 0 and
     C                             FINALAL(AI).SPNEWSHIP >= 0 and
     C                             FINALAL(AI).SPNEWREL >= 0 )
     C                   EVAL      RESDS.RSRC = '2000'
     C                   EVAL      RESDS.RSREASON = 'FINAL_ALLOCATION_NEGATIVE'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR

     * SAPWRITE - Apply each locked key once; caller owns the atomic unit
     * Step 10; BR-10, BR-14, BR-17, BR-21
     C     SAPWRITE      BEGSR
     C                   FOR       PI = 1 to PCOUNT
     C                   EVAL      KSTITEM = POOL(PI).ITEM
     C                   EVAL      KSTWH = POOL(PI).WH
     C     KSTOCK        CHAIN     STOCKPF       STREC
     C                   IF        not ( %found(STOCKPF) )
     C                   EVAL      RESDS.RSRC = '3000'
     C                   EVAL      RESDS.RSREASON = 'STOCK_LOST_DURING_APPLY'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      STREC.STONHAND = POOL(PI).ONHAND +
     C                             POOL(PI).DON
     C                   EVAL      STREC.STRESVD = POOL(PI).RESVD +
     C                             POOL(PI).DRES
     C                   UPDATE    STOCKR        STREC
     C                   ENDFOR
     C                   FOR       AI = 1 to ACOUNT
     C                   EVAL      KALORDER = CTXDS.CXORDER
     C                   EVAL      KALLINE = FINALAL(AI).SPLINE
     C                   EVAL      KALWH = FINALAL(AI).SPWH
     C     KALLOC        CHAIN     ALLOCPF       ALREC
     C                   EVAL      MISSING = not %found(ALLOCPF)
     C                   CLEAR     ALREC
     C                   EVAL      ALREC.ALORDER = CTXDS.CXORDER
     C                   EVAL      ALREC.ALLINE = FINALAL(AI).SPLINE
     C                   EVAL      ALREC.ALWH = FINALAL(AI).SPWH
     C                   EVAL      ALREC.ALITEM = FINALAL(AI).SPITEM
     C                   EVAL      ALREC.ALRESVD = FINALAL(AI).SPNEWRES
     C                   EVAL      ALREC.ALSHIPPED = FINALAL(AI).SPNEWSHIP
     C                   EVAL      ALREC.ALRELEASE = FINALAL(AI).SPNEWREL
     C                   IF        MISSING
     C                   WRITE     ALLOCR        ALREC
     C                   ELSE
     C                   UPDATE    ALLOCR        ALREC
     C                   ENDIF
     C                   ENDFOR
     C                   ENDSR

     * SRET - Return waiting status only when the plan is otherwise valid
     * Step 11; BR-15, BR-16, BR-32
     C     SRET          BEGSR
     C                   IF        RESDS.RSRC = RCOK
     C                   EVAL      RESDS.RSCOUNT = NC
     C                   IF        WAITING
     C                   EVAL      RESDS.RSRC = RCWAIT
     C                   EVAL      RESDS.RSREASON = 'STOCK_WAIT'
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
