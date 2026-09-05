# DDS Generator Test Harness (V1.0 — PF Only)

This document contains structured test cases for the `ibm-i-dds-generator` skill.
Each test case includes an input JSON, expected output (or expected error), and a
verification checklist.

## How to Run

**Manual**: Invoke `/ibm-i-dds-generator` with each test case's Input JSON and compare the
output against the Expected Output section.

**Semi-automated**: Feed each test JSON to the skill in sequence, capture output, and
diff against expected. Use the Verdict field to record PASS / FAIL / PARTIAL.

---

## Test Case Index

| ID | Category | Description | Key Feature Tested |
|----|----------|-------------|-------------------|
| TC-01 | Happy Path | Full CUSTMAST PF | All keywords, UNIQUE key, date field |
| TC-02 | Happy Path | Minimal valid PF | Bare minimum input |
| TC-03 | Happy Path | All nine field types | A, P, S, B, I, F, L, T, Z |
| TC-04 | Happy Path | Multiple key fields, non-unique | Multi-key, no UNIQUE |
| TC-05 | Happy Path | Multiple keywords per field | ALWNULL + DFT + COLHDG stacking |
| TC-06 | Happy Path | CCSID keyword | CCSID on alpha field |
| TC-07 | Happy Path | No key definition | PF with no access path |
| TC-08 | Edge Case | Long TEXT truncation | TEXT > 50 chars |
| TC-09 | Edge Case | TBD field name | TODO comment generation |
| TC-10 | Rejection | Non-PF file type (LF) | V1.0 scope guard |
| TC-11 | Rejection | Missing fieldName | Validation failure |
| TC-12 | Rejection | Missing decimals on P field | Validation failure |
| TC-13 | Anti-Hallucination | Exact field count check | No invented fields |

---

## TC-01 — Full CUSTMAST PF (Happy Path)

**Purpose**: End-to-end PF generation with all keyword types.

**Input JSON**:

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

**Expected Output**:

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

**Verification Checklist**:
- [ ] File-level TEXT present with line continuation for long text
- [ ] Record format R line with TEXT keyword
- [ ] 10 fields — no more, no less
- [ ] ADDR2 has ALWNULL (nullable: true)
- [ ] CRLMT has EDTCDE(1) and DFT(0) — numeric default, no quotes
- [ ] ACTSTS has DFT('A') — alpha default, with quotes
- [ ] LSTUPD is type L with no length value
- [ ] K CUSTID followed by UNIQUE on next line
- [ ] COLHDG splits on ` / ` separator
- [ ] DDS column alignment correct throughout

**Verdict**: ___

---

## TC-02 — Minimal Valid PF (Happy Path)

**Purpose**: Simplest possible valid input — one alpha field, no key, no optional keywords.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "MINI-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "MINIPF",
    "description": "Minimal test file"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "MINIR",
      "purpose": "Minimal record",
      "fieldCount": 1
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      {
        "fieldId": "FLD-01",
        "fieldName": "FLD1",
        "type": "A",
        "length": 10,
        "decimals": null,
        "nullable": false,
        "defaultValue": null,
        "ccsid": null,
        "text": "Test field",
        "editCode": null,
        "columnHeading": null,
        "ddsKeywords": []
      }
    ]
  }
}
```

**Expected Output**:

```dds
                                      TEXT('Minimal test file')
     A          R MINIR                TEXT('Minimal record')
     A            FLD1          10A         TEXT('Test field')
```

**Verification Checklist**:
- [ ] Exactly 3 DDS lines (file TEXT, format R, one field)
- [ ] No COLHDG line (columnHeading is null)
- [ ] No K lines (no keyDefinition)
- [ ] No ALWNULL, DFT, EDTCDE, CCSID keywords
- [ ] No invented fields or keywords

**Verdict**: ___

---

## TC-03 — All Nine Field Types (Happy Path)

**Purpose**: Verify every supported DDS data type maps correctly.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "ALLTYP-20260404-01",
    "specLevel": "L2",
    "fileType": "PF",
    "fileName": "ALLTYPES",
    "description": "All field types test"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "ALLTYPR",
      "purpose": "All types record",
      "fieldCount": 9
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "FALPHA", "type": "A", "length": 20, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Alpha field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "FPACKD", "type": "P", "length": 9, "decimals": 2, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Packed field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-03", "fieldName": "FZONED", "type": "S", "length": 7, "decimals": 0, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Zoned field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-04", "fieldName": "FBIN", "type": "B", "length": 9, "decimals": 0, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Binary field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-05", "fieldName": "FINT", "type": "I", "length": 10, "decimals": 0, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Integer field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-06", "fieldName": "FFLOAT", "type": "F", "length": 8, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Float field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-07", "fieldName": "FDATE", "type": "L", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Date field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-08", "fieldName": "FTIME", "type": "T", "length": 8, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Time field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-09", "fieldName": "FTSTMP", "type": "Z", "length": 26, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Timestamp field", "editCode": null, "columnHeading": null, "ddsKeywords": [] }
    ]
  }
}
```

**Expected Output**:

```dds
                                      TEXT('All field types test')
     A          R ALLTYPR              TEXT('All types record')
     A            FALPHA        20A         TEXT('Alpha field')
     A            FPACKD         9P 2       TEXT('Packed field')
     A            FZONED         7S 0       TEXT('Zoned field')
     A            FBIN           9B 0       TEXT('Binary field')
     A            FINT          10I 0       TEXT('Integer field')
     A            FFLOAT         8F         TEXT('Float field')
     A            FDATE           L         TEXT('Date field')
     A            FTIME           T         TEXT('Time field')
     A            FTSTMP          Z         TEXT('Timestamp field')
```

**Verification Checklist**:
- [ ] A type: length + `A` suffix, no decimals
- [ ] P type: length + `P` + space + decimals
- [ ] S type: length + `S` + space + decimals
- [ ] B type: length + `B` + space + decimals
- [ ] I type: length + `I` + space + decimals
- [ ] F type: length + `F`, no decimals
- [ ] L type: no length, just `L`
- [ ] T type: no length, just `T`
- [ ] Z type: no length, just `Z`
- [ ] Exactly 9 fields

**Verdict**: ___

---

## TC-04 — Multiple Key Fields, Non-Unique (Happy Path)

**Purpose**: Compound key with no UNIQUE keyword.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "ORDDTL-20260404-01",
    "specLevel": "L2",
    "fileType": "PF",
    "fileName": "ORDDTL",
    "description": "Order detail file"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "ORDDTLR",
      "purpose": "Order detail record",
      "fieldCount": 4
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "ORDNBR", "type": "P", "length": 7, "decimals": 0, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Order number", "editCode": null, "columnHeading": "ORD / NBR", "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "LINSEQ", "type": "P", "length": 3, "decimals": 0, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Line sequence", "editCode": null, "columnHeading": "LINE / SEQ", "ddsKeywords": [] },
      { "fieldId": "FLD-03", "fieldName": "ITMNBR", "type": "A", "length": 15, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Item number", "editCode": null, "columnHeading": "ITEM / NBR", "ddsKeywords": [] },
      { "fieldId": "FLD-04", "fieldName": "QTYORD", "type": "P", "length": 7, "decimals": 2, "nullable": false, "defaultValue": "0", "ccsid": null, "text": "Quantity ordered", "editCode": null, "columnHeading": "QTY / ORD", "ddsKeywords": [] }
    ]
  },
  "keyDefinition": {
    "unique": false,
    "accessPath": "Keyed",
    "keys": [
      { "sequence": 1, "fieldName": "ORDNBR", "fieldRef": "FLD-01", "sortDirection": "ASCEND" },
      { "sequence": 2, "fieldName": "LINSEQ", "fieldRef": "FLD-02", "sortDirection": "ASCEND" }
    ]
  }
}
```

**Expected Output**:

```dds
                                      TEXT('Order detail file')
     A          R ORDDTLR              TEXT('Order detail record')
     A            ORDNBR         7P 0       TEXT('Order number')
     A                                         COLHDG('ORD' 'NBR')
     A            LINSEQ         3P 0       TEXT('Line sequence')
     A                                         COLHDG('LINE' 'SEQ')
     A            ITMNBR        15A         TEXT('Item number')
     A                                         COLHDG('ITEM' 'NBR')
     A            QTYORD         7P 2       TEXT('Quantity ordered')
     A                                         COLHDG('QTY' 'ORD')
     A                                         DFT(0)
     A          K ORDNBR
     A          K LINSEQ
```

**Verification Checklist**:
- [ ] Two K lines in sequence: ORDNBR then LINSEQ
- [ ] No UNIQUE keyword (unique: false)
- [ ] Both key fields exist in field definitions
- [ ] DFT(0) on QTYORD — numeric, no quotes

**Verdict**: ___

---

## TC-05 — Multiple Keywords Per Field (Happy Path)

**Purpose**: Verify keyword stacking on continuation lines when a field has ALWNULL + DFT + COLHDG.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "KWDSTK-20260404-01",
    "specLevel": "L2",
    "fileType": "PF",
    "fileName": "KWDSTACK",
    "description": "Keyword stacking test"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "KWDR",
      "purpose": "Keyword test record",
      "fieldCount": 2
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      {
        "fieldId": "FLD-01",
        "fieldName": "NOTES",
        "type": "A",
        "length": 50,
        "decimals": null,
        "nullable": true,
        "defaultValue": "N/A",
        "ccsid": 37,
        "text": "General notes",
        "editCode": null,
        "columnHeading": "GEN / NOTES",
        "ddsKeywords": []
      },
      {
        "fieldId": "FLD-02",
        "fieldName": "AMT",
        "type": "P",
        "length": 9,
        "decimals": 2,
        "nullable": true,
        "defaultValue": "0",
        "ccsid": null,
        "text": "Amount",
        "editCode": "1",
        "columnHeading": "AMT",
        "ddsKeywords": []
      }
    ]
  }
}
```

**Expected Output**:

```dds
                                      TEXT('Keyword stacking test')
     A          R KWDR                 TEXT('Keyword test record')
     A            NOTES         50A         TEXT('General notes')
     A                                         COLHDG('GEN' 'NOTES')
     A                                         ALWNULL
     A                                         DFT('N/A')
     A                                         CCSID(37)
     A            AMT            9P 2       TEXT('Amount')
     A                                         COLHDG('AMT')
     A                                         ALWNULL
     A                                         EDTCDE(1)
     A                                         DFT(0)
```

**Verification Checklist**:
- [ ] NOTES has 4 continuation lines: COLHDG, ALWNULL, DFT, CCSID
- [ ] AMT has 3 continuation lines: COLHDG, ALWNULL, EDTCDE, DFT
- [ ] DFT('N/A') — alpha field default with quotes
- [ ] DFT(0) — numeric field default without quotes
- [ ] CCSID(37) on NOTES
- [ ] No field name repeated on continuation lines

**Verdict**: ___

---

## TC-06 — CCSID Keyword (Happy Path)

**Purpose**: Verify CCSID keyword generates correctly on alpha fields.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "CCSID-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "CCSPF",
    "description": "CCSID test file"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "CCSR",
      "purpose": "CCSID test record",
      "fieldCount": 2
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "JPNAME", "type": "A", "length": 30, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": 5035, "text": "Japanese name", "editCode": null, "columnHeading": "JP / NAME", "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "USNAME", "type": "A", "length": 30, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": 37, "text": "US English name", "editCode": null, "columnHeading": "US / NAME", "ddsKeywords": [] }
    ]
  }
}
```

**Expected Output**:

```dds
                                      TEXT('CCSID test file')
     A          R CCSR                 TEXT('CCSID test record')
     A            JPNAME        30A         TEXT('Japanese name')
     A                                         COLHDG('JP' 'NAME')
     A                                         CCSID(5035)
     A            USNAME        30A         TEXT('US English name')
     A                                         COLHDG('US' 'NAME')
     A                                         CCSID(37)
```

**Verification Checklist**:
- [ ] CCSID(5035) on JPNAME
- [ ] CCSID(37) on USNAME
- [ ] Both on continuation lines (not inline with field)

**Verdict**: ___

---

## TC-07 — No Key Definition (Happy Path)

**Purpose**: PF with arrival-sequence access (no keyed access path).

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "NOKEY-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "LOGPF",
    "description": "Audit log file"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "LOGR",
      "purpose": "Log entry record",
      "fieldCount": 3
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "LOGTS", "type": "Z", "length": 26, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Log timestamp", "editCode": null, "columnHeading": "LOG / TS", "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "LOGUSR", "type": "A", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "User profile", "editCode": null, "columnHeading": "LOG / USER", "ddsKeywords": [] },
      { "fieldId": "FLD-03", "fieldName": "LOGMSG", "type": "A", "length": 200, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Log message", "editCode": null, "columnHeading": "LOG / MSG", "ddsKeywords": [] }
    ]
  }
}
```

**Expected Output**:

```dds
                                      TEXT('Audit log file')
     A          R LOGR                 TEXT('Log entry record')
     A            LOGTS           Z         TEXT('Log timestamp')
     A                                         COLHDG('LOG' 'TS')
     A            LOGUSR        10A         TEXT('User profile')
     A                                         COLHDG('LOG' 'USER')
     A            LOGMSG       200A         TEXT('Log message')
     A                                         COLHDG('LOG' 'MSG')
```

**Verification Checklist**:
- [ ] No K lines at all
- [ ] No UNIQUE keyword
- [ ] Timestamp field Z has no length
- [ ] 3 fields exactly

**Verdict**: ___

---

## TC-08 — Long TEXT Truncation (Edge Case)

**Purpose**: Verify TEXT keyword values > 50 characters are handled correctly.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "LNGTXT-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "LNGTXT",
    "description": "This is a very long description that exceeds fifty characters and should be handled"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "LNGR",
      "purpose": "Record with long text values that also exceeds the limit",
      "fieldCount": 1
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      {
        "fieldId": "FLD-01",
        "fieldName": "LNGFLD",
        "type": "A",
        "length": 10,
        "decimals": null,
        "nullable": false,
        "defaultValue": null,
        "ccsid": null,
        "text": "This field text is also very long and exceeds the fifty character maximum allowed by DDS",
        "editCode": null,
        "columnHeading": null,
        "ddsKeywords": []
      }
    ]
  }
}
```

**Expected Behavior**:

The skill should either:
- Truncate TEXT values to 50 characters, OR
- Use DDS line continuation for long TEXT values

Either approach is acceptable as long as the DDS is valid on IBM i.

**Verification Checklist**:
- [ ] File-level TEXT handles > 50 chars (truncation or continuation)
- [ ] Format-level TEXT handles > 50 chars
- [ ] Field-level TEXT handles > 50 chars
- [ ] Resulting DDS is syntactically valid

**Verdict**: ___

---

## TC-09 — TBD Field Name (Edge Case)

**Purpose**: Verify TBD values in the JSON produce TODO comments in DDS.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "TBD-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "TBDPF",
    "description": "TBD test file"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "TBDR",
      "purpose": "TBD test record",
      "fieldCount": 3
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "GOODFLD", "type": "A", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Good field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "TBD", "type": "A", "length": 20, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "TBD field name", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-03", "fieldName": "ANOTHGD", "type": "P", "length": 7, "decimals": 2, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Another good field", "editCode": null, "columnHeading": null, "ddsKeywords": [] }
    ]
  }
}
```

**Expected Behavior**:

The TBD field should produce a TODO comment line:

```dds
     A* TODO: FLD-02 field name is TBD — resolve in File Spec
```

The other two fields should generate normally.

**Verification Checklist**:
- [ ] GOODFLD generates normal DDS
- [ ] TBD field produces an `A*` comment line (not a DDS field line)
- [ ] ANOTHGD generates normal DDS
- [ ] No partial or invalid DDS for the TBD field

**Verdict**: ___

---

## TC-10 — Non-PF File Type Rejection (LF)

**Purpose**: V1.0 scope guard — must reject non-PF input.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "LF-20260404-01",
    "specLevel": "L2",
    "fileType": "LF",
    "fileName": "CUSTL1",
    "description": "Customer name lookup"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "CUSTL1R",
      "purpose": "Customer by name",
      "fieldCount": 2
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "CUSTNM", "type": "A", "length": 40, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Customer name", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "CUSTID", "type": "A", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Customer ID", "editCode": null, "columnHeading": null, "ddsKeywords": [] }
    ]
  },
  "keyDefinition": {
    "unique": false,
    "accessPath": "Keyed",
    "keys": [
      { "sequence": 1, "fieldName": "CUSTNM", "fieldRef": "FLD-01", "sortDirection": "ASCEND" }
    ]
  }
}
```

**Expected Behavior**:

No DDS output. The skill must stop and state that V1.0 supports PF only.

**Verification Checklist**:
- [ ] No DDS source generated
- [ ] Clear message: V1.0 supports PF only
- [ ] No partial output

**Verdict**: ___

---

## TC-11 — Missing fieldName (Rejection)

**Purpose**: Validation failure — a required attribute is missing.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "BADFLD-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "BADPF",
    "description": "Missing fieldName test"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "BADR",
      "purpose": "Bad record",
      "fieldCount": 2
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "OKFLD", "type": "A", "length": 10, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "OK field", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-02", "type": "A", "length": 20, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Missing name", "editCode": null, "columnHeading": null, "ddsKeywords": [] }
    ]
  }
}
```

**Expected Behavior**:

Validation fails. No DDS output. The skill must list the specific blocker:
FLD-02 is missing `fieldName`.

**Verification Checklist**:
- [ ] No DDS source generated (not even partial)
- [ ] Specific error message identifying FLD-02 missing fieldName
- [ ] Does not generate DDS for the valid field alone

**Verdict**: ___

---

## TC-12 — Missing Decimals on Packed Field (Rejection)

**Purpose**: Validation failure — numeric field missing required decimals.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "BADDEC-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "BADDEC",
    "description": "Missing decimals test"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "BADDR",
      "purpose": "Bad decimals record",
      "fieldCount": 1
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      {
        "fieldId": "FLD-01",
        "fieldName": "BADAMT",
        "type": "P",
        "length": 9,
        "decimals": null,
        "nullable": false,
        "defaultValue": null,
        "ccsid": null,
        "text": "Amount missing decimals",
        "editCode": null,
        "columnHeading": null,
        "ddsKeywords": []
      }
    ]
  }
}
```

**Expected Behavior**:

Validation fails. No DDS output. The skill must identify:
BADAMT (FLD-01) is type P but `decimals` is null.

**Verification Checklist**:
- [ ] No DDS source generated
- [ ] Specific error identifying BADAMT as P type with missing decimals
- [ ] Clear that P, S, B types require decimals

**Verdict**: ___

---

## TC-13 — Anti-Hallucination: Exact Field Count (Anti-Hallucination)

**Purpose**: Verify the generator outputs exactly the fields in the JSON — no more, no less.
This is a critical safety check: the skill must not invent "helpful" fields like audit
timestamps, create dates, or sequence numbers.

**Input JSON**:

```json
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",
  "specHeader": {
    "specId": "EXACT-20260404-01",
    "specLevel": "L1",
    "fileType": "PF",
    "fileName": "EXACTPF",
    "description": "Exact count test"
  },
  "recordFormats": [
    {
      "formatId": "FMT-01",
      "formatName": "EXACTR",
      "purpose": "Exact count record",
      "fieldCount": 3
    }
  ],
  "fieldDefinitions": {
    "FMT-01": [
      { "fieldId": "FLD-01", "fieldName": "AAA", "type": "A", "length": 5, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Field A", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-02", "fieldName": "BBB", "type": "A", "length": 5, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Field B", "editCode": null, "columnHeading": null, "ddsKeywords": [] },
      { "fieldId": "FLD-03", "fieldName": "CCC", "type": "A", "length": 5, "decimals": null, "nullable": false, "defaultValue": null, "ccsid": null, "text": "Field C", "editCode": null, "columnHeading": null, "ddsKeywords": [] }
    ]
  },
  "keyDefinition": {
    "unique": true,
    "accessPath": "Keyed",
    "keys": [
      { "sequence": 1, "fieldName": "AAA", "fieldRef": "FLD-01", "sortDirection": "ASCEND" }
    ]
  }
}
```

**Expected Output**:

```dds
                                      TEXT('Exact count test')
     A          R EXACTR               TEXT('Exact count record')
     A            AAA            5A         TEXT('Field A')
     A            BBB            5A         TEXT('Field B')
     A            CCC            5A         TEXT('Field C')
     A          K AAA
     A                                         UNIQUE
```

**Verification Checklist**:
- [ ] Exactly 3 field lines (AAA, BBB, CCC)
- [ ] No invented fields (no CRTDAT, CRTUSR, SEQNBR, etc.)
- [ ] No extra keywords not in the JSON
- [ ] Field order matches JSON order
- [ ] K AAA with UNIQUE — only key field in the JSON

**Verdict**: ___

---

## Test Execution Log

| TC | Date | Tester | Verdict | Notes |
|----|------|--------|---------|-------|
| TC-01 | | | | |
| TC-02 | | | | |
| TC-03 | | | | |
| TC-04 | | | | |
| TC-05 | | | | |
| TC-06 | | | | |
| TC-07 | | | | |
| TC-08 | | | | |
| TC-09 | | | | |
| TC-10 | | | | |
| TC-11 | | | | |
| TC-12 | | | | |
| TC-13 | | | | |
