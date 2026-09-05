# Example: PF Version File DDS

CUSTMASV — version of CUSTMAST for data migration. Same record format (CUSTR),
different file name, different key (keyed by LSTUPD descending for recent-first access).

## Output — DDS Source

```dds
     A* Version of: CUSTMAST
                                      TEXT('Customer master version for -
                                      migration')
     A          R CUSTR                TEXT('Customer master record')
     A            CUSTID        10A         TEXT('Customer ID')
     A            CUSTNM        40A         TEXT('Customer name')
     A            ADDR1         40A         TEXT('Address line 1')
     A            ADDR2         40A         TEXT('Address line 2')
     A                                         ALWNULL
     A            CITY          30A         TEXT('City')
     A            STATE          2A         TEXT('State code')
     A            ZIPCD         10A         TEXT('Postal code')
     A            CRLMT         11P 2       TEXT('Credit limit')
     A            ACTSTS         1A         TEXT('Active status')
     A            LSTUPD          L         TEXT('Last update date')
     A          K LSTUPD                       DESCEND
```

**Notes:**
- Format name CUSTR matches source PF (allows program file override without recompile)
- Comment identifies this as a version file
- Different key (LSTUPD DESCEND) vs source PF (CUSTID ASCEND)
- No UNIQUE — version file may have duplicates on date
