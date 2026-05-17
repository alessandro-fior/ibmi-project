**free
ctl-opt main(CusRepo) option(*nodebugio : *srcstmt);

/copy qrpglesrc/customer_h.rpgleinc

dcl-proc CusRepo;
  dcl-pi *n;
    inAction char(10) const;
    ioCustomer likeds(Customer_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  outSuccess = *on;
  outErrorMsg = '';

  select;
    when inAction = 'GET';
      getCustomer(ioCustomer : outSuccess : outErrorMsg);
    when inAction = 'CREATE';
      createCustomer(ioCustomer : outSuccess : outErrorMsg);
    other;
      outSuccess = *off;
      outErrorMsg = 'Invalid Action: ' + inAction;
  endsl;

end-proc;

dcl-proc getCustomer;
  dcl-pi *n;
    ioCustomer likeds(Customer_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  exec sql
    select name, email, status
    into :ioCustomer.name, :ioCustomer.email, :ioCustomer.status
    from CUSTOMER
    where id = :ioCustomer.id;

  if sqlcode <> 0;
    outSuccess = *off;
    outErrorMsg = 'Customer not found or SQL Error: ' + %char(sqlcode);
  endif;
end-proc;

dcl-proc createCustomer;
  dcl-pi *n;
    ioCustomer likeds(Customer_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  exec sql
    insert into CUSTOMER (name, email, status)
    values (:ioCustomer.name, :ioCustomer.email, :ioCustomer.status);

  if sqlcode <> 0;
    outSuccess = *off;
    outErrorMsg = 'Insert failed. SQLCODE: ' + %char(sqlcode);
  else;
    exec sql values identity_val_local() into :ioCustomer.id;
  endif;
end-proc;
