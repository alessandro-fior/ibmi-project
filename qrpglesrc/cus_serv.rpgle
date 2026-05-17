**free
ctl-opt main(CusServ) option(*nodebugio : *srcstmt);

/copy qrpglesrc/customer_h.rpgleinc

dcl-pr CusRepo extpgm('CUSREPO');
  action char(10) const;
  customer likeds(Customer_t);
  success ind;
  errorMsg varchar(100);
end-pr;

dcl-proc CusServ;
  dcl-pi *n;
    inAction char(10) const;
    ioCustomer likeds(Customer_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  outSuccess = *on;
  outErrorMsg = '';

  select;
    when inAction = 'REGISTER';
      registerCustomer(ioCustomer : outSuccess : outErrorMsg);
    other;
      outSuccess = *off;
      outErrorMsg = 'Invalid Service Action: ' + inAction;
  endsl;

end-proc;

dcl-proc registerCustomer;
  dcl-pi *n;
    ioCustomer likeds(Customer_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  // Business Validation
  if ioCustomer.name = '';
    outSuccess = *off;
    outErrorMsg = 'Customer name is required.';
    return;
  endif;

  if not %scan('@' : ioCustomer.email) > 0;
    outSuccess = *off;
    outErrorMsg = 'Invalid email address.';
    return;
  endif;

  ioCustomer.status = STATUS_ACTIVE;

  // Call Infrastructure Layer
  CusRepo('CREATE' : ioCustomer : outSuccess : outErrorMsg);

end-proc;
