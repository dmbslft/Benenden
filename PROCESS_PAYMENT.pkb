create or replace package body process_payment as


  procedure   log (pv_source in varchar2, pv_text in varchar2 ) as 
  
   pragma autonomous_transaction;
   
   rec_logger logger%rowtype;
   
  begin
    
    -- save to database table. could be written to a file.
  
    rec_logger.log_date := systimestamp;
    rec_logger.source := substr('PROCESS_PAYMENT.'||pv_source, 1, 100);
    rec_logger.text := substr(pv_text, 1, 500);
    
    insert into "LOGGER" values rec_logger;
    commit;
    
  end log;
  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */


  procedure record_payment as
  
   type varchar_t is table of varchar2(100) index by pls_integer;
   type number_t is table of number index by pls_integer;
   type date_t is table of date index by pls_integer;

   c_today constant date := trunc(sysdate);
   
   cursor cur_member_product_due is
     select mp.membership_num, mp.product_name, mp.next_payment_date, p.cost  
     from member_product mp,
          product p
     where mp.next_payment_date <= c_today
     and mp.product_name = p.name;
   
   l_membership_num number_t;
   l_product_name varchar_t;
   l_payment_date date_t;
   l_amount number_t;
   l_error_indx number_t;

   c_limit constant pls_integer :=  100;  -- looping limiter.  should be a defined by parameter stored in a table.
   
   v_start_time timestamp with local time zone; 
   v_insert_errors pls_integer := 0;
   v_update_errors pls_integer :=0;
   v_num_records_processed pls_integer := 0;
   
  begin
     /*
     Select all member payments that are due:
        1. record a payment record
        2. update next payment date to 1 year.
        
        log errors and results to persistent file/table.
        committ
     */
     begin
     v_start_time := systimestamp;
     
     
     open cur_member_product_due;
     <<get_data>>
     loop
    
       fetch cur_member_product_due 
       bulk collect into l_membership_num, l_product_name, l_payment_date, l_amount
       limit c_limit;
       
       log( pv_source => 'process_payment.record_payment.insert payment',
                    pv_text =>  'Records: '|| l_membership_num.count
                   );
       v_num_records_processed := v_num_records_processed + l_membership_num.count;
       
       exit when l_membership_num.count = 0;
       
       -- reset variables before processing.
       l_error_indx.delete;
       
       
       <<insert_payments>>
       begin
         forall indx in 1..l_membership_num.count save exceptions
         insert into payment ( membership_num, product_name, payment_date, amount)
           values ( l_membership_num(indx), l_product_name(indx), c_today, l_amount(indx) );
       
       exception
         when others then
         
           -- if bulk processing errors, then..
           if sqlcode = -24381 then 
             for indx in 1..SQL%BULK_EXCEPTIONS.COUNT loop
                             
               -- log the "insert" error as JSON record.  -- can use JSON query later to process log errors.
               log( pv_source => 'process_payment.record_payment.insert payment',
                    pv_text =>  '{ "membership_num" : "'|| l_membership_num(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)||'", '
                               ||' "product_name" : "'|| l_product_name(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)||'", ' 
                               ||' "next_payment_date" : "'||l_payment_date(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)||'", '
                               ||' "error_code" : "'|| SQL%BULK_EXCEPTIONS (indx).ERROR_CODE||'" }'
                   );
               
               -- mark indices for delete; .  
               l_membership_num(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX) := null;
             end loop;
             
             v_insert_errors := v_insert_errors + SQL%BULK_EXCEPTIONS.COUNT;
           else
          
             raise;
           end if;
       end;  -- End of insert block.


       <<update_next_payment>>
       begin
       --  delete null value indices, as identified above.
         for indx in 1..l_membership_num.count loop
           if l_membership_num(indx) is null then 
             l_membership_num.delete(indx);
             l_product_name.delete(indx);
             l_payment_date.delete(indx);
           end if;
         end loop;
       end;
       
       begin 
         forall indx in INDICES of l_membership_num
           update member_product 
           set next_payment_date = add_months(next_payment_date, 12)
           where membership_num = l_membership_num(indx)
           and product_name = l_product_name(indx);

       exception
         when others then
         
           -- if bulk processing errors, then..
           if sqlcode = -24381 then 
             for indx in 1..SQL%BULK_EXCEPTIONS.COUNT loop
                             
               -- log the "insert" error as JSON record.  -- can use JSON query later to process log errors.
               log( pv_source => 'process_payment.record_payment.update payment',
                    pv_text =>  '{ "membership_num" : "'|| l_membership_num(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)||'", '
                               ||' "product_name" : "'|| l_product_name(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)||'", ' 
                               ||' "next_payment_date" : "'||l_payment_date(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)||'", '
                               ||' "error_code" : "'|| SQL%BULK_EXCEPTIONS (indx).ERROR_CODE||'" }'
                   );
               
             end loop;
             v_update_errors := v_update_errors + SQL%BULK_EXCEPTIONS.COUNT;
           else
             raise;
           end if;
        
       end;
     end loop;
    end;
    
    <<commit_data>>
    commit;
    
    log( pv_source => 'process_payment.record_payment.payment stats',
         pv_text =>  '{ "execution_time" : "'|| to_char(systimestamp - v_start_time,'HH24:MI:SSFX') 
                   ||'", "insert_errors" : "'|| to_char(v_insert_errors) 
                   ||'", "update_errors" : "'|| to_char(v_update_errors)
                   ||'", "records_retrieved" : "'||to_char(v_num_records_processed)
                   ||'"  }'
       );
    
    
  end record_payment;

end process_payment;