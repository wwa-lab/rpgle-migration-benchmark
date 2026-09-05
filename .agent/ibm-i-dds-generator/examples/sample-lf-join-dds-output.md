# Example: Join LF DDS

Order header + detail join for invoice printing.

## Output — DDS Source

```dds
                                      TEXT('Order invoice join view')
     A          R ORDINVR              JFILE(ORDHDR ORDDTL)
     A          J                              JOIN(1 2)
     A                                         JFLD(ORDNO ORDNO)
     A            ORDNO         R              JREF(1)
     A                                         TEXT('Order number')
     A            CUSTID        R              JREF(1)
     A                                         TEXT('Customer ID')
     A            ORDDTE        R              JREF(1)
     A                                         TEXT('Order date')
     A            LNSEQ         R              JREF(2)
     A                                         TEXT('Line sequence')
     A            ITEMID        R              JREF(2)
     A                                         TEXT('Item ID')
     A            ITMQTY        R              JREF(2)
     A                                         TEXT('Quantity')
     A            UNITPR        R              JREF(2)
     A                                         TEXT('Unit price')
     A            LNTOT         R              JREF(2)
     A                                         TEXT('Line total')
     A          K ORDNO
     A          K LNSEQ
```

**Notes:**
- JFILE lists both PFs; JOIN(1 2) references their positions
- R in length = inherit field definition from PF
- JREF tells which PF each field comes from
- No JDFTVAL = inner join (unmatched records excluded)
