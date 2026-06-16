**free
// BUILD: CRTBNDRPG PGM(MYLIB/CUST_R_SERV) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NODEBUGIO)
// RUN: -
// DEPENDS: qrpglesrc/cust_repo.sqlrpgle
// NOTES: Report service layer for Customers

ctl-opt option(*nodebugio : *srcstmt : *nounref) datedit(*ymd);

dcl-f cust_rpt prtf usage(*output) overflowind(*inof);

/copy qrpglesrc/cust_repo.sqlrpgle

dcl-proc run_customer_report export;
  dcl-pi *n;
    inTitle  char(30);
  end-pi;

  dcl-ds customers likeds(t_customer) dim(100);
  dcl-s count int(10);
  dcl-s success ind;
  dcl-s i int(10);
  dcl-s firstRecord ind inz(*on);

  get_customers(customers : count : success);

  if not success or count = 0;
    return;
  endif;

  for i = 1 to count;
    // Standard Report Logic Pattern
    if firstRecord or *inof;
       TITLE = inTitle;
       write HEADER;
       write COLUMNS;
       *inof = *off;
       firstRecord = *off;
    endif;

    CUSTID = customers(i).id;
    CUSTNAME = customers(i).name;
    CUSTBAL = customers(i).balance;
    write DETAIL;
  endfor;

  write FOOTER;
  close cust_rpt;

end-proc;
