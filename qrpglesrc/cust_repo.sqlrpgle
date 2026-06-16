**free
// BUILD: CRTSQLRPGI OBJ(MYLIB/CUST_REPO) SRCFILE(MYLIB/QRPGLESRC) COMMIT(*NONE) OPTION(*NODEBUGIO)
// RUN: -
// DEPENDS: -
// NOTES: Data access layer for Customers

ctl-opt option(*nodebugio : *srcstmt : *nounref) datedit(*ymd);

dcl-ds t_customer qualified template;
  id       int(10);
  name     varchar(40);
  balance  packed(12:2);
end-ds;

dcl-proc get_customers export;
  dcl-pi *n;
    outCustomers  likeds(t_customer) dim(100);
    outCount      int(10);
    outSuccess    ind;
  end-pi;

  outSuccess = *on;
  outCount = 0;

  monitor;
    exec sql
      declare c1 cursor for
      select ID, NAME, BALANCE
      from PRODDB.CUSTOMERS
      order by NAME;

    exec sql open c1;

    if sqlcode <> 0;
      outSuccess = *off;
      return;
    endif;

    exec sql fetch c1 bulk collect into :outCustomers;
    outCount = sqlerp; // sqlerp is often used for count in some environments, but sqlerrd(3) is safer

    exec sql close c1;
  on-error;
    outSuccess = *off;
  endmon;

end-proc;
