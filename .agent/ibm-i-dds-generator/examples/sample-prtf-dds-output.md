# Example: PRTF DDS (Customer Listing Report)

Simple customer listing with header and detail record formats.

## Output — DDS Source

```dds
                                      TEXT('Customer listing report')
     A                                      PAGESIZE(66 132)
     A                                      OFLIND(99)
     A          R PRTHDR
     A                                      SPACEB(1)
     A                                 1  2'CUSTOMER LISTING'
     A                                         DSPATR(UL)
     A                                 1 55'DATE:'
     A            RPTDTE          L    O  1 61
     A                                         EDTCDE(Y)
     A                                 1120'PAGE:'
     A            RPTPAG         4S 0  O  1125
     A                                         EDTCDE(Z)
     A                                 3  2'CUST ID'
     A                                 3 15'NAME'
     A                                 3 58'CITY'
     A                                 3 90'STATE'
     A                                 3 96'STATUS'
     A                                 4  2'----------'
     A                                 4 15'----------------------------------------'
     A                                 4 58'------------------------------'
     A          R PRTDTL
     A                                      SPACEB(1)
     A            PCUSTID       10A    O  6  2TEXT('Customer ID')
     A            PCUSTNM       40A    O  6 15TEXT('Customer name')
     A            PCITY         30A    O  6 58TEXT('City')
     A            PSTATE         2A    O  6 90TEXT('State code')
     A            PACTSTS        1A    O  6 96TEXT('Active status')
     A          R PRTTOT
     A                                      SPACEB(2)
     A                                 8  2'TOTAL CUSTOMERS:'
     A            PTOTAL         7P 0  O  8 22
     A                                         EDTCDE(Z)
```

**Notes:**
- PAGESIZE sets 66 lines x 132 columns
- OFLIND(99) triggers page break when indicator 99 is on
- PRTHDR: header with constants and positioned fields
- PRTDTL: detail line with SPACEB(1) for single spacing
- PRTTOT: total line with SPACEB(2) for double spacing before totals
- Constants use row/col positioning without field names
- EDTCDE(Y) for date formatting, EDTCDE(Z) for zero suppress
