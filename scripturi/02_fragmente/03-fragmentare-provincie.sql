-- ma conectez la schema coffee_project_bdd_provincie
/
-- fragmentare orizontala primara tabela REGIUNI
create table regiune_provincie as
select *
from regiune@bd_all
where nume <> 'Bucuresti-Ilfov';
/
-- fragmentare orizontala derivata tabela JUDET
create table judet_provincie as
select j.id_judet, j.id_regiune, j.nume
from judet@bd_all j 
join regiune_provincie r on j.id_regiune = r.id_regiune;
/
-- fragmentare orizontala derivata tabela ORAS
create table oras_provincie as
select o.id_oras, o.id_judet, o.nume
from oras@bd_all o 
join judet_provincie j on o.id_judet = j.id_judet;
/
-- fragmentare orizontala derivata tabela LOCATIE
create table locatie_provincie as
select l.id_locatie, l.id_oras, l.strada, l.numar
from locatie@bd_all l 
join oras_provincie o on l.id_oras = o.id_oras;
/
-- fragmentare orizontala derivata tabela CAFENEA
create table cafenea_provincie as
select c.id_cafenea, c.id_locatie, c.nume_cafenea
from cafenea@bd_all c 
join locatie_provincie l on c.id_locatie = l.id_locatie;
/
-- fragmentare orizontala derivata + verticala pentru tabela ANGAJAT

-- extrag id_angajat, nume, prenume id_cafenea pentru angajatii din Bucuresti
create table angajat_provincie as
select  a.id_angajat,nume, prenume, a.id_cafenea
from angajat@bd_all a 
join cafenea_provincie c on a.id_cafenea = c.id_cafenea;
/
-- fragmentare orizontala derivata tabela INVENTAR_CAFENA
create table inventar_cafenea_provincie as
select ic.id_cafenea, ic.id_materie, ic.cantitate
from inventar_cafenea@bd_all ic 
join cafenea_provincie c on ic.id_cafenea = c.id_cafenea;
/
-- fragmentare orizontala derivata tabela COMANDA_CLIENT
create table comanda_client_provincie as
select cc.id_comanda_client, cc.id_client, cc.id_cafenea, data_plasarii
from comanda_client@bd_all cc 
join cafenea_provincie c on cc.id_cafenea = c.id_cafenea;
/
-- fragmentare orizontala derivata tabela COMANDA_PRODUS
create table comanda_produs_provincie as
select cp.id_comanda_client, cp.id_produs, cp.cantitate, cp.pret_final
from comanda_produs@bd_all cp 
join comanda_client_provincie cc on cp.id_comanda_client = cc.id_comanda_client;
/
-- avem clienti care comanda din orice cafene, indiferent de regiune
-- astfel ca avem nevoie ca tabela CLIENT sa fie replicata

-- replicare + fragmentare verticala pentru tabela CLIENT
-- extrag id_client, nume, prenume
create table client_provincie as
select id_client, nume, prenume
from client@bd_all;
/
-- momentan fac copie tabelelor PRODUS, MATERIE_PRIMA, RPODUS_MATERIE_PRIMA
-- dar voi sterge aceste copii atunci cand voi face vizualizari materializate

create table produs_bucuresti as
select * from produs@bd_all;

create table materie_prima_bucuresti as
select * from materie_prima@bd_all;

create table produs_materie_prima_bucuresti as
select * from produs_materie_prima@bd_all;