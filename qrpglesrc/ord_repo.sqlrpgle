**free
ctl-opt main(OrdRepo) option(*nodebugio : *srcstmt);

/copy qrpglesrc/order_h.rpgleinc

dcl-proc OrdRepo;
  dcl-pi *n;
    inAction char(10) const;
    ioOrder likeds(Order_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  outSuccess = *on;
  outErrorMsg = '';

  select;
    when inAction = 'CREATE';
      createOrder(ioOrder : outSuccess : outErrorMsg);
    other;
      outSuccess = *off;
      outErrorMsg = 'Invalid Action: ' + inAction;
  endsl;

end-proc;

dcl-proc createOrder;
  dcl-pi *n;
    ioOrder likeds(Order_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  exec sql
    insert into ORDERS (CUSTOMER_ID, ORDER_DATE, TOTAL_AMOUNT, STATUS)
    values (:ioOrder.customerId, :ioOrder.orderDate, :ioOrder.totalAmount, :ioOrder.status);

  if sqlcode <> 0;
    outSuccess = *off;
    outErrorMsg = 'Order creation failed. SQLCODE: ' + %char(sqlcode);
  else;
    exec sql values identity_val_local() into :ioOrder.id;
  endif;
end-proc;
