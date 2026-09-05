## Program Spec Header

- **Document ID:** PS-20260409-05
- **Change Type:** Enhancement
- **Program Type:** Batch RPGLE

---

## Change Summary

Validate item status before writing shipment request rows.

---

## File Usage

| File Name | Type | Access Pattern | Description |
|-----------|------|----------------|-------------|
| ITEMMAST | I | CHAIN | Item master |
| SHIPREQ | O | WRITE | Shipment request output |

---

## Main Logic

1. Read `ITEMMAST` by item number.
2. If item status is `A`, write shipment request.
3. If item status is not `A`, return error code `8`.

---

## Test Scenarios

1. Active item creates one shipment request row.
2. Inactive item does not create a row and returns code `8`.
