# Example: Fixed-Format RPGLE Full Member with Readability Standards

Use this example when generating a **fixed-format RPGLE full member** or **full revised member**.
It demonstrates the three readability standards: banner separators, blank-line spacing, and
subroutine naming convention.

## Scenario

- Change Type: `Change to Existing` (full revised member requested with current source)
- Program Type: `RPGLE`
- Source Format: `Fixed format`
- Output Mode: `Full Implementation`
- Reference Source: provided — uses numbered subroutine pattern (SR100, SR200, SR980)

## Program Spec Cues

- `Interface Contract`: receives P0HCCM (company code), P0RQSN (request number),
  P0MSRQ (message request), P0MSRP (message response)
- `File Usage`: ORDHDR (1:1 by order key), ORDDTL (1:N by order key)
- `Main Logic`:
  - `Step 1 (SR100)`: Validate input parameters
  - `Step 2 (SR200)`: Process order — read header, loop detail lines
  - `Step 3 (SR980)`: Cleanup and return
- `BR-01`: Company code must not be blank
- `BR-02`: If order header not found, set error response

## Expected Shape

```rpgle
     H DFTACTGRP(*NO) ACTGRP(*CALLER)
     H*
     H* Program: CUR93R1
     H* Purpose: Order validation program
     H* Author:  (per shop standard)
     H*
     F**************************************************************
     F* File declarations
     F**************************************************************
     FORDHDR    IF   E           K DISK
     FORDDTL    IF   E           K DISK

     D**************************************************************
     D* Work fields
     D**************************************************************
     D wkFound         S              1A   INZ('N')
     D wkTotal         S             11  2 INZ(0)

     C**************************************************************
     C* Entry parameters
     C**************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P0HCCM
     C                   PARM                    P0RQSN
     C                   PARM                    P0MSRQ
     C                   PARM                    P0MSRP

     C**************************************************************
     C* Main Line
     C**************************************************************
     C                   EXSR      SR100
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SR200
     C                   ENDIF
     C                   EXSR      SR980
     C                   SETON                                        LR
     C                   RETURN

     C**************************************************************
     C* SR100 - Validate input parameters
     C**************************************************************
     C     SR100         BEGSR
     C*
     C* Step 1 / BR-01: Company code must not be blank
     C     P0HCCM        IFNE      *BLANKS
     C                   MOVEL     'Y'           wkFound
     C                   ELSE
     C                   MOVEL     'INVALID CO'  P0MSRP
     C                   SETON                                        99
     C                   ENDIF
     C*
     C                   ENDSR

     C**************************************************************
     C* SR200 - Process order header and detail
     C**************************************************************
     C     SR200         BEGSR
     C*
     C* Step 2a: Read order header (1:1 access)
     C     KYORDR        CHAIN     ORDHDRR
     C                   IF        NOT %FOUND(ORDHDR)
     C* BR-02: Order header not found
     C                   MOVEL     'ORDER N/F'   P0MSRP
     C                   SETON                                        99
     C                   GOTO      SR200EX
     C                   ENDIF
     C*
     C* Step 2b: Loop order detail lines (1:N access)
     C     KYORDR        SETLL     ORDDTLR
     C     KYORDR        READE     ORDDTLR
     C                   DOW       NOT %EOF(ORDDTL)
     C                   ADD       LNAMT         wkTotal
     C     KYORDR        READE     ORDDTLR
     C                   ENDDO
     C*
     C     SR200EX       TAG
     C                   ENDSR

     C**************************************************************
     C* SR980 - Cleanup and return
     C**************************************************************
     C     SR980         BEGSR
     C*
     C* Step 3: Set response and return
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'OK'          P0MSRP
     C                   ENDIF
     C*
     C                   ENDSR
```

## Readability Features Demonstrated

| Feature | Where Shown |
|---------|------------|
| **Banner separators** | `C******...` blocks before Entry parameters, Main Line, and each subroutine |
| **Section title comments** | `C* Entry parameters`, `C* Main Line`, `C* SR100 - Validate input parameters`, etc. |
| **Blank-line spacing** | Blank line before each banner block and after each `ENDSR` |
| **Subroutine naming** | Numbered pattern `SR100`, `SR200`, `SR980` extracted from reference source |
| **Step/BR trace comments** | `C* Step 1 / BR-01`, `C* Step 2a`, `C* BR-02` inside subroutines |
| **Separator comments within subroutines** | `C*` blank comment lines separate logical sub-blocks within a subroutine |

## Key Conventions

- **SR980** is the cleanup/return subroutine — this is a common shop convention where
  high-numbered subroutines handle end-of-program processing
- **`C*` blank comment lines** (not blank lines) are used within subroutines to separate
  logical sub-blocks while keeping the C-spec indicator column intact
- **Banner width** follows the reference source pattern — in this example, 62 asterisks
  after `C*` to fill the comment area
- **F-spec and D-spec banners** are also included — if the reference source uses banners
  for file and data declarations, follow that pattern

## Why This Example Exists

- Shows the fixed-format readability rules in a complete full-member context
- Demonstrates all three coding standards: banner separators, blank-line spacing, and
  subroutine naming convention
- Complements `sample-rpgle-existing-fixed-change-block.md` (which shows a patch) and
  `sample-rpgle-new-free.md` (which shows free-format)
- Provides a concrete visual target for the code generator when producing fixed-format output
