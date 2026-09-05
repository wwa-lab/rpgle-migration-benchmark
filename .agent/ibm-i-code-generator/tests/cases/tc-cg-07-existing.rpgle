     H DFTACTGRP(*NO) ACTGRP(*CALLER)
     FORDHDR    IF   E           K DISK
     D P_ORDNO        S             10A
     D P_RETCDE       S              1A
     C     *ENTRY        PLIST
     C                   PARM                    P_ORDNO
     C                   PARM                    P_RETCDE
     C* Step 2 - default return code
     C                   EVAL      P_RETCDE = '1'
     C* Step 3 / BR-01 - blank order check
     C                   IF        %TRIM(P_ORDNO) = *BLANKS
     C                   EVAL      P_RETCDE = '1'
     C                   RETURN
     C                   ENDIF
     C* Step 4 / BR-02 - order must exist
     C     P_ORDNO       CHAIN     ORDHDR
     C                   IF        NOT %FOUND(ORDHDR)
     C                   EVAL      P_RETCDE = '2'
     C                   RETURN
     C                   ENDIF
     C* Step 5 / BR-03 - status must be Pending
     C                   IF        ORDSTS <> 'P'
     C                   EVAL      P_RETCDE = '3'
     C                   RETURN
     C                   ENDIF
     C* Step 7 - update order status
     C                   EVAL      ORDSTS = 'C'
     C                   UPDATE    ORDHDRR
     C* Step 8 - success
     C                   EVAL      P_RETCDE = '0'
     C                   RETURN
