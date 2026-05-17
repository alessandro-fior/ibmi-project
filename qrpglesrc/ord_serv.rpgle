**free
ctl-opt main(OrdServ) option(*nodebugio : *srcstmt);

/copy qrpglesrc/order_h.rpgleinc

dcl-pr OrdRepo extpgm('ORDREPO');
  action char(10) const;
  order likeds(Order_t);
  success ind;
  errorMsg varchar(100);
end-pr;

dcl-proc OrdServ;
  dcl-pi *n;
    inAction char(10) const;
    ioOrder likeds(Order_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  outSuccess = *on;
  outErrorMsg = '';

  select;
    when inAction = 'PLACE_ORDER';
      placeOrder(ioOrder : outSuccess : outErrorMsg);
    other;
      outSuccess = *off;
      outErrorMsg = 'Invalid Service Action: ' + inAction;
  endsl;

end-proc;

dcl-proc placeOrder;
  dcl-pi *n;
    ioOrder likeds(Order_t);
    outSuccess ind;
    outErrorMsg varchar(100);
  end-pi;

  // Business Rules
  if ioOrder.totalAmount <= 0;
    outSuccess = *off;
    outErrorMsg = 'Order total must be greater than zero.';
    return;
  endif;

  ioOrder.orderDate = %date();
  ioOrder.status = ORDER_STATUS_PENDING;

  // Call Infrastructure
  OrdRepo('CREATE' : ioOrder : outSuccess : outErrorMsg);

end-proc;
