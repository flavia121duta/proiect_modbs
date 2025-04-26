CREATE MATERIALIZED VIEW mv_produse_provincie
    refresh fast
    start with sysdate
    next sysdate+1
    with primary key
as
select * from produs@bd_global;

EXECUTE DBMS_MVIEW.REFRESH(UPPER('mv_produse_provincie'),'F');