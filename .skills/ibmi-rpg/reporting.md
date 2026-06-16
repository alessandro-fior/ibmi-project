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

   *inof = *off;

endif;



write DETAIL;

```



## PAGINATION



\- must be handled in service layer

\- not in SQL

