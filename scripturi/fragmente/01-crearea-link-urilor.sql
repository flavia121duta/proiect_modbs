-- sterge link-urile daca exista

-- in bd_bucuresti sterg link-urile
drop public database link bd_all;
drop public database link bd_provincie;

-- -- in bd_provincie sterg link-urile
drop public database link bd_all;
drop public database link bd_bucuresti;

/

-- in bd_bucuresti creez urmatoarele link-uri:
CREATE PUBLIC DATABASE LINK bd_provincie
  CONNECT TO user_bd
  IDENTIFIED BY Admin#DB1
USING '(DESCRIPTION=
            (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
            (CONNECT_DATA=(SERVICE_NAME=homedb2))
          )';

CREATE PUBLIC DATABASE LINK bd_all
  CONNECT TO user_all
  IDENTIFIED BY Admin#DB1
USING '(DESCRIPTION=
            (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
            (CONNECT_DATA=(SERVICE_NAME=homedb1))
          )';
/

-- in bd_provincie creez urmatoarele link-uri:
CREATE PUBLIC DATABASE LINK bd_bucuresti
  CONNECT TO user_bd
  IDENTIFIED BY Admin#DB1
USING '(DESCRIPTION=
            (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
            (CONNECT_DATA=(SERVICE_NAME=homedb1))
          )';

CREATE PUBLIC DATABASE LINK bd_all
  CONNECT TO user_all
  IDENTIFIED BY Admin#DB1
USING '(DESCRIPTION=
            (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
            (CONNECT_DATA=(SERVICE_NAME=homedb1))
          )';

/
SELECT table_name FROM user_tables@bd_eu;
/
SELECT table_name FROM user_tables@bd_am;