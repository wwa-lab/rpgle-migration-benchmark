# Example: Simple LF DDS (Rekey + Select/Omit)

Active customers keyed by name. Based on CUSTMAST, select only ACTSTS = 'A'.

## Output — DDS Source

```dds
                                      TEXT('Active customers by name')
     A          R CUSTR                PFILE(CUSTMAST)
     A          K CUSTNM
     A          S ACTSTS                       COMP(EQ 'A')
```

**Notes:**
- No field lines — `allIncluded` mode inherits all from CUSTMAST
- PFILE on R line links to physical file
- Non-unique key (multiple customers can share a name)
- S line selects only active records
