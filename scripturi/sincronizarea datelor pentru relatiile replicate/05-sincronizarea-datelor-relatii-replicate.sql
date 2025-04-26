-- RAPORTUL DE BACKEND

-- asigurarea sincronizarii datelor pentru relatiile replicate:
-- PRODUS, MATERIE_PRIMA, PRODUS_MATERIE_PRIMA

create table produs as select * from produs_provincie@bd_provincie; 

alter table produs add primary key (id_produs);

CREATE MATERIALIZED VIEW LOG ON produs
WITH PRIMARY KEY;

insert into produs (id_produs, denumire, dimensiune, unitate_masura, pret, activ)
values (256, 'Cappuccino', 'mic', 'ml', 16.5, 1);

commit;

select * from produs order by id_produs desc;

-- ar trebui sa astept o zi ca sa pot vedea tranzactia
select * from mv_produse_provincie@bd_provincie order by id_produs desc;

-- dar pentru ca timpul inseamna bani
-- fac manual operatia de refresh in coffee_project_bdd_provincie

-- si acum pot sa vad imediat modificarea
select * from mv_produse_provincie@bd_provincie order by id_produs desc;

-- analog voi procesa si pentru celelalte tabele: MATERIE_PRIMA, PRODUS_MATERIE_PRIMA


