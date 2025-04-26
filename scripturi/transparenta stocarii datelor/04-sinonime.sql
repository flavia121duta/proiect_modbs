-- RAPORT BACKEND

-- ex. 4 c)

-- creez un link prin care vrea sa accesez mai usor
-- tabelele din schema coffee_project_bdd_bucuresti
CREATE PUBLIC DATABASE LINK bd_bucuresti
  CONNECT TO user_bd
  IDENTIFIED BY Admin#DB1
USING '(DESCRIPTION=
            (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
            (CONNECT_DATA=(SERVICE_NAME=homedb1))
          )';
/
-- creez un sinonim pentru fragmentul ANGAJAT_BUCURESTI din coffee_project_bdd_bucuresti
create or replace synonym angajati_bucuresti
for angajat_bucuresti@bd_bucuresti;

-- creez un sinonim pentru fragmentul ANGAJAT_provincie din coffee_project_bdd_provincie
create or replace synonym angajati_provincie
for angajat_provinie@bd_provincie;
/
-- afisez toti angajatii din Bucuresti folosing sinonimul
select * from angajati_bucuresti;

-- afisez toti angajatii din provincie folosing sinonimul
select * from angajat_provincie@bd_provincie;
/
