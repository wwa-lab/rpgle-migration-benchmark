# Maintained Source Style Profile

When generating fixed-format RPGLE for an existing codebase, the generated source should read
like a maintained member — not a technically correct draft that looks alien to the shop.

This reference defines what to extract from a reference source member and apply to generated code.

---

## What to Extract from Reference Source

When a reference source member is provided (e.g., `CUR41.rpgle`), extract these style elements:

### Header / Banner Style
- Program header comment block (box style, content pattern, line length)
- Modification history format (date, author, description layout)
- Copyright or shop-standard notice if present

### Structural Comments
- Section separator style (e.g., `C*===`, `C*---`, `C*****`):
  - Extract the **exact character** used for the separator line and its **length**
  - Note whether the title line sits **between** two separator lines or **below** one
    (this layout detail is applied in change blocks; full-member output always uses the
    separator + title + separator minimum from SKILL.md)
  - Note the **section header vocabulary** (e.g., "Entry parameters" vs "Entry Parms" vs
    "Input Parameters"; "Main Line" vs "Mainline" vs "Main Processing")
- Subroutine header comment pattern (box vs inline, what fields are listed)
- File declaration comment pattern (purpose annotation style)
- Data structure purpose comments
- Blank-line spacing pattern:
  - Note whether the reference source uses **blank lines between sections** (one blank line,
    two blank lines, or none)
  - If the shop style is dense (no spacing), record that so the generator does not force
    spacing that looks alien

### Naming Conventions
- Constant naming pattern (e.g., `C_MAXRSP`, `#MAXRSP`, `MAXRSP`)
- Work field naming pattern (e.g., `wkField`, `W_FIELD`, `WKFIELD`)
- Data structure member naming (e.g., `DS_CUST`, `CUSTDS`, `dsCust`)
- Key list naming (e.g., `KYORDR`, `KY_ORDR`, `KORDR`)
- Subroutine naming pattern (e.g., `SR100`, `SR200`, `SR980` — numbered pattern;
  or `SRVALID`, `SRUPDT` — descriptive pattern; or `SR_VALID`, `SR_UPD` — underscored)
- Error/cleanup subroutine convention (e.g., high-numbered `SR980`, `SR990` vs named
  `*PSSR`, `SRERR`)
- Loop counter naming (e.g., `X`, `IDX`, `I`, `wkIdx`)
- Response-building field naming (e.g., `RSPTEXT`, `RSP_TXT`, `wkRsp`)

### Inline Descriptions
- Whether D-spec fields carry inline comments (column 40+ descriptions)
- Whether constants have purpose annotations
- Whether key fields have access-pattern annotations
- Standard description vocabulary (e.g., "Work field for...", "Loop counter", "Response buffer")

### Error Handling Idiom
- MONMSG scope pattern (global vs per-command)
- Error indicator usage pattern
- Return code variable naming
- Error subroutine naming (e.g., `SR_ERROR`, `*PSSR`, `SRPERR`)

---

## How to Apply in Generated Code

When generating fixed-format RPGLE with a reference source available:

1. **Match the header** — use the same box style, field layout, and modification history format
2. **Match banner structure** — what to extract from the reference and how to apply it
   depends on the output type:
   - For **change blocks**: reproduce the reference source's banner pattern exactly,
     including alternate layouts (e.g., title below one separator). If the reference has
     no banners, match the dense style — do not inject banners.
   - For **full-member / full-revised-member** output: the structural minimum from SKILL.md
     (separator line + title line + separator line) is the floor. The reference source
     controls the **separator character** (e.g., `*` vs `=` vs `-`), the **line length**,
     and the **section header vocabulary** (e.g., "Entry parameters" vs "Entry Parms"),
     but the three-line structure (separator + title + separator) is always required — even
     if the reference uses a sparser layout or has no banners at all.
3. **Match spacing** — if the reference source uses blank lines between sections, reproduce
   that spacing in generated code. If the reference has no blank-line spacing (dense style):
   - For **change blocks**: match the dense style — do not force spacing that looks alien
   - For **full-member / full-revised-member** output: SKILL.md's readability floor takes
     precedence — apply the minimum blank-line spacing defined there even if the reference
     source is dense (the readability rules exist because dense output was rejected in pilot)
4. **Match naming** — adopt the reference's naming conventions for new constants, work fields,
   data structures, key lists, subroutines, and loop counters. For subroutines specifically:
   if the reference uses numbered names (SR100, SR200, SR980), continue the numbering sequence
   for new subroutines. If it uses descriptive names, follow that pattern
5. **Match inline descriptions** — if the reference uses D-spec inline comments, add them to
   generated declarations in the same style
6. **Match error handling** — if the reference uses a specific MONMSG/error pattern, follow it

When generating without a reference source:
- Use clean, neutral fixed-format conventions
- Do not invent a shop-specific style
- For **full-member / full-revised-member** output: produce banner separators and blank-line
  spacing using the defaults defined in SKILL.md (the readability floor) — never produce a
  flat wall of C-specs for full-member output
- For **change blocks**: keep the block minimal and neutral — do not add banners or spacing
  unless the block contains a complete new subroutine (per SKILL.md scope rules)
- Add a `TODO` comment suggesting the developer align the style with existing members

---

## What NOT to Extract

- Business logic (belongs in the Program Spec)
- File names or field names (belong in the spec's Data Contract / File Usage)
- Return codes or error categories (belong in the spec's Error Handling)
- Interface parameters (belong in the spec's Interface Contract)

Style is about **how the code looks**. Structure is about **what the code does**.
This profile covers style only.
