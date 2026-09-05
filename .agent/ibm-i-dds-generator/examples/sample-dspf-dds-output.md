# Example: DSPF DDS (Order Inquiry with Subfile)

Order inquiry screen: header info at top, scrollable subfile of order detail lines.

## Output — DDS Source

```dds
                                      TEXT('Order inquiry display file')
     A                                      DSPSIZ(24 80)
     A                                      CA03(03 'Exit')
     A                                      CF05(05 'Refresh')
     A                                      CA12(12 'Cancel')
     A          R ORDHDR
     A                                 1 25'ORDER INQUIRY'
     A                                         DSPATR(HI)
     A            H1DATE          L    O  1 70
     A                                         EDTCDE(Y)
     A                                 3  2'Order Number:'
     A            ORDNO         10A    B  3 18
     A                                         DSPATR(UL)
     A                                         CHECK(ME)
     A                                 5  2'Customer:'
     A            CUSTNM        40A    O  5 18
     A                                 5 62'Date:'
     A            ORDDTE          L    O  5 69
     A                                         EDTCDE(Y)
     A                                 7  2'Status:'
     A            ORDSTS        10A    O  7 18
     A                                 7 50'Total:'
     A            ORDTOT        11P 2  O  7 58
     A                                         EDTCDE(1)
     A N99                             8  2' '
     A  99        ERRMSG        50A    O 22  2
     A                                         DSPATR(RI)
     A          R ORDSFL                      SFL
     A            LNSEQ          3P 0  O 10  3TEXT('Line seq')
     A            ITEMID        15A    O 10 10TEXT('Item ID')
     A            ITMQTY         7P 0  O 10 28TEXT('Quantity')
     A                                         EDTCDE(Z)
     A            UNITPR         9P 2  O 10 40TEXT('Unit price')
     A                                         EDTCDE(1)
     A            LNTOT         11P 2  O 10 55TEXT('Line total')
     A                                         EDTCDE(1)
     A          R ORDCTL                      SFLCTL(ORDSFL)
     A                                      SFLSIZ(11)
     A                                      SFLPAG(10)
     A  41                                  SFLDSP
     A  42                                  SFLDSPCTL
     A  40                                  SFLCLR
     A                                      SFLEND(*MORE)
     A                                      ROLLUP(26)
     A                                 9  3'Seq'
     A                                 9 10'Item ID'
     A                                 9 28'Qty'
     A                                 9 40'Unit Price'
     A                                 9 55'Line Total'
     A                                         DSPATR(UL)
     A                                24  2'F3=Exit  F5=Refresh  -
     A                                      F12=Cancel'
```

**Notes:**
- DSPSIZ(24 80) = standard 24x80 screen
- CA03/CA12 = no data returned; CF05 = data returned (refresh needs field values)
- ORDHDR: header with constants + input/output fields
- CHECK(ME) = mandatory entry on ORDNO
- Indicator 99 conditions the error message line (DSPATR(RI) = reverse image)
- ORDSFL: subfile record (SFL keyword) with output fields
- ORDCTL: subfile control with SFLCTL, SFLSIZ, SFLPAG
- Indicators 40/41/42 control SFLCLR/SFLDSP/SFLDSPCTL
- SFLEND(*MORE) shows "More..." at bottom
- ROLLUP(26) enables PageDown
- Column headers on row 9 with underline attribute
- Continuation line for long constant text (hyphen at col 80)
