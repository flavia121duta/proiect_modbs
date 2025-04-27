-- relatia replicata: PRODUS_MATERIE_PRIMA
-- creez un view materializat "with primary key"
-- care va contine toate datele despre tabela distanta produs din coffee_project_bdd_global

CREATE MATERIALIZED VIEW mv_produs_provincie
    refresh fast
    start with sysdate
    next sysdate+1
    with primary key
as
select * from produs@bd_global;

EXECUTE DBMS_MVIEW.REFRESH(UPPER('mv_produse_provincie'),'F');
/
----------------------------------------------------

-- relatia replicata: MATERIE_PRIMA
CREATE MATERIALIZED VIEW mv_materie_prima_provincie
    refresh fast
    start with sysdate
    next sysdate+1
    with primary key
as
select * from materie_prima@bd_global;

EXECUTE DBMS_MVIEW.REFRESH(UPPER('mv_materie_prima_provincie'),'F');
----------------------------------------------------

-- relatia replicata: PRODUS_MATERIE_PRIMA
-- creez o vizualizare materializata care va contine toate "retetele"
-- din tabela distanta produs_materie_prima@bd_global
CREATE MATERIALIZED VIEW mv_produs_materie_prima_provincie
  REFRESH FAST
  ON DEMAND
  WITH PRIMARY KEY
AS
  SELECT * FROM produs_materie_prima@bd_global;

-- fac manual refreh pe vizualizare
EXECUTE DBMS_MVIEW.REFRESH(UPPER('mv_produs_materie_prima_provincie'),'F');