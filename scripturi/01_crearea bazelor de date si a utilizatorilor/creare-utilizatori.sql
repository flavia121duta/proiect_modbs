-- in schema SYS_HOMEDB1

--conectare ca sys 
--definire role  
create role sgbd_role; 

--atribuire privilegii si role-uri noului role 
grant connect to sgbd_role; 
grant resource to sgbd_role; 
grant create table to sgbd_role; 
grant create view to sgbd_role; 
grant create materialized view to sgbd_role; 
grant create synonym to sgbd_role; 
grant create procedure to sgbd_role; 
grant create sequence to sgbd_role; 
grant create trigger to sgbd_role; 
grant create type to sgbd_role; 
grant query rewrite to sgbd_role; 
grant select_catalog_role to sgbd_role; 
grant alter session to sgbd_role; 
grant select any dictionary to sgbd_role; 
grant create public database link to sgbd_role; 
grant create public synonym to sgbd_role;
/
create user user_all identified by Admin#DB1 
profile default  
default tablespace users  
quota unlimited on users  
account unlock; 

--atribuire role nou definit utilizatorului 
grant sgbd_role to user_all; 

--atribuire privilegiu unlimited tablespace utilizatorului 
grant unlimited tablespace to user_all;
/
create user user_bd identified by Admin#DB1 
profile default  
default tablespace users  
quota unlimited on users  
account unlock; 

--atribuire role nou definit utilizatorului 
grant sgbd_role to user_bd; 

--atribuire privilegiu unlimited tablespace utilizatorului 
grant unlimited tablespace to user_bd;


--------------------------------------------------


-- in schema SYS_HOMEDB2

--conectare ca sys 
--definire role  
create role sgbd_role; 
--atribuire privilegii si role-uri noului role 
grant connect to sgbd_role; 
grant resource to sgbd_role; 
grant create table to sgbd_role; 
grant create view to sgbd_role; 
grant create materialized view to sgbd_role; 
grant create synonym to sgbd_role; 
grant create procedure to sgbd_role; 
grant create sequence to sgbd_role; 
grant create trigger to sgbd_role; 
grant create type to sgbd_role; 
grant query rewrite to sgbd_role; 
grant select_catalog_role to sgbd_role; 
grant alter session to sgbd_role; 
grant select any dictionary to sgbd_role; 
grant create public database link to sgbd_role; 
grant create public synonym to sgbd_role;
/
create user user_bd identified by Admin#DB1 
profile default  
default tablespace users  
quota unlimited on users  
account unlock; 
--atribuire role nou definit utilizatorului 
grant sgbd_role to user_bd; 
--atribuire privilegiu unlimited tablespace utilizatorului 
grant unlimited tablespace to user_bd;