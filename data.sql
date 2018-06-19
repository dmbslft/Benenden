delete from  "MEMBER";
REM INSERTING into MEMBER
SET DEFINE OFF;
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (1,'mercury','ury');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (2,'venus','nus');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (33,'terra','firma');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (4,'red','planet');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (5,'jupiter','iter');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (6,'saturn','urn');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (7,'neptune','tune');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (8,'uranus','anus');
Insert into MEMBER (MEMBERSHIP_NUM,FORENAME,SURNAME) values (9,'pluto','planet');

delete from  product;
REM INSERTING into PRODUCT
SET DEFINE OFF;
Insert into PRODUCT (NAME,COST) values ('luna',100);
Insert into PRODUCT (NAME,COST) values ('phobos',1000);
Insert into PRODUCT (NAME,COST) values ('deimos',1010);
Insert into PRODUCT (NAME,COST) values ('europa',10000);
Insert into PRODUCT (NAME,COST) values ('ganymede',10010);
Insert into PRODUCT (NAME,COST) values ('io',10020);
Insert into PRODUCT (NAME,COST) values ('callisto',10030);
Insert into PRODUCT (NAME,COST) values ('megaclite',10040);
Insert into PRODUCT (NAME,COST) values ('titan',100000);
Insert into PRODUCT (NAME,COST) values ('enceladus',100010);
Insert into PRODUCT (NAME,COST) values ('mimas',100020);
Insert into PRODUCT (NAME,COST) values ('rhea',100030);
Insert into PRODUCT (NAME,COST) values ('pandora',100040);
Insert into PRODUCT (NAME,COST) values ('triton',1000000);
Insert into PRODUCT (NAME,COST) values ('miranda',10000000);
Insert into PRODUCT (NAME,COST) values ('oberon',10000010);


truncate table member_product;
REM INSERTING into MEMBER_PRODUCT
SET DEFINE OFF;
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (33,'luna',to_date('07-JUN-18','DD-MON-RR'));
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (4,'phobos',to_date('08-MAY-18','DD-MON-RR'));
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (4,'deimos',to_date('20-JUN-18','DD-MON-RR'));
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (5,'io',to_date('19-JUN-18','DD-MON-RR'));
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (5,'europa',to_date('19-JUN-18','DD-MON-RR'));
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (5,'callisto',to_date('19-JUN-18','DD-MON-RR'));
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (6,'titan',to_date('14-JUN-13','DD-MON-RR'));
Insert into MEMBER_PRODUCT (MEMBERSHIP_NUM,PRODUCT_NAME,NEXT_PAYMENT_DATE) values (6,'enceladus',to_date('19-JUN-18','DD-MON-RR'));
