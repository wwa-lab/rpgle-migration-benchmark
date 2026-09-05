# JSON Schema — IBM i File Spec (V2.0)

Machine-readable contract schema for the File Spec dual-layer output.
The JSON block must be **self-contained** — fully usable without reading the human-readable Markdown.

---

## Schema Version

```
"$schema": "ibm-i-file-spec/v2.0"
"schemaVersion": "2.0.0"
```

---

## Top-Level Structure

```jsonc
{
  "$schema": "ibm-i-file-spec/v2.0",
  "schemaVersion": "2.0.0",

  // Core sections (all file types, all levels)
  "specHeader": { ... },
  "amendmentHistory": [ ... ],
  "fileOverview": { ... },
  "recordFormats": [ ... ],
  "fieldDefinitions": { ... },           // map keyed by formatId
  "businessRules": [ ... ],
  "relatedObjects": [ ... ],
  "openQuestions": [ ... ],
  "specSummary": { ... },

  // Conditional sections (by file type)
  "versionFileInfo": { ... },            // when versionOf is set
  "keyDefinition": { ... },             // PF, LF
  "basedOnPhysicalFiles": [ ... ],      // LF
  "selectOmitCriteria": [ ... ],        // LF
  "joinSpecification": [ ... ],         // LF (join)
  "fieldSelectionMapping": { ... },     // LF
  "constraints": [ ... ],              // PF
  "pageLayout": { ... },               // PRTF
  "recordFormatLayouts": [ ... ],      // PRTF, DSPF
  "screenLayout": { ... },             // DSPF
  "functionKeyDefinitions": [ ... ],   // DSPF
  "subfileDefinition": { ... },        // DSPF (subfile)
  "indicatorUsage": [ ... ],           // PRTF, DSPF
  "fieldValidation": [ ... ],          // DSPF
  "errorMessageHandling": [ ... ],     // DSPF
  "editFormatting": [ ... ],           // PRTF
  "processingConsiderations": { ... },

  // V2.0 machine-layer sections
  "validationRules": { ... },
  "confidenceLevels": { ... },
  "changeImpact": { ... },
  "versionMetadata": { ... }
}
```

Sections that are OMIT at the current spec level or inapplicable to the file type are **absent**
from the JSON (not null, not empty). Presence/absence is semantic.

---

## Section Schemas

### specHeader

```jsonc
{
  "specId": "CUSTMAST-20260403-01",
  "specLevel": "L2",                    // "L1" | "L2" | "L3"
  "specLevelName": "Standard",          // "Lite" | "Standard" | "Full"
  "version": "1.0",
  "status": "Draft",                    // "Draft" | "Review" | "Approved"
  "changeType": "New File",             // "New File" | "Change to Existing"
  "fileType": "PF",                     // "PF" | "LF" | "PRTF" | "DSPF"
  "fileName": "CUSTMAST",
  "library": "ORDLIB",
  "sourceFile": "QDDSSRC",
  "versionOf": null,                    // source file name or null
  "description": "Customer master file storing core customer data."
}
```

### recordFormats

```jsonc
[
  {
    "formatId": "FMT-01",
    "formatName": "CUSTR",
    "purpose": "Customer master record",
    "fieldCount": 10,
    "changeTag": null                   // null | "NEW" | "MODIFIED" | "EXISTING"
  }
]
```

### fieldDefinitions

Map keyed by `formatId`. Field shape varies by file type.

#### PF / LF Field

```jsonc
{
  "fieldId": "FLD-01",
  "fieldName": "CUSTID",
  "type": "A",                          // A|P|S|B|I|F|L|T|Z
  "length": 10,
  "decimals": null,                     // required for P, S, B
  "text": "Customer ID",
  "nullable": false,                    // DDS ALWNULL
  "defaultValue": null,                 // DDS DFT keyword value
  "ccsid": null,                        // field-level CCSID or null
  "editCode": null,
  "editWord": null,
  "columnHeading": "CUS / ID",
  "ddsKeywords": [],                    // additional DDS keywords: ["VARLEN(100)"]
  "changeTag": null,
  "changeNote": null,
  "notes": "Key field"
}
```

#### PRTF Field

```jsonc
{
  "fieldId": "FLD-01",
  "fieldName": "RPTITLE",
  "type": "A",
  "length": 40,
  "decimals": null,
  "row": 1,
  "col": 20,
  "editCode": null,
  "editWord": null,
  "constantText": null,
  "conditionIndicators": [],
  "ddsKeywords": [],
  "changeTag": null,
  "changeNote": null,
  "notes": null
}
```

#### DSPF Field

```jsonc
{
  "fieldId": "FLD-01",
  "fieldName": "ORDNO",
  "type": "A",
  "length": 10,
  "decimals": null,
  "row": 3,
  "col": 22,
  "usage": "B",                         // "I" | "O" | "B" | "H"
  "displayAttributes": ["UL"],
  "conditionIndicators": [],
  "ddsKeywords": [],
  "changeTag": null,
  "changeNote": null,
  "notes": null
}
```

### keyDefinition (PF, LF)

```jsonc
{
  "unique": true,
  "accessPath": "Keyed",               // "Keyed" | "Arrival"
  "keys": [
    {
      "sequence": 1,
      "fieldName": "CUSTID",
      "fieldRef": "FLD-01",
      "sortDirection": "ASCEND",        // "ASCEND" | "DESCEND"
      "changeTag": null,
      "notes": null
    }
  ]
}
```

### basedOnPhysicalFiles (LF)

```jsonc
[
  {
    "physicalFile": "CUSTMAST",
    "library": "ORDLIB",
    "recordFormat": "CUSTR",
    "fileSpecRef": "CUSTMAST-20260403-01",
    "notes": null
  }
]
```

### selectOmitCriteria (LF)

```jsonc
[
  {
    "criteriaId": "SO-01",
    "sequence": 1,
    "fieldName": "ACTSTS",
    "fieldRef": "FLD-09",
    "comparison": "EQ",                 // EQ|NE|GT|GE|LT|LE|RANGE|VALUES|ALL
    "values": ["A"],
    "action": "Select",                // "Select" | "Omit"
    "changeTag": null,
    "notes": null
  }
]
```

### joinSpecification (LF join)

```jsonc
[
  {
    "joinId": "JN-01",
    "joinFrom": { "physicalFile": "ORDHDR", "fileSpecRef": null },
    "joinTo": { "physicalFile": "ORDDTL", "fileSpecRef": null },
    "joinFields": [
      { "fromField": "ORDNO", "toField": "ORDNO" }
    ],
    "joinType": "INNER",               // "INNER" | "OUTER"
    "notes": null
  }
]
```

### fieldSelectionMapping (LF)

```jsonc
{
  "mode": "allIncluded"                 // shorthand when all PF fields included unchanged
}
// OR
{
  "mode": "explicit",
  "mappings": [
    {
      "pfFieldName": "CUSTID",
      "pfFieldRef": "FLD-01",
      "lfFieldName": "CUSTID",
      "lfFieldRef": "FLD-01",
      "action": "Include",             // Include | Rename | Redefine | Omit
      "changeTag": null,
      "notes": null
    }
  ]
}
```

### constraints (PF)

```jsonc
[
  {
    "constraintId": "CST-01",
    "constraintType": "UNIQUE",         // "UNIQUE" | "CHECK" | "REFCST"
    "fields": ["CUSTID"],
    "fieldRefs": ["FLD-01"],
    "rule": "CUSTID must be unique",
    "referencedFile": null,             // for REFCST: parent file
    "referencedFileSpecRef": null,
    "changeTag": null,
    "notes": null
  }
]
```

### functionKeyDefinitions (DSPF)

```jsonc
[
  {
    "keyId": "FK-01",
    "key": "F3",
    "action": "Exit program",
    "keyType": "CA",                    // "CA" | "CF" | null
    "indicatorNumber": 3,
    "indicatorRef": "IND-01",
    "changeTag": null,
    "notes": null
  }
]
```

### subfileDefinition (DSPF)

```jsonc
{
  "subfileRecordFormat": "ORDSFL",
  "subfileRecordFormatRef": "FMT-02",
  "subfileControlFormat": "ORDCTL",
  "subfileControlFormatRef": "FMT-03",
  "subfileSize": 11,
  "subfilePage": 10,
  "sflclr": { "indicatorNumber": 40, "indicatorRef": "IND-04" },
  "sfldsp": { "indicatorNumber": 41, "indicatorRef": "IND-05" },
  "sfldspctl": { "indicatorNumber": 42, "indicatorRef": "IND-06" },
  "sflend": { "mode": "*MORE", "indicatorNumber": null }
}
```

### indicatorUsage (PRTF, DSPF)

```jsonc
[
  {
    "indicatorId": "IND-01",
    "indicatorNumber": 3,
    "purpose": "F3 pressed — exit",
    "whereUsed": ["FMT-01"],
    "changeTag": null,
    "notes": null
  }
]
```

### fieldValidation (DSPF)

```jsonc
[
  {
    "validationId": "FV-01",
    "fieldName": "ORDNO",
    "fieldRef": "FLD-01",
    "validationType": "CHECK",          // CHECK | COMP | VALUES | RANGE
    "rule": "ME",
    "errorMessage": "Order number is required",
    "errorMessageRef": "EM-01",
    "changeTag": null,
    "notes": null
  }
]
```

### errorMessageHandling (DSPF)

```jsonc
[
  {
    "messageId": "EM-01",
    "externalMessageId": null,
    "messageText": "Order number is required",
    "fieldRef": "FLD-01",
    "formatRef": "FMT-01",
    "indicatorNumber": 99,
    "indicatorRef": "IND-07",
    "changeTag": null,
    "notes": null
  }
]
```

### editFormatting (PRTF)

```jsonc
[
  {
    "fieldName": "ORDTOT",
    "fieldRef": "FLD-05",
    "editCode": "1",
    "editWord": null,
    "changeTag": null,
    "notes": null
  }
]
```

### businessRules

```jsonc
[
  {
    "ruleId": "BR-01",
    "description": "CUSTID must be unique across all records",
    "changeTag": null,
    "previousDescription": null,
    "relatedFieldRefs": ["FLD-01"],
    "relatedConstraintRefs": ["CST-01"],
    "notes": null
  }
]
```

### relatedObjects

```jsonc
[
  {
    "objectName": "ORDENTRY",
    "objectType": "PGM",
    "relationship": "Read by",
    "programType": "RPGLE",
    "specRef": "ORDCONF-20260401-01",
    "notes": null
  }
]
```

### processingConsiderations

```jsonc
{
  "journaling": "Required",
  "authority": "*PUBLIC *CHANGE",
  "ccsid": "N/A",
  "recordLength": 233,
  "memberPolicy": "Single-member",
  "additionalNotes": null
}
```

### openQuestions

```jsonc
[
  {
    "questionId": "OQ-01",
    "section": "Field Definitions",
    "sectionKey": "fieldDefinitions",
    "question": "Confirm EMAIL length of 60 is sufficient",
    "relatedRefs": ["FLD-11"],
    "status": "Open"
  }
]
```

---

## V2.0 Machine-Layer Sections

### validationRules

See `validation-rules.md` for the complete rule catalog. The JSON embeds applicable rules
per file type and spec level.

```jsonc
{
  "structural": [ { "ruleCode": "STRUCT-001", "description": "...", "check": "...", "severity": "ERROR" } ],
  "crossField": [ ... ],
  "lfPfConsistency": [ ... ],         // LF only
  "versionFileConsistency": [ ... ],  // version files only
  "specSummaryAccuracy": [ ... ],
  "sectionInclusion": [ ... ],
  "tierSpecific": [ ... ]
}
```

### confidenceLevels

```jsonc
{
  "methodology": "HIGH = 100% explicit input. MEDIUM = some inference, labeled. LOW = significant TBD.",
  "sections": {
    "fieldDefinitions": { "level": "HIGH", "notes": null },
    "businessRules": { "level": "MEDIUM", "notes": "BR-03 inferred from convention" }
  },
  "overallConfidence": "MEDIUM"
}
```

### changeImpact

```jsonc
{
  "classification": "additive",        // "non-breaking" | "additive" | "breaking"
  "rationale": "Two new fields added. No existing fields modified.",
  "impacts": [
    {
      "impactArea": "Record length",
      "description": "Increases by 75 bytes",
      "classification": "additive",
      "affectedObjects": ["CUSTMASTL1"]
    }
  ],
  "recompilationRequired": false,
  "recompilationNote": null
}
```

### versionMetadata

```jsonc
{
  "created": "2026-04-03T10:00:00Z",
  "lastModified": "2026-04-03T14:30:00Z",
  "specVersionHistory": [
    {
      "version": "1.0",
      "date": "2026-04-03T10:00:00Z",
      "author": "TBD",
      "description": "Initial draft",
      "changeClassification": null
    }
  ],
  "sourceDocuments": [
    { "documentType": "Technical Design", "specId": "ORDMGMT-TD-20260401-01", "version": "2.0" }
  ],
  "downstreamReferences": [
    { "documentType": "Program Spec", "specId": "ORDCONF-20260401-01", "version": "1.0" }
  ]
}
```

---

## ID Scheme Summary

See `interop-model.md` for cross-spec reference rules.

| ID Format | Scope | Example |
|-----------|-------|---------|
| `<NAME>-yyyymmdd-nn` | Global spec ID | `CUSTMAST-20260403-01` |
| `FMT-nn` | Record format within spec | `FMT-01` |
| `FLD-nn` | Field within spec (across all formats) | `FLD-07` |
| `CST-nn` | Constraint (PF) | `CST-01` |
| `SO-nn` | Select/omit criterion (LF) | `SO-01` |
| `JN-nn` | Join specification (LF join) | `JN-01` |
| `IND-nn` | Indicator (PRTF/DSPF) | `IND-03` |
| `FK-nn` | Function key (DSPF) | `FK-01` |
| `FV-nn` | Field validation (DSPF) | `FV-01` |
| `EM-nn` | Error message (DSPF) | `EM-01` |
| `BR-nn` | Business rule | `BR-01` |
| `OQ-nn` | Open question | `OQ-01` |

Cross-spec reference format: `<specId>:<elementId>`
Example: `CUSTMAST-20260403-01:FLD-01`
