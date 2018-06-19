/*
Install script for Benenden PLSQL competency test:

by Simon Clarke

unzip  contents into folder:

Run install.sql  in SQLPlus or SQL developer

*/

connect scott/tiger;

-- load  Metadata
@DDL.sql

-- Load data
@DATA.sql

-- Load source
@PROCESS_PAYMENT.pks
@PROCESS_PAYMENT.pkb


-- Run Test:
begin
  process_payment.record_payment;
end;

select * from logger order by log_date desc;
/* look at the JSON record (last record) for Stats on the run.*/