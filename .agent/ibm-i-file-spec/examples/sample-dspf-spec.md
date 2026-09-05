# Example: L3 Full — New Display File (DSPF) with Subfile

## Scenario

An order inquiry display file with a subfile showing order detail lines. The screen
displays order header information at the top and a scrollable list of order lines below.

---

## Spec Header

- **Spec ID:** ORDDSPLY-20260403-01
- **Spec Level:** L3 Full
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New File
- **File Type:** DSPF
- **File Name:** ORDINQD
- **Library:** ORDLIB
- **Source File:** QDDSSRC
- **Description:** Order inquiry display file with subfile for order detail lines.

---

## Amendment History

| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0     | TBD  | TBD    | Initial draft      |

---

## File Overview

Displays order inquiry information for a given order number. The header area shows
order-level data (customer, date, status, total). The subfile area shows individual
order lines (item, quantity, price, line total) with page-at-a-time scrolling.

---

## Record Format(s)

| Format Name | Purpose | Fields Count |
|-------------|---------|-------------|
| ORDHDR | Order header information display | 8 |
| ORDSFL | Subfile record — one order detail line | 5 |
| ORDCTL | Subfile control — controls subfile display and footer | 3 |

---

## Field Definitions

### ORDHDR (Order Header)

| Field Name | Type | Length | Decimals | Row | Col | Usage (I/O/B/H) | Display Attr | Indicator | Notes |
|------------|------|--------|----------|-----|-----|------------------|-------------|-----------|-------|
| ORDNO | A | 10 | | 3 | 22 | B | UL | | Order number (input for inquiry) |
| CUSTNM | A | 40 | | 5 | 22 | O | | | Customer name |
| ORDDTE | L | 10 | | 5 | 70 | O | | | Order date |
| ORDSTS | A | 10 | | 7 | 22 | O | | | Order status description |
| ORDTOT | P | 11 | 2 | 7 | 62 | O | | | Order total |
| ERRMSG | A | 50 | | 22 | 2 | O | RI | 99 | Error message line |
| H1TEXT | A | 30 | | 1 | 25 | O | HI | | Screen title constant |
| H1DATE | L | 10 | | 1 | 70 | O | | | System date |

### ORDSFL (Subfile Record)

| Field Name | Type | Length | Decimals | Row | Col | Usage (I/O/B/H) | Display Attr | Indicator | Notes |
|------------|------|--------|----------|-----|-----|------------------|-------------|-----------|-------|
| LNSEQ | P | 3 | 0 | 10 | 3 | O | | | Line sequence number |
| ITEMID | A | 15 | | 10 | 10 | O | | | Item ID |
| ITMQTY | P | 7 | 0 | 10 | 28 | O | | | Quantity |
| UNITPR | P | 9 | 2 | 10 | 40 | O | | | Unit price |
| LNTOT | P | 11 | 2 | 10 | 55 | O | | | Line total |

### ORDCTL (Subfile Control)

| Field Name | Type | Length | Decimals | Row | Col | Usage (I/O/B/H) | Display Attr | Indicator | Notes |
|------------|------|--------|----------|-----|-----|------------------|-------------|-----------|-------|
| COLHD1 | A | 76 | | 9 | 2 | O | UL | | Column heading line |
| PGMSG | A | 20 | | 23 | 30 | O | | | Page indicator message |
| FKTEXT | A | 76 | | 24 | 2 | O | | | Function key help text |

---

## Screen Layout

- **Screen Size:** 24 x 80
- **Display Attributes:** Standard green-screen layout

## Record Format Layout

### ORDHDR (Rows 1–8)

```
Row 1:  [Title Constant]                              [System Date]
Row 2:  ─────────────────────────────────────────────────────────────
Row 3:  Order Number: [ORDNO________]
Row 5:  Customer:     [CUSTNM________________________]  Date: [ORDDTE]
Row 7:  Status:       [ORDSTS____]        Total: [ORDTOT_____]
Row 8:  ─────────────────────────────────────────────────────────────
```

### ORDCTL / ORDSFL (Rows 9–21)

```
Row 9:  Seq  Item ID          Qty     Unit Price    Line Total
Row 10-20: [subfile data rows — one ORDSFL record per line]
Row 21: (end of subfile area)
```

### Footer (Rows 22–24)

```
Row 22: [ERRMSG — displayed only when indicator 99 is on]
Row 23:                    [Page indicator]
Row 24: F3=Exit  F5=Refresh  F12=Cancel
```

---

## Function Key Definitions

| Key | Action | Indicator | Notes |
|-----|--------|-----------|-------|
| F3 | Exit program | 03 | CA03 — no data returned |
| F5 | Refresh inquiry | 05 | CF05 — re-read data |
| F12 | Cancel / return to previous | 12 | CA12 — no data returned |
| ENTER | Execute inquiry by ORDNO | | Submits ORDNO for lookup |
| PAGEDOWN | Scroll subfile forward | | ROLLUP keyword on ORDCTL |
| PAGEUP | Scroll subfile backward | | ROLLDOWN keyword on ORDCTL |

---

## Subfile Definition

- **Subfile Record Format:** ORDSFL
- **Subfile Control Format:** ORDCTL
- **Subfile Size:** 11
- **Subfile Page:** 10
- **SFLCLR Indicator:** 40 (clear subfile before reload)
- **SFLDSP Indicator:** 41 (display subfile records)
- **SFLDSPCTL Indicator:** 42 (display subfile control format)
- **SFLEND Indicator:** *MORE

---

## Indicator Usage

| Indicator | Purpose | Where Used |
|-----------|---------|------------|
| 03 | F3 pressed — exit | ORDHDR (CA03) |
| 05 | F5 pressed — refresh | ORDHDR (CF05) |
| 12 | F12 pressed — cancel | ORDHDR (CA12) |
| 40 | SFLCLR — clear subfile | ORDCTL |
| 41 | SFLDSP — display subfile records | ORDCTL |
| 42 | SFLDSPCTL — display control format | ORDCTL |
| 99 | Error condition — display error message | ORDHDR (ERRMSG field) |

---

## Field Validation

| Field | Validation Type | Rule | Error Message |
|-------|----------------|------|---------------|
| ORDNO | CHECK(ME) | Mandatory entry — cannot be blank | "Order number is required" |

---

## Error Message Handling

| # | Message ID | Message Text | Field / Format | Indicator |
|---|------------|-------------|----------------|-----------|
| 1 | — | Order number is required | ORDNO / ORDHDR | 99 |
| 2 | — | Order not found | ERRMSG / ORDHDR | 99 |

---

## Edit Formatting

N/A (DSPF — edit formatting section is for PRTF only)

---

## Business Rules

1. BR-01: Order number must be entered before inquiry can execute
2. BR-02: If order number is not found, display error message and do not load subfile

---

## Related Objects

| Object Name | Type | Relationship | Notes |
|-------------|------|-------------|-------|
| ORDHDR | PF | Read by | Order header physical file |
| ORDDTL | PF | Read by | Order detail physical file |
| ORDINQ | PGM (RPGLE) | Used by | Order inquiry program |

---

## Processing Considerations

- **Journaling:** N/A (display file)
- **Authority:** *PUBLIC *USE
- **CCSID:** N/A
- **Record Length:** N/A

---

## Open Questions / TBD

| # | Section | Question |
|---|---------|----------|
| — | — | None |

---

## Spec Summary

- **Spec Level:** L3
- **Change Type:** New File
- **File Type:** DSPF
- **Total Record Formats:** 3
- **Total Fields:** 16
- **Total Key Fields:** 0
- **Total Business Rules:** 2
- **Total Open Questions:** 0
