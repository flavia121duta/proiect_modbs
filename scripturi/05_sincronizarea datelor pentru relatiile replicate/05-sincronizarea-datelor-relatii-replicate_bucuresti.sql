-- in coffee_project_bdd_bucuresti creez un link catre nodul globala

CREATE PUBLIC DATABASE LINK bd_global
  CONNECT TO user_global
  IDENTIFIED BY Admin#DB1
USING '(DESCRIPTION=
            (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
            (CONNECT_DATA=(SERVICE_NAME=homedb1))
          )';
/

-- ma asigur ca link-ul functioneaza
select * from produs@bd_global;

/

-- relatia replicata: PRODUS_MATERIE_PRIMA

CREATE MATERIALIZED VIEW mv_produs_bucuresti
    refresh fast
    start with sysdate
    next sysdate+1
    with primary key
as
select * from produs@bd_global;
/
----------------------------------------------------

-- relatia replicata: MATERIE_PRIMA
CREATE MATERIALIZED VIEW mv_materie_prima_bucuresti
    refresh fast
    start with sysdate
    next sysdate+1
    with primary key
as
select * from materie_prima@bd_global;
/
----------------------------------------------------

-- relatia replicata: PRODUS_MATERIE_PRIMA
CREATE MATERIALIZED VIEW mv_produs_materie_prima_bucuresti
  REFRESH FAST
  ON DEMAND
  WITH PRIMARY KEY
AS
  SELECT * FROM produs_materie_prima@bd_global;

/

-- sterg tabelele temporare create inainte a face vizualizari materializate
drop table produs_bucuresti;
drop table materie_prima_bucuresti;
drop table produs_materie_prima_bucuresti;