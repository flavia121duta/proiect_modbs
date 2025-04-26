-- RAPORTUL DE BACKEND

-- transparenta localizarii datelor in cazul fragmentelor orizontale primare

-- ma conectez la coffee_project_global

-- ex. 4 a)

-- transparenta localizarii datelor in cazul fragmentelor verticale

-- creez o vizualizare ANGAJATI_GLOBAL care sa contina toate infrmatiile despre angajati
-- din fragmentele mixte NAGAJAT_BUCURESTI, ANGAJAT_PROVINCIE si ANGAJAT_GLOBAL
-- unde ANGAJAT_GLOBAL este o tabela din schema curenta, coffee_project_global

create or replace view ANGAJATI_GLOBAL
as
select ab.id_angajat, ab.nume, ab.prenume, ag.salariu, ag.data_angajarii
from user_bd.angajat_bucuresti ab 
join angajat ag on ab.id_angajat = ag.id_angajat
union all
select ap.id_angajat, ap.nume, ap.prenume, ag.salariu, ag.data_angajarii
from angajat_provincie@bd_provincie ap 
join angajat ag on ap.id_angajat = ag.id_angajat;

-- afisez toate informatiile despre angajati folosind aceasta vizualizare
select * from ANGAJATI_GLOBAL;
/
-- verific ce coloane permit propagarea datelor (toate)
select COLUMN_NAME, UPDATABLE, INSERTABLE,DELETABLE
from   user_updatable_columns
where  table_name = upper('angajati_global');
/
-- creez trigger
create or replace trigger t_angajati_global
instead of insert or update or delete on angajati_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin    
    dbms_output.put_line('Verific unde se afla cafeneaua acestui angajat angajat');
    if inserting or updating then
        dbms_output.put_line('Operatia in curs: inserting sau updating');
        select rg.nume into v_nume_regiune
        from regiuni_global rg
        join judete_global jg on rg.id_regiune = jg.id_regiune
        join orase_global og on jg.id_judet = og.id_judet
        join locatii_global lg on og.id_oras = lg.id_oras
        join cafenele_global cg on lg.id_locatie = cg.id_locatie
        where cg.id_cafenea = :new.id_cafenea;
    elsif deleting then
        dbms_output.put_line('Operatia in curs: deleting');
        select rg.nume into v_nume_regiune
        from regiuni_global rg
        join judete_global jg on rg.id_regiune = jg.id_regiune
        join orase_global og on jg.id_judet = og.id_judet
        join locatii_global lg on og.id_oras = lg.id_oras
        join cafenele_global cg on lg.id_locatie = cg.id_locatie
        join angajati_global ag on cg.id_cafenea = ag.id_cafenea
        where ag.id_angajat = :old.id_angajat;
    end if;

    dbms_output.put_line('Angajatul lucreaza intr-o cafenea din ' || v_nume_regiune);

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if inserting then
            dbms_output.put_line('Inserez in tabelul din global');
            insert into angajat (id_angajat, salariu, data_angajarii)
            values (:new.id_angajat, :new.salariu, :new.data_angajarii);

            dbms_output.put_line('Inserez in tabelul din Bucuresti');
            insert into user_bd.angajat_bucuresti (id_angajat, nume, prenume, id_cafenea)
            values (:new.id_angajat, :new.nume, :new.prenume, to_char(:new.id_cafenea));
        elsif updating then
            dbms_output.put_line('Fac update in tabelul din global');
            update angajat
            set salariu = coalesce(:new.salariu, :old.salariu), data_angajarii = coalesce(:new.data_angajarii, :old.data_angajarii)
            where id_angajat = :new.id_angajat;

            dbms_output.put_line('Fac update in tabelul din Bucuresti');
            update user_bd.angajat_bucuresti
            set nume = coalesce(:new.nume, :old.nume), 
                prenume = coalesce(:new.prenume, :old.prenume)
            where id_angajat = :new.id_angajat;

        elsif deleting then
            dbms_output.put_line('Sterg in tabelul din global');
            delete from angajat
            where id_angajat = :old.id_angajat;

            dbms_output.put_line('Sterg in tabelul din Bucuresti');
            delete from user_bd.angajat_bucuresti
            where id_angajat = :old.id_angajat;
        end if;
    else
        if inserting then
            dbms_output.put_line('Inserez in tabelul din global');
            insert into angajat (id_angajat, salariu, data_angajarii)
            values (:new.id_angajat, :new.salariu, :new.data_angajarii);

            dbms_output.put_line('Inserez in tabelul din provincie');
            insert into angajat_provincie@bd_provincie (id_angajat, nume, prenume, id_cafenea)
            values (:new.id_angajat, :new.nume, :new.prenume, :new.id_cafenea);

        elsif updating then
            dbms_output.put_line('Fac update in tabelul din global');
            update angajat_provincie@bd_provincie
            set nume = coalesce(:new.nume, :old.nume), prenume = coalesce(:new.prenume, :old.prenume)
            where id_angajat = :new.id_angajat;

            dbms_output.put_line('Fac update in tabelul din provincie');
            update angajat
            set salariu = coalesce(:new.salariu, :old.salariu), data_angajarii = coalesce(:new.data_angajarii, :old.data_angajarii)
            where id_angajat = :new.id_angajat;

        elsif deleting then
            dbms_output.put_line('Sterg din tabelul din global');
            delete from angajat_provincie@bd_provincie
            where id_angajat = :old.id_angajat;

            dbms_output.put_line('Sterg din tabelul din provincie');
            delete from angajat
            where id_angajat = :old.id_angajat;
        end if;
    end if;
end;
/
-- creez o tabela CLIENTI_GLOBAL
-- care va contine informatii din CLIENT_BCURESTI/ CLIENT_PROVINCIE (sunt identice)
-- si CLIENT din schema curenta, coffee_project_global

create or replace view CLIENTI_GLOBAL
as
select cb.id_client, cb.nume, cb.prenume, cg.email, cg.parola
from user_bd.client_bucuresti cb, client cg
where cb.id_client = cg.id_client;
/
select * from CLIENTI_GLOBAL;
/
select COLUMN_NAME, UPDATABLE, INSERTABLE,DELETABLE
from   user_updatable_columns
where  table_name = upper('CLIENTI_GLOBAL');
/
-- creez un trigger pentru insert, update, delete
create or replace trigger t_clienti_global
instead of insert or update or delete on clienti_global
for each row
begin
    if inserting then
        insert into client (id_client, email, parola)
        values (:new.id_client, :new.email, :new.parola);

        insert into user_bd.client_bucuresti (id_client, nume, prenume)
        values (:new.id_client, :new.nume, :new.prenume);

        insert into client_provincie@bd_provincie (id_client, nume, prenume)
        values (:new.id_client, :new.nume, :new.prenume);

    elsif updating then
        update client
        set email = coalesce(:new.email, :old.email),
            parola = coalesce(:new.parola, :old.parola)
        where id_client = :old.id_client;

        update user_bd.client_bucuresti
        set nume = coalesce(:new.nume, :old.nume),
            prenume = coalesce(:new.prenume, :old.prenume)
        where id_client = :old.id_client;

        update client_provincie@bd_provincie
        set nume = coalesce(:new.nume, :old.nume),
            prenume = coalesce(:new.prenume, :old.prenume)
        where id_client = :old.id_client;

    elsif deleting then
        delete from client where id_client = :old.id_client;
        delete from user_bd.client_bucuresti where id_client = :old.id_client;
        delete from client_provincie@bd_provincie where id_client = :old.id_client;
    end if;
end;
/
select * from clienti_global;
/
-- testez sa vad daca functioneaza
insert into clienti_global (id_client, nume, prenume, email, parola)
values (101, 'Maria', 'Popa', 'mirela.popa@mail.com', 'test1234');
/
select * from clienti_global order by id_client desc;
select * from clienti_global order by id_client desc;
select * from user_bd.client_bucuresti order by id_client desc;
select * from client_provincie@bd_provincie order by id_client desc;
/
update clienti_global
set email = 'maria.popa@mail.com'
where id_client = 101;
/
select * from clienti_global order by id_client desc;
select * from clienti_global order by id_client desc;
select * from user_bd.client_bucuresti order by id_client desc;
select * from client_provincie@bd_provincie order by id_client desc;
/
delete from clienti_global where id_client = 101;
/
select * from clienti_global order by id_client desc;
select * from clienti_global order by id_client desc;
select * from user_bd.client_bucuresti order by id_client desc;
select * from client_provincie@bd_provincie order by id_client desc;
/

-- ex. 4 b)
-- tabela REGIUNE din coffee_project_bdd_all este singura care a suportat 
-- fragmentare orizontala primara

create or replace view regiuni_global
as (
    select * from user_bd.regiune_bucuresti
    union all
    select * from regiune_provincie@bd_provincie
);
/
-- afisez toate regiunile folosind aceasta vizualizare
select * from regiuni_global;
/
-- verific ce coloane permit propagarea datelor (toate)
select COLUMN_NAME, UPDATABLE, INSERTABLE,DELETABLE
from   user_updatable_columns
where  table_name = upper('regiuni_global');
/
-- definesc un trigger care sa permita propagarea operatiilor LMD
--asupra tabelelor de baza ale vizualizrii

create or replace trigger t_regiuni_global
instead of insert or update or delete on regiuni_global
for each row
begin
    if :new.nume = 'Bucuresti-Ilfov' then
        if inserting then
            insert into user_bd.regiune_bucuresti
            values (:new.id_regiune, :new.nume);
        elsif updating then
            update user_bd.regiune_bucuresti
            set nume = :new.nume
            where id_regiune = :new.id_regiune;
        elsif deleting then
            delete from user_bd.regiune_bucuresti
            where id_regiune = :new.id_regiune;
        end if;
    else
        if inserting then
            insert into regiune_provincie@bd_provincie
            values (:new.id_regiune, :new.nume);
        elsif updating then
            update regiune_provincie@bd_provincie
            set nume = :new.nume
            where id_regiune = :new.id_regiune;
        elsif deleting then
            delete from regiune_provincie@bd_provincie
            where id_regiune = :new.id_regiune;
        end if;
    end if;
end;
/
-- testez sa vad daca trigger-ul functioneaza corect
insert into regiuni_global (id_regiune, nume)
values (9, 'Republica Moldova');

select * from regiuni_global;

select * from user_bd.regiune_bucuresti;
select * from regiune_provincie@bd_provincie

-- anulez modificarile facute
rollback;
/
-- transparenta localizarii datelor in cazul fragmentelor orizontale derivate
-- avem urmatoarele fragmente orizontale derivate: 
-- judet, oras, locatie, cafenea, inventar_cafenea, comanda_client, comanda_produs

-- pentru fiecare dintre ele voi crea o vizualizare simpla
create or replace view judete_global
as
select * from user_bd.judet_bucuresti
union all
select * from judet_provincie@bd_provincie;
/
create or replace view orase_global
as
select * from user_bd.oras_bucuresti
union all
select * from oras_provincie@bd_provincie
/
create or replace view locatii_global
as
select * from user_bd.locatie_bucuresti
union all
select * from locatie_provincie@bd_provincie
/
create or replace view cafenele_global
as
select * from user_bd.cafenea_bucuresti
union all
select * from cafenea_provincie@bd_provincie;
/
create or replace view inventare_cafenele_global
as
select * from user_bd.inventar_cafenea_bucuresti
union all
select * from inventar_cafenea_provincie@bd_provincie;
/
create or replace view comenzi_clienti_global
as
select * from user_bd.comanda_client_bucuresti
union all
select * from comanda_client_provincie@bd_provincie;
/
create or replace view comenzi_produse_global
as
select * from user_bd.comanda_produs_bucuresti
union all
select * from comanda_produs_provincie@bd_provincie;
/
-- tabelele PRODUSE, MATERIE_PRIMA, PRODUS_MATERIE_PRIMA sunt replicate
-- deci le replicam si aici
create or replace view produse_global
as select * from produs_provincie@bd_provincie;

create or replace view materii_prime_global
as select * from materie_prima_provincie@bd_provincie;
/
create or replace view produse_materii_prime_global
as select * from produs_materie_prima_provincie@bd_provincie;
/
-- atunci cand se plaseaza o comanda, vom face propagarea datelor
-- din nodul global in nodul corespunzator
-- in functie de cafeneaua in care e plasata comanda
set serveroutput on;
/
create or replace trigger t_comenzi_clienti_global
instead of insert on comenzi_clienti_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    dbms_output.put_line('Verific in ce regiune se afla cafeneaua din care a fost plasata comanda');
    select rg.nume into v_nume_regiune
    from regiuni_global rg 
    join judete_global jg on rg.id_regiune = jg.id_regiune
    join orase_global og on og.id_judet = jg.id_judet
    join locatii_global lg on lg.id_oras = og.id_oras
    join cafenele_global cg on cg.id_locatie = lg.id_locatie
    where cg.id_cafenea = :new.id_cafenea;
    dbms_output.put_line('Comanda a fost plasata intr-o cafenea din ' || v_nume_regiune); 

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        dbms_output.put_line('Inserez in tabelul COMANDA_CLIENT_BUCURESTI...'); 
        insert into user_bd.comanda_client_bucuresti (id_comanda_client, id_client, id_cafenea, data_plasarii)
        values (:new.id_comanda_client, :new.id_client, :new.id_cafenea, :new.data_plasarii);
    else
        dbms_output.put_line('Inserez in tabelul COMANDA_CLIENT_PROVINCIE...'); 
        insert into comanda_client_provincie@bd_provincie (id_comanda_client, id_client, id_cafenea, data_plasarii)
        values (:new.id_comanda_client, :new.id_client, :new.id_cafenea, :new.data_plasarii);
    end if;
end;
/

create or replace trigger t_comenzi_produse_global
instead of insert on comenzi_produse_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    dbms_output.put_line('Verific in ce regiune se afla cafeneaua din care a fost plasata comanda');
    
    select rg.nume into v_nume_regiune
    from regiuni_global rg 
    join judete_global jg on rg.id_regiune = jg.id_regiune
    join orase_global og on og.id_judet = jg.id_judet
    join locatii_global lg on lg.id_oras = og.id_oras
    join cafenele_global cg on cg.id_locatie = lg.id_locatie
    join comenzi_clienti_global ccg on ccg.id_cafenea = cg.id_cafenea
    where ccg.id_comanda_client = :new.id_comanda_client;
    
    dbms_output.put_line('Comanda a fost plasata intr-o cafenea din ' || v_nume_regiune); 

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        dbms_output.put_line('Inserez in tabelul COMANDA_PRODUS_BUCURESTI...'); 
        insert into user_bd.comanda_produs_bucuresti (id_comanda_client, id_produs, cantitate, pret_final)
        values (:new.id_comanda_client, :new.id_produs, :new.cantitate, :new.pret_final);
    else
        dbms_output.put_line('Inserez in tabelul COMANDA_PRODUS_PROVINCIE...'); 
        insert into comanda_produs_provincie@bd_provincie (id_comanda_client, id_produs, cantitate, pret_final)
        values (:new.id_comanda_client, :new.id_produs, :new.cantitate, :new.pret_final);
    end if;
end;
/
select * from comenzi_clienti_global order by id_comanda_client desc;
/
-- testez sa vad daca ceke doua trigger-e pentru creare unei comanzi funcioneaza
insert into comenzi_clienti_global (id_comanda_client, id_client, id_cafenea, data_plasarii)
values (100001, 2, 1, '25-APR-2025');

select * from comenzi_clienti_global order by id_comanda_client desc;
select * from user_bd.comanda_client_bucuresti order by id_comanda_client desc;
select * from comanda_client_provincie@bd_provincie order by id_comanda_client desc;
/
insert into comenzi_produse_global (id_comanda_client, id_produs, cantitate, pret_final)
values (100001, 100, 2, 13.15);

insert into comenzi_produse_global (id_comanda_client, id_produs, cantitate, pret_final)
values (100001, 101, 1, 16.77);

insert into comenzi_produse_global (id_comanda_client, id_produs, cantitate, pret_final)
values (100001, 102, 3, 17.81);

select * from comenzi_produse_global order by id_comanda_client desc;
select * from user_bd.comanda_produs_bucuresti order by id_comanda_client desc;
select * from comanda_produs_provincie@bd_provincie order by id_comanda_client desc;
/

-- ex. 4 c)

/

-- aici vine ceva useless, dar inca nu vreau sa-l sterg

CREATE OR REPLACE TRIGGER t_orase_global
INSTEAD OF INSERT ON orase
FOR EACH ROW
DECLARE
   v_count INTEGER;
BEGIN
   SELECT COUNT(*)
   INTO v_count
   FROM judete j
   WHERE j.id_judet = :new.id_judet
     AND j.id_regiune = (
         SELECT r.id_regiune
         FROM regiuni r
         WHERE r.nume = 'Bucuresti-Ilfov'
     );

   IF v_count > 0 THEN
      INSERT INTO user_bd.oras_bucuresti (id_oras, id_judet, nume)
      VALUES (:new.id_oras, :new.id_judet, :new.nume);
   ELSE
      INSERT INTO oras_provincie@bd_provincie (id_oras, id_judet, nume)
      VALUES (:new.id_oras, :new.id_judet, :new.nume);
   END IF;
END;

/
insert into orase (id_oras, id_judet, nume)
values (101, 1, 'Oras 101');
commit;
/
select o.id_oras, o.id_judet, o.nume
from orase o join judete j on o.id_judet = j.id_judet
join regiuni r on j.id_regiune = r.id_regiune
and r.nume = 'Bucuresti-Ilfov';