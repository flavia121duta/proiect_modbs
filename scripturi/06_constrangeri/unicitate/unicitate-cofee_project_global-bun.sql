-- RAPORTUL DE ANALIZA

-- ex. 8 a) i.
-- unicitate locala
-- ma conectez la coffee_project_bdd_global

-- aplic constrangerea de unicitate locala pentru 
-- coloana email din tabela replicata CLIENT
alter table client
add constraint u_email_client unique (email);
/
-- aplic constrangerea de unicitate locala pentru 
-- combinatia de coloane (denumire_dimenziune) din tabela replicata PRODUS
alter table produs
add constraint u_produs_denumire_dimensiune unique(denumire, dimensiune);
/
-- aplic constrangerea de unicitate locala pentru 
-- coloana nume_materie din tabela replicata MATERIE_PRIMA
alter table materie_prima
add constraint u_materie_prima_nume_materie unique(nume_materie);
/
-- ex. 8 a) iii.
-- testez trigger-ul din coffee_project_bucuresti
select * from angajat;
/
insert into angajat(id_angajat, salariu, data_angajarii)
values (1001, 4500, '25-APR-2025');
/
insert into angajat(id_angajat, salariu, data_angajarii)
values (1002, 4500, '25-APR-2025');
/
commit;
/
select * from angajat;
/
-- teste trigger-ul din coffee_project_provincie
insert into angajat(id_angajat, salariu, data_angajarii)
values (1003, 5000, '25-APR-2025');
/
insert into angajat(id_angajat, salariu, data_angajarii)
values (1004, 5000, '25-APR-2025');
/
commit;
/