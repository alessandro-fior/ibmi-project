\# SERVICE ARCHITECTURE



\## LAYERS



\- \*\_repo → DB2 access only

\- \*\_serv → business logic only

\- \*\_main → orchestration only



\## RULE



NO cross-layer logic allowed



\## INVALID



SQL in \*\_serv



\## VALID



SQL only in \*\_repo

serv calls repo

main calls serv

