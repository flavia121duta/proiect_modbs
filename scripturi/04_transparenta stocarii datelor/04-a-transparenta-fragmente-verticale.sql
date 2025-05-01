-- RAPORTUL DE BACKEND

-- ma conectez la coffee_project_global

-- ex. 4 a)

-- transparenta localizarii datelor in cazul fragmentelor verticale

-- creez o vizualizare ANGAJATI_GLOBAL care sa contina toate informatiile despre angajatii
-- din fragmentele mixte NAGAJAT_BUCURESTI, ANGAJAT_PROVINCIE
-- si tabela ANGAJAT din schema curenta coffee_project_global
-- care este un fragmnet vertical ce contine informatii sensibile (email, parola)

create or replace view ANGAJATI_GLOBAL
as
select ab.id_angajat, ab.nume, ab.prenume, ag.salariu, ag.data_angajarii
from angajat_bucuresti@bd_bucuresti ab 
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
-- creez 2 trigger-i
-- un trigger pentru insert
-- un trigger pentru update, delete
create or replace trigger t_insert_angajati_global
instead of insert on angajati_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
    nr_clienti_aceeasi_pk_bucuresti number default 0;
    nr_clienti_aceeasi_pk_provincie number default 0;
begin
    -- verific constrangerea de PK pentru id_angajat
    select count(*) into nr_clienti_aceeasi_pk_bucuresti
    from   angajat_bucuresti@bd_bucuresti
    where   id_angajat = :new.id_angajat;

    if (nr_clienti_aceeasi_pk_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul angajat_bucuresti contine aceeasi cheie primara id_angajat = ' || :new.id_angajat);
    end if;

    select count(*) into nr_clienti_aceeasi_pk_provincie
    from   angajat_provincie@bd_provincie
    where   id_angajat = :new.id_angajat;

    if (nr_clienti_aceeasi_pk_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul angajat_provincie contine aceeasi cheie primara id_angajat = ' || :new.id_angajat);
    end if;

    select r.nume into v_nume_regiune
    from regiuni_global r
    join judete_global j    on r.id_regiune = j.id_regiune
    join orase_global o     on j.id_judet = o.id_judet
    join locatii_global l   on o.id_oras = l.id_oras
    join cafenele_global c  on l.id_locatie = c.id_locatie
    where c.id_cafenea = :new.id_cafenea;

    dbms_output.put_line('Angajatul lucreaza intr-o cafenea din ' || v_nume_regiune);

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        dbms_output.put_line('Inserez in tabelul din global');
        insert into angajat (id_angajat, salariu, data_angajarii)
        values (:new.id_angajat, :new.salariu, :new.data_angajarii);

        dbms_output.put_line('Inserez in fragmentul din Bucuresti');
        insert into user_bd.angajat_bucuresti (id_angajat, nume, prenume, id_cafenea)
        values (:new.id_angajat, :new.nume, :new.prenume, to_char(:new.id_cafenea));

    else
        dbms_output.put_line('Inserez in tabelul din global');
        insert into angajat (id_angajat, salariu, data_angajarii)
        values (:new.id_angajat, :new.salariu, :new.data_angajarii);

        dbms_output.put_line('Inserez in fragmentul din provincie');
        insert into angajat_provincie@bd_provincie (id_angajat, nume, prenume, id_cafenea)
        values (:new.id_angajat, :new.nume, :new.prenume, :new.id_cafenea);
    end if;
end;
/
create or replace TRIGGER "T_UPDATE_DELETE_ANGAJATI_GLOBAL" 
instead of update or delete on angajati_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin    
    select r.nume into v_nume_regiune
    from regiuni_global r
    join judete_global j    on r.id_regiune = j.id_regiune
    join orase_global o     on j.id_judet = o.id_judet
    join locatii_global l   on o.id_oras = l.id_oras
    join cafenele_global c  on l.id_locatie = c.id_locatie
    join angajati_global a  on c.id_cafenea = a.id_cafenea
    where a.id_angajat = :old.id_angajat;

    dbms_output.put_line('Angajatul lucreaza intr-o cafenea din ' || v_nume_regiune);

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if updating then
            dbms_output.put_line('Fac update in tabelul din global');
            update angajat
            set salariu = coalesce(:new.salariu, :old.salariu), data_angajarii = coalesce(:new.data_angajarii, :old.data_angajarii)
            where id_angajat = :new.id_angajat;

            dbms_output.put_line('Fac update in fragmentul din Bucuresti');
            update user_bd.angajat_bucuresti
            set nume = coalesce(:new.nume, :old.nume), 
                prenume = coalesce(:new.prenume, :old.prenume)
            where id_angajat = :new.id_angajat;

        elsif deleting then
            dbms_output.put_line('Sterg in tabelul din global');
            delete from angajat
            where id_angajat = :old.id_angajat;

            dbms_output.put_line('Sterg in fragmentul din Bucuresti');
            delete from user_bd.angajat_bucuresti
            where id_angajat = :old.id_angajat;
        end if;
    else
        if updating then
            dbms_output.put_line('Fac update in tabelul din global');
            update angajat_provincie@bd_provincie
            set nume = coalesce(:new.nume, :old.nume), 
                prenume = coalesce(:new.prenume, :old.prenume)
            where id_angajat = :new.id_angajat;

            dbms_output.put_line('Fac update in tabelul din provincie');
            update angajat
            set salariu = coalesce(:new.salariu, :old.salariu), data_angajarii = coalesce(:new.data_angajarii, :old.data_angajarii)
            where id_angajat = :new.id_angajat;

        elsif deleting then
            dbms_output.put_line('Sterg din tabelul din global');
            delete from angajat_provincie@bd_provincie
            where id_angajat = :old.id_angajat;

            dbms_output.put_line('Sterg din fragmentul din provincie');
            delete from angajat
            where id_angajat = :old.id_angajat;
        end if;
    end if;
end;
/

-- creez o vizualizare CLIENTI_GLOBAL
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
select * from clienti_global order by id_client desc; -- ok
select * from user_bd.client_bucuresti order by id_client desc; -- ok
select * from client_provincie@bd_provincie order by id_client desc; -- ok
/
update clienti_global
set email = 'maria.popa@mail.com'
where id_client = 101;
/
select * from clienti_global order by id_client desc; -- ok
select * from user_bd.client_bucuresti order by id_client desc; -- ok
select * from client_provincie@bd_provincie order by id_client desc; -- ok
/
delete from clienti_global where id_client = 101;
/
select * from clienti_global order by id_client desc; -- ok
select * from user_bd.client_bucuresti order by id_client desc; -- ok
select * from client_provincie@bd_provincie order by id_client desc; -- ok
/