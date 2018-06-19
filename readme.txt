PLSQL Competency test by 

Simon Clarke, 5 Merton Road, CH65 1AP.

For Benenden:

To install the PLSQL, unzip  content into a folder. 
from that folder open sqlplus or SQL Developer and run the intall.sql script.

The install script  is set to use the Scott/Tiger login.

I have included some test data (not asked for), to test the payment process.

All table, indexes and constraints (metadata) is located in the DDL.sql.
Test data in the data.sql. Finally two package scripts; I seperated the package header from the body.



Assumptions:

1. I've used basic oracle types for the storage of text (500 or 100 chars), 
 and stick to the number type for currency.

2. Having worked on transaction and data movement, using bulk collect and FORALL is my favoutite approach.
  In an interview, I would probably use a Cursor For..Loop approach, as it is easier to explain.

3. There is one comparisson (query) in the code working on MEMBER_PRODUCT.next_payment_date.
  I needed an index on next_payment_date to stop a full table scan.

4. Next payment date is calculated as add_months( next_payment_date, 12). One of the test records 
 uses a next_payment_date of 14-Jun-13. This record would re-enter the procedure until the next payment 
 date is greater that today. I believe the rules should be adjustedto say next_payment_date = one year from today.
 
end.