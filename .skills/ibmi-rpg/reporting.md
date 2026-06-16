\# REPORTING ENGINE RULES



\## FLOW



DB2 → SQLRPGLE → SERVICE → PRTF → SPOOL



\## RULES



\- SQL only in repo layer

\- formatting only in service layer

- printing only via PRTF



## LOGIC PATTERNS

### Overflow & First Record Handling
Standard pattern for report generation:
```rpgle
if firstRecord or *inof;
   write HEADER;
   write COLUMNS;
   *inof = *off;
   firstRecord = *off;
endif;

write DETAIL;
```

## PERFECT HEADER ALIGNMENT (132 Columns)

To ensure consistency across all enterprise reports, the following absolute positions MUST be used:

- **Report Title**: Column 2
- **System Date (DATE)**: Column 100
- **System Time (TIME)**: Column 118
- **Page Number (PAGNBR)**: Column 128

### DDS Template for Header
```dds
A          R HEADER
A                                      SKIPB(001)
A                                     2'REPORT TITLE'
A                                   100DATE
A                                      EDTCDE(Y)
A                                   118TIME
A                                   128'PAGE'
A                                   133PAGNBR
A                                      EDTCDE(Z)
```

## PAGINATION




\- must be handled in service layer

\- not in SQL

