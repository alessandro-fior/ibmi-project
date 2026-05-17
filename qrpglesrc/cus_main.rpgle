**free
ctl-opt dftactgrp(*no) actgrp(*new);

/copy qrpglesrc/customer_h.rpgleinc

dcl-pr CusServ extpgm('CUSSERV');
  action char(10) const;
  customer likeds(Customer_t);
  success ind;
  errorMsg varchar(100);
end-pr;

dcl-ds myCustomer likeds(Customer_t);
dcl-s success ind;
dcl-s errorMsg varchar(100);

// Set up new customer data
myCustomer.name = 'John Doe';
myCustomer.email = 'john.doe@example.com';

// Call Application Layer (Service)
CusServ('REGISTER' : myCustomer : success : errorMsg);

if success;
  // In a real app, maybe send a success message to UI
  snd-msg 'Customer registered successfully';
else;
  // Handle error
  snd-msg ('Registration failed: ' + errorMsg);
endif;

*inlr = *on;
