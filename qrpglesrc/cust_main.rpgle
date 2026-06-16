**free
// BUILD: CRTBNDRPG PGM(MYLIB/CUST_MAIN) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NODEBUGIO)
// RUN: CALL PGM(MYLIB/CUST_MAIN)
// DEPENDS: qrpglesrc/cust_report_serv.rpgle
// NOTES: Main entry point for Customer Report

ctl-opt option(*nodebugio : *srcstmt : *nounref) datedit(*ymd) main(main);

/copy qrpglesrc/cust_report_serv.rpgle

dcl-proc main;
  dcl-pi *n;
  end-pi;

  run_customer_report('Monthly Customer Summary');

  return;
end-proc;
