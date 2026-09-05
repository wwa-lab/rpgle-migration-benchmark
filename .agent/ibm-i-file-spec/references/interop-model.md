# Interoperability Model — IBM i File Spec (V2.0)

Cross-spec reference rules for the IBM i SDLC skill family.

---

## Spec Graph

File Spec participates in a dependency graph with other spec types:

```
Technical Design
   ├──→ Program Spec ──→ Code Generator
   │       │ references          │ uses
   │       ↓                     ↓
   └──→ File Spec ──→ DDS Generator
```

The graph is navigable via stable IDs embedded in each spec's JSON layer.

---

## ID Scheme

### Spec ID

Format: `<NAME>-yyyymmdd-nn`

- `NAME`: IBM i object name or mnemonic (1-10 chars uppercase)
- `yyyymmdd`: Creation date
- `nn`: Daily sequence number (01, 02, ...)

This ID is globally unique across the spec family. It appears in:
- `specHeader.specId` in the spec's own JSON
- `fileSpecRef` in other specs that reference this file

### Element IDs

Element IDs are **stable within a spec** — they stay with the element across versions.
Deleted elements have their IDs retired (never reused within the same spec).

| Element | ID Format | Numbering Scope |
|---------|-----------|-----------------|
| Record Format | `FMT-nn` | 1-based within spec, in order of appearance |
| Field | `FLD-nn` | 1-based within spec, across all formats, top-to-bottom |
| Constraint | `CST-nn` | 1-based within spec |
| Select/Omit | `SO-nn` | 1-based within spec |
| Join | `JN-nn` | 1-based within spec |
| Indicator | `IND-nn` | 1-based within spec |
| Function Key | `FK-nn` | 1-based within spec |
| Field Validation | `FV-nn` | 1-based within spec |
| Error Message | `EM-nn` | 1-based within spec |
| Business Rule | `BR-nn` | 1-based within spec |
| Open Question | `OQ-nn` | 1-based within spec |

### Cross-Spec Reference Format

```
<specId>:<elementId>
```

Examples:
- `CUSTMAST-20260403-01:FLD-01` — field FLD-01 in CUSTMAST file spec
- `CUSTMAST-20260403-01:FMT-01` — format FMT-01 in CUSTMAST file spec
- `CUSTMAST-20260403-01:FMT-01:FLD-01` — format-qualified field (3-part form)

The 2-part form is sufficient because field IDs are unique within a spec. The 3-part
form is available when consumers want to navigate directly to the format.

---

## How Program Spec References File Spec

### File Usage Section

The Program Spec's File Usage table gains a `fileSpecRef` column in JSON:

```jsonc
// Program Spec JSON
"fileUsage": [
  {
    "fileName": "CUSTMAST",
    "fileSpecRef": "CUSTMAST-20260403-01",
    "fileSpecVersion": "1.0",
    "type": "U",
    "keyFields": [
      {
        "fieldName": "CUSTID",
        "fieldRef": "CUSTMAST-20260403-01:FLD-01"
      }
    ],
    "accessPattern": "1:1",
    "description": "Customer master — read and update"
  }
]
```

### Data Contract Section

Fields sourced from files reference File Spec fields:

```jsonc
// Program Spec JSON
"dataContract": [
  {
    "fieldName": "CUSTID",
    "source": "File",
    "sourceRef": "CUSTMAST-20260403-01:FLD-01",
    "storage": "Transient",
    "readBySteps": ["Step-01", "Step-03"],
    "writtenBySteps": ["Step-05"]
  }
]
```

### Main Logic Steps

In the JSON layer, step references to file fields use cross-spec refs:

```jsonc
// Program Spec JSON
"mainLogic": [
  {
    "stepId": "Step-02",
    "action": "CHAIN CUSTMAST by CUSTID",
    "fileRefs": ["CUSTMAST-20260403-01:FLD-01"],
    "businessRuleRef": "BR-01"
  }
]
```

---

## How File Spec References Other Specs

### relatedObjects

File Spec links to other specs via `specRef` in Related Objects:

```jsonc
"relatedObjects": [
  {
    "objectName": "ORDENTRY",
    "objectType": "PGM",
    "relationship": "Read by",
    "specRef": "ORDCONF-20260401-01"    // Program Spec ID
  }
]
```

### basedOnPhysicalFiles (LF)

LF File Spec links to its PF's File Spec:

```jsonc
"basedOnPhysicalFiles": [
  {
    "physicalFile": "CUSTMAST",
    "fileSpecRef": "CUSTMAST-20260403-01"
  }
]
```

### versionMetadata

Tracks upstream and downstream spec references:

```jsonc
"versionMetadata": {
  "sourceDocuments": [
    { "documentType": "Technical Design", "specId": "ORDMGMT-TD-20260401-01" }
  ],
  "downstreamReferences": [
    { "documentType": "Program Spec", "specId": "ORDCONF-20260401-01" }
  ]
}
```

---

## Consistency Enforcement Rules

### File Spec ↔ Program Spec

| Rule | Check | Direction |
|------|-------|-----------|
| Field existence | Every field referenced in Program Spec's fileUsage must exist in the File Spec's fieldDefinitions | Program Spec → File Spec |
| Field type match | Field type/length in Program Spec Data Contract must match File Spec | Program Spec → File Spec |
| Key field match | Key fields in Program Spec fileUsage must match File Spec keyDefinition | Program Spec → File Spec |
| Access pattern match | Program Spec access pattern (1:1/1:N) must be consistent with File Spec key uniqueness | Bidirectional |

### File Spec ↔ File Spec (LF → PF)

| Rule | Check | Direction |
|------|-------|-----------|
| Based-on exists | LF's basedOnPhysicalFiles references a valid PF File Spec | LF → PF |
| Field inclusion valid | LF's fieldSelectionMapping references fields that exist in PF | LF → PF |
| Select/omit fields valid | LF's selectOmitCriteria reference fields in PF | LF → PF |
| Join fields valid | LF's joinSpecification references fields in join PFs | LF → PFs |

### File Spec ↔ Technical Design

| Rule | Check | Direction |
|------|-------|-----------|
| File identified upstream | File Spec's file should appear in Technical Design's file access summary | File Spec → Technical Design |
| Design-level attributes consistent | Key fields, file purpose align with design intent | Bidirectional |

---

## Version Compatibility

When a File Spec version changes, downstream consumers assess impact via `changeImpact`:

| Classification | Downstream Action |
|----------------|-------------------|
| **non-breaking** | No action needed |
| **additive** | Optional: update Program Spec to use new fields |
| **breaking** | Required: review and update Program Spec, recompile programs |

The `versionMetadata.downstreamReferences` list identifies which specs need notification.

---

## DDS Generator Input Contract

The `ibm-i-dds-generator` (V2.0) consumes the JSON layer directly:

```
File Spec JSON → ibm-i-dds-generator → DDS Source → ibm-i-dds-reviewer
```

The generator reads:
- `specHeader.fileType` to determine DDS type (PF/LF/PRTF/DSPF)
- `fieldDefinitions` for field-level DDS statements
- `keyDefinition` for key specifications
- `constraints` for CHECK/UNIQUE/REFCST constraints
- `subfileDefinition` for DSPF subfile keywords
- `indicatorUsage` for conditioning indicators
- `functionKeyDefinitions` for CF/CA keywords
- `pageLayout` for PRTF page-level keywords

The JSON contract makes this possible without parsing human-readable Markdown.

After DDS generation, use `ibm-i-dds-reviewer` to validate the generated DDS against the
original File Spec JSON.
