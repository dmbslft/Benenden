create or replace package process_payment as 

/*
Description:

High level description of this package.


History
--------

Version Who             Notes
------- --------------- --------------------------------------------------------
     1  Simon Clarke    Competency test for Benenden.
*/

 /*
 Select all member payments that are due:
    1. record a payment record
    2. update next payment date to 1 year.
 */
 procedure record_payment;

end process_payment;