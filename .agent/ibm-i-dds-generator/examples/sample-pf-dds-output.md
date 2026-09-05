# Example: PF DDS Generation from File Spec JSON

## Input — File Spec JSON (Layer 2)

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "CUSTMAST-20260403-01",
    "specLevel": "L2",
    "fileType": "PF",
    "fileName": "CUSTMAST",
    "library": "ORDLIB",
    "sourceFile": "QDDSSRC",
    "description": "Customer master file for order processing"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "CUSTR",
      "purpose": "Customer master record",
      "fieldCount": 10
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "CUSTID", "type": "A", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Customer ID", "editCode": null, "columnHeading": "CUS / ID", "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "CUSTNM", "type": "A", "length": 40, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Customer name", "editCode": null, "columnHeading": "CUST / NAME", "ddsKeywords": [] },
      { "fieldId": "FLD-03", "fieldName": "ADDR1", "type": "A", "length": 40, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Address line 1", "editCode": null, "columnHeading": "ADDR / LINE1", "ddsKeywords": [] },
      { "fieldId": "FLD-04", "fieldName": "ADDR2", "type": "A", "length": 40, "decimals": null, "nullable": true, "defaultValue": null, "ccsid": null, "text": "Address line 2", "editCode": null, "columnHeading": "ADDR / LINE2", "ddsKeywords": [] },
      { "fieldId": "FLD-05", "fieldName": "CITY", "type": "A", "length": 30, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "City", "editCode": null, "columnHeading": "CITY", "ddsKeywords": [] },
      { "fieldId": "FLD-06", "fieldName": "STATE", "type": "A", "length": 2, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "State code", "editCode": null, "columnHeading": "ST", "ddsKeywords": [] },
      { "fieldId": "FLD-07", "fieldName": "ZIPCD", "type": "A", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Postal code", "editCode": null, "columnHeading": "ZIP / CODE", "ddsKeywords": [] },
      { "fieldId": "FLD-08", "fieldName": "CRLMT", "type": "P", "length": 11, "decimals": 2, "nullable": false, "defaultValue": "0", "ccsid": null, "text": "Credit limit", "editCode": "1", "columnHeading": "CREDIT / LIMIT", "ddsKeywords": [] },
      { "fieldId": "FLD-09", "fieldName": "ACTSTS", "type": "A", "length": 1, "decimals": null, "nullable": false, "defaultValue": "A", "ccsid": null, "text": "Active status", "editCode": null, "columnHeading": "ACT / STS", "ddsKeywords": [] },
      { "fieldId": "FLD-10", "fieldName": "LSTUPD", "type": "L", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Last update date", "editCode": null, "columnHeading": "LAST / UPDATE", "ddsKeywords": [] }
    ]
  },
  "keyDefinition": {
    "unique": true,
    "accessPath": "Keyed",
    "keys": [
      { "sequence": 1, "fieldName": "CUSTID", "fieldRef": "FLD-01", "sortDirection": "ASCEND" }
    ]
  }
}
```

## Output — DDS Source

```dds
                                      TEXT('Customer master file for order -
                                      processing')
     A          R CUSTR                TEXT('Customer master record')
     A            CUSTID        10A         TEXT('Customer ID')
     A                                         COLHDG('CUS' 'ID')
     A            CUSTNM        40A         TEXT('Customer name')
     A                                         COLHDG('CUST' 'NAME')
     A            ADDR1         40A         TEXT('Address line 1')
     A                                         COLHDG('ADDR' 'LINE1')
     A            ADDR2         40A         TEXT('Address line 2')
     A                                         COLHDG('ADDR' 'LINE2')
     A                                         ALWNULL
     A            CITY          30A         TEXT('City')
     A                                         COLHDG('CITY')
     A            STATE          2A         TEXT('State code')
     A                                         COLHDG('ST')
     A            ZIPCD         10A         TEXT('Postal code')
     A                                         COLHDG('ZIP' 'CODE')
     A            CRLMT         11P 2       TEXT('Credit limit')
     A                                         COLHDG('CREDIT' 'LIMIT')
     A                                         EDTCDE(1)
     A                                         DFT(0)
     A            ACTSTS         1A         TEXT('Active status')
     A                                         COLHDG('ACT' 'STS')
     A                                         DFT('A')
     A            LSTUPD          L         TEXT('Last update date')
     A                                         COLHDG('LAST' 'UPDATE')
     A          K CUSTID
     A                                         UNIQUE
```

## Why This Example Exists

- Shows full end-to-end PF generation from File Spec JSON
- Demonstrates TEXT, COLHDG, ALWNULL, DFT, EDTCDE keyword mapping
- Shows correct DDS column alignment
- Shows date field (L) without length
- Shows packed field (P) with decimals
- Shows UNIQUE key placement after K specification
- Shows multi-line keyword continuation (same field, no name repeated)
