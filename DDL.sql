
drop table product cascade constraints;
create table product (
"NAME" varchar2(100) not null,
"COST" number not null
);

comment on column "PRODUCT"."NAME" is 'unique name  - primary key';
comment on column "PRODUCT"."COST" is 'cost (stored in pence) ';

alter table "PRODUCT" add constraint PK_PRODUCT primary key ( "NAME");

drop table "MEMBER" cascade constraints;
create table "MEMBER" (
"MEMBERSHIP_NUM" number not null,
forename varchar2(100) not null,
surname varchar2(100) not null
);

comment on column "MEMBER"."MEMBERSHIP_NUM" is 'Unique membership number - primary key ';
comment on column "MEMBER".forename is 'First name ';
comment on column "MEMBER".surname is 'Family name';

alter table "MEMBER" add constraint PK_MEMBER primary key ( "MEMBERSHIP_NUM");

drop table "MEMBER_PRODUCT" cascade constraints;
create table "MEMBER_PRODUCT" (
"MEMBERSHIP_NUM" number not null,
"PRODUCT_NAME" varchar2(100) not null,
"NEXT_PAYMENT_DATE" date default sysdate
);

comment on column "MEMBER_PRODUCT"."MEMBERSHIP_NUM" is 'ref to Member.membership_num';
comment on column "MEMBER_PRODUCT"."PRODUCT_NAME" is 'ref to Product.name ';
comment on column "MEMBER_PRODUCT"."NEXT_PAYMENT_DATE" is 'Date of next payment, defualt to today';

alter table "MEMBER_PRODUCT" add constraint PK_MEMBER_PRODUCT primary key("MEMBERSHIP_NUM", "PRODUCT_NAME" );
alter table "MEMBER_PRODUCT" add constraint FK_MEMBER_PRODUCT_MEMBER 
  foreign key ("MEMBERSHIP_NUM") 
  references "MEMBER" ("MEMBERSHIP_NUM")
  on delete cascade;
  
alter table "MEMBER_PRODUCT" add constraint FK_MEMBER_PRODUCT_PRODUCT 
  foreign key ("PRODUCT_NAME") 
  references product ("NAME")
  on delete cascade;

create index "MEMBER_PRODUCT_PAYDATE" on "MEMBER_PRODUCT" ("NEXT_PAYMENT_DATE") ;

drop table "PAYMENT" cascade constraints;  
  
create table "PAYMENT" (
"MEMBERSHIP_NUM" number not null,
"PRODUCT_NAME" varchar2(100) not null,
"PAYMENT_DATE" date not null,
"AMOUNT" number not null
);
  
comment on column "PAYMENT"."MEMBERSHIP_NUM" is 'ref to Member.membership_num';
comment on column "PAYMENT"."PRODUCT_NAME" is 'ref to Product.name';
comment on column "PAYMENT"."PAYMENT_DATE" is 'Date payment was made.';
comment on column "PAYMENT"."AMOUNT" is 'Payment ammount in pence';   -- Assumption ammount is in pence.

alter table   "PAYMENT" 
  add constraint "PK_PAYMENT" 
  primary key ("MEMBERSHIP_NUM", "PRODUCT_NAME", "PAYMENT_DATE");
  
alter table   "PAYMENT" 
  add constraint "FK_PAYMENT_MEMBERSHIP_NUM"
  foreign key ("MEMBERSHIP_NUM")  
  references "MEMBER" ("MEMBERSHIP_NUM")
  on delete cascade;
  
alter table  "PAYMENT" 
  add constraint "FK_PAYMENT_PRODUCT_NAME"
  foreign key ("PRODUCT_NAME")  
  references "PRODUCT" ("NAME")
  on delete cascade;
  
drop table "LOGGER" cascade constraints;
create table "LOGGER" (
"LOG_DATE" timestamp with local time zone default systimestamp,
"SOURCE" varchar2(100),
"TEXT" varchar2(500)
);  
  
