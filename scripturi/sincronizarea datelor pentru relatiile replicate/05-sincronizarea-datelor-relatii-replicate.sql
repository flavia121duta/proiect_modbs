-- RAPORTUL DE BACKEND

-- ex. 5

-- asigurarea sincronizarii datelor pentru relatiile replicate:
-- PRODUS, MATERIE_PRIMA, PRODUS_MATERIE_PRIMA

-- relatia replicata: PRODUS
create table produs as select * from produs_provincie@bd_provincie;

alter table produs add primary key (id_produs);

CREATE MATERIALIZED VIEW LOG ON produs
WITH PRIMARY KEY;

select * from produs order by id_produs desc;

-- in coffee_project_bdd_provincie creez un view materializat "with primary key"

insert into produs (id_produs, denumire, dimensiune, unitate_masura, pret, activ)
values (256, 'Cappuccino', 'mic', 'ml', 16.5, 1);

commit;

select * from produs order by id_produs desc;

-- ar trebui sa astept o zi ca sa pot vedea tranzactia in vizualizarea distanta
select * from mv_produse_provincie@bd_provincie order by id_produs desc;

-- dar pentru ca timpul inseamna bani
-- fac manual operatia de refresh in coffee_project_bdd_provincie

-- si acum pot sa vad imediat modificarea
select * from mv_produse_provincie@bd_provincie order by id_produs desc;

-- analog voi procesa si pentru celelalte tabele replicate: MATERIE_PRIMA, PRODUS_MATERIE_PRIMA

----------------------------------------------------

-- relatia replicata: MATERIE_PRIMA
create table materie_prima as select * from materie_prima_provincie@bd_provincie;

alter table materie_prima add primary key (id_materie);

CREATE MATERIALIZED VIEW LOG ON materie_prima
WITH PRIMARY KEY;

select * from materie_prima order by id_materie desc;

-- in coffee_project_bdd_provincie creez un view materializat "with primary key"
-- care va contine toate datele despre tabela distanta materie_prima din global

-- testez daca vizualizarea creata in coffee_project_bdd_provincie functioneaza

insert into materie_prima (id_materie, nume_materie, unitate_masura)
values (31, 'Cafea Arabica', 'kg');

-- verific ca noua inregistrare apare pe local
select * from materie_prima order by id_materie desc;

-- permanentizez tranzactia
commit;

-- ar trebui sa astept o zi ca sa pot vedea tranzactia in vizualizarea distanta
select * from mv_materie_prima_provincie@bd_provincie order by id_materie desc;

-- verific ce contine tabelul de loguri
-- id_materie: 31
select id_materie, DMLTYPE$$, OLD_NEW$$
from   mlog$_materie_prima;

-- execut manual operatia de refresh in coffee_project_bdd_provincie

-- verific ca vizualizarea sa fie reactualizata
select * from mv_materie_prima_provincie@bd_provincie order by id_materie desc;

-- verific ce contine acum tabelul de loguri
-- nimic
select id_materie, DMLTYPE$$, OLD_NEW$$
from   mlog$_materie_prima;

----------------------------------------------------

-- relatia replicata: PRODUS_MATERIE_PRIMA
create table produs_materie_prima as select * from produs_materie_prima_provincie@bd_provincie;

alter table produs_materie_prima 
add foreign key (id_produs) references produs(id_produs);

alter table produs_materie_prima 
add foreign key (id_materie) references materie_prima(id_materie);

alter table produs_materie_prima add primary key (id_produs, id_materie);

-- creez un fisier de log-uri diferit fata de cel pentru produs si materie_prima
CREATE MATERIALIZED VIEW
    log on produs_materie_prima
    with primary key
    (cantitate)
    including new values;

select * from produs_materie_prima order by id_produs desc;

-- in coffee_project_bdd_provincie creez un view materializat
-- pentru tabela produs_materie_prima

-- inserez cateva inregistrari noi in produs_materie_prima
insert into produs_materie_prima (id_produs, id_materie, cantitate)
values (256, 31, 0.1);

insert into produs_materie_prima (id_produs, id_materie, cantitate)
values (256, 2, 0.25);

insert into produs_materie_prima (id_produs, id_materie, cantitate)
values (256, 28, 0.05);

insert into produs_materie_prima (id_produs, id_materie, cantitate)
values (256, 12, 0.1);

-- permanentizez tranzactia
commit;

-- ma asigur ca s-a populat tabela produs_materie_prima
-- cu noua reteta pentru Cappuccino
select * from produs_materie_prima order by id_produs desc;

-- interoghez vizualizarea distanta
-- dar ultimele insert-uri inca nu apar
select * from mv_produs_materie_prima_provincie@bd_provincie order by id_produs desc;

-- observ ca in fisierul de log-uri se gasesc cele 4 inserturi
select id_produs, id_materie, cantitate, DMLTYPE$$, OLD_NEW$$
from   mlog$_produs_materie_prima;

-- coffee_project_bdd_provincie fac manual refreh pe vizualizare
-- iar acum apar modificarile
select * from mv_produs_materie_prima_provincie@bd_provincie order by id_produs desc;

-- acum in fisierul de log-uri nu se mai gaseste nicio inregistrare
select id_produs, id_materie, cantitate, DMLTYPE$$, OLD_NEW$$
from   mlog$_produs_materie_prima;

-- pentru a asigura replicarea in toate nodurile, 
-- voi crea vizualizari materializate pentru cele 3 tabele replicate si in coffee_project_bdd_bucuresti

