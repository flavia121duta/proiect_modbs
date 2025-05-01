-- RAPORTUL DE BACKEND

-- ma conectez la coffee_project_global

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
-- definesc un trigger care sa permita propagarea operatiilor de insert
-- asupra tabelelor de baza ale vizualizrii

create or replace TRIGGER "T_INSERT_REGIUNI_GLOBAL" 
instead of insert on regiuni_global
for each row
declare
    nr_regiuni_acelasi_id_bucuresti number default 0;
    nr_regiuni_acelasi_id_provincie number default 0;
begin
    -- verific constrangerea de PK pentru id_regiune
    select count(*) into nr_regiuni_acelasi_id_bucuresti
    from   regiune_bucuresti@bd_bucuresti
    where  id_regiune = :new.id_regiune;

    if (nr_regiuni_acelasi_id_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul regine_bucuresti contine acceasi cheie primara id_regiune = ' || :new.id_regiune);
    end if;

    select count(*) into nr_regiuni_acelasi_id_provincie
    from   regiune_provincie@bd_provincie
    where  id_regiune = :new.id_regiune;

    if (nr_regiuni_acelasi_id_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul regine_provincie contine acceasi cheie primara id_regiune = ' || :new.id_regiune);
    end if;
    
    -- inserez noua inregistrare ca regiune in provincie
    insert into regiune_provincie@bd_provincie (id_regiune, nume)
    values (:new.id_regiune, :new.nume);
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
-- analog creez un trigger pentru update si delete
create or replace trigger t_update_delete_regiuni_global
instead of update or delete on regiuni_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    select r.nume into v_nume_regiune
    from regiuni_global r
    where r.id_regiune = :old.id_regiune;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if updating then
            update regiune_bucuresti@bd_bucuresti
            set nume = :new.nume
            where id_regiune = :new.id_regiune;
        else
            delete from regiune_bucuresti@bd_bucuresti
            where id_regiune = :old.id_regiune;
        end if;
    else
        if updating then
            update regiune_provincie@bd_provincie
            set nume = :new.nume
            where id_regiune = :new.id_regiune;
        else
            delete from regiune_provincie@bd_provincie
            where id_regiune = :old.id_regiune;
        end if;
    end if;
end;
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

-- atunci cand se plaseaza o comanda, vom face propagarea datelor
-- din nodul global in nodul corespunzator
-- in functie de cafeneaua in care e plasata comanda
set serveroutput on;
/
create or replace TRIGGER "T_INSERT_COMENZI_CLIENTI_GLOBAL" 
instead of insert on comenzi_clienti_global
for each row
declare
    nr_comenzi_clienti_aceeasi_pk_bucuresti number default 0;
    nr_comenzi_clienti_aceeasi_pk_provincie number default 0;
    v_nume_regiune regiuni_global.nume%type;
begin
    -- constrangere de PK pentru id_comanda_client
    select count(*) into nr_comenzi_clienti_aceeasi_pk_bucuresti
    from   comanda_client_bucuresti@bd_bucuresti
    where   id_comanda_client = :new.id_comanda_client;

    if (nr_comenzi_clienti_aceeasi_pk_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_client_bucuresti contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client);
    end if;

    select count(*) into nr_comenzi_clienti_aceeasi_pk_provincie
    from   comanda_client_provincie@bd_provincie
    where   id_comanda_client = :new.id_comanda_client;

    if (nr_comenzi_clienti_aceeasi_pk_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_produs_provincie contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client);
    end if;

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
        values (seq_comanda_client_buc.nextval@bd_bucuresti, :new.id_client, :new.id_cafenea, :new.data_plasarii);
    else
        dbms_output.put_line('Inserez in tabelul COMANDA_CLIENT_PROVINCIE...'); 
        insert into comanda_client_provincie@bd_provincie (id_comanda_client, id_client, id_cafenea, data_plasarii)
        values (seq_comanda_client_prov.nextval@bd_provincie, :new.id_client, :new.id_cafenea, :new.data_plasarii);
    end if;
end;
/

create or replace TRIGGER "T_INSERT_COMENZI_PRODUSE_GLOBAL" 
instead of insert on comenzi_produse_global
for each row
declare
    nr_comenzi_produse_aceeasi_pk_bucuresti number default 0;
    nr_comenzi_produse_aceeasi_pk_provincie number default 0;
    v_nume_regiune regiuni_global.nume%type;
begin
    -- verific constrangerea de PK pentru combinatia de coloane (id_comanda_client, id_produs)
    select count(*) into nr_comenzi_produse_aceeasi_pk_bucuresti
    from   comanda_produs_bucuresti@bd_bucuresti
    where   id_comanda_client = :new.id_comanda_client
    and     id_produs = :new.id_produs;

    if (nr_comenzi_produse_aceeasi_pk_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_produs_bucuresti contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client || ', id_produs = ' || :new.id_produs);
    end if;

    select count(*) into nr_comenzi_produse_aceeasi_pk_provincie
    from   comanda_produs_provincie@bd_provincie
    where   id_comanda_client = :new.id_comanda_client
    and     id_produs = :new.id_produs;

    if (nr_comenzi_produse_aceeasi_pk_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_produs_provincie contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client || ', id_produs = ' || :new.id_produs);
    end if;
    
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
-- testez sa vad daca cele doua trigger-e pentru creare unei comanzi funcioneaza
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

-- ok, trigger-ele functioneaza corect
-- anulez modificarile facute
rollback;
/

-- analog voi create trigger-e pentru insert
-- si separat pentru update si delete
-- pentru restul vizualizarilor
-- judet, oras, locatie, cafenea, inventar_cafenea

create or replace trigger t_insert_judete_global
instead of insert on judete_global
for each row
declare
    nr_judete_acelasi_id_bucuresti number default 0;
    nr_judete_acelasi_id_provincie number default 0;
    v_nume_regiune regiuni_global.nume%type;
begin
    -- verific constrangerea de PK
    select count(*) into nr_judete_acelasi_id_bucuresti
    from   judet_bucuresti@bd_bucuresti
    where  id_judet = :new.id_judet;

    if (nr_judete_acelasi_id_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul judet_bucuresti contine aceeasi cheie primara id_judet = ' || :new.id_judet);
    end if;

    select count(*) into nr_judete_acelasi_id_provincie
    from   judet_provincie@bd_provincie
    where  id_judet = :new.id_judet;

    if (nr_judete_acelasi_id_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul judet_provincie contine aceeasi cheie primara id_judet = ' || :new.id_judet);
    end if;

    select r.nume into v_nume_regiune
    from regiuni_global r
    where r.id_regiune = :old.id_regiune;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        insert into judet_bucuresti@bd_bucuresti (id_judet, nume)
        values (:new.id_judet, :new.nume);
    else
        insert into judet_provincie@bd_provincie (id_judet, nume)
        values (:new.id_judet, :new.nume);
    end if;
end;
/
create or replace trigger t_update_delete_judete_global
instead of update or delete on judete_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    -- determin in ce regiune a tarii se gaseste judetul pentru care fac update/ delete
    select r.nume into v_nume_regiune
    from regiuni_global r
    join judete_global j on r.id_regiune = j.id_regiune
    where j.id_judet = :old.id_judet;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if updating then
            update judet_bucuresti@bd_bucuresti
            set nume = :new.nume
            where id_judet = :new.id_judet;
        else
            delete from judet_bucuresti@bd_bucuresti
            where id_judet = :old.id_judet;
        end if;
    else
        if updating then
            update judet_provincie@bd_provincie
            set nume = :new.nume
            where id_judet = :new.id_judet;
        else
            delete from judet_provincie@bd_provincie
            where id_judet = :old.id_judet;
        end if;
    end if;
end;
/

create or replace trigger t_insert_orase_global
instead of insert on orase_global
for each row
declare
    nr_orase_acelasi_id_bucuresti number default 0;
    nr_orase_acelasi_id_provincie number default 0;
    v_nume_regiune regiuni_global.nume%type;
begin
    -- verific constrangerea de PK
    select count(*) into nr_orase_acelasi_id_bucuresti
    from   oras_bucuresti@bd_bucuresti
    where  id_oras = :new.id_oras;

    if (nr_orase_acelasi_id_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul oras_bucuresti contine aceeasi cheie primara id_oras = ' || :new.id_oras);
    end if;

    select count(*) into nr_orase_acelasi_id_provincie
    from   oras_provincie@bd_provincie
    where  id_oras = :new.id_oras;

    if (nr_orase_acelasi_id_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul oras_provincie contine aceeasi cheie primara id_oras = ' || :new.id_oras);
    end if;

    -- determin in ce regiune a tarii se afla noul oras dupa id-ul judetului
    select r.nume into v_nume_regiune
    from regiuni_global r
    join judete_global j on r.id_regiune = j.id_regiune
    where j.id_judet = :new.id_judet;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        insert into oras_bucuresti@bd_bucuresti (id_oras, id_judet, nume)
        values (:new.id_oras, :new.id_judet, :new.nume);
    else
        insert into oras_provincie@bd_provincie (id_oras, id_judet, nume)
        values (:new.id_oras, :new.id_judet, :new.nume);
    end if;
end;
/
create or replace trigger t_update_delete_orase_global
instead of update or delete on orase_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    -- determin in ce regiune a tarii se gaseste orasul pt care fac update/ delete
    select r.nume into v_nume_regiune
    from regiuni_global r
    join judete_global j on j.id_regiune = r.id_regiune
    join orase_global o on o.id_judet = j.id_judet
    where o.id_oras = :old.id_oras;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if updating then
            update oras_bucuresti@bd_bucuresti
            set nume = :new.nume
            where id_oras = :new.id_oras;
        else
            delete from oras_bucuresti@bd_bucuresti
            where id_oras = :old.id_oras;
        end if;
    else
        if updating then
            update oras_provincie@bd_provincie
            set nume = :new.nume
            where id_oras = :new.id_oras;
        else
            delete from oras_provincie@bd_provincie
            where id_oras = :old.id_oras;
        end if;
    end if;
end;
/

create or replace trigger t_insert_locatii_global
instead of insert on locatii_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
    nr_locatii_acelasi_id_bucuresti number default 0;
    nr_locatii_acelasi_id_provincie number default 0;
begin
    -- determin regiunea unde se va afla noua locatie
    select rg.nume into v_nume_regiune
    from regiuni_global rg
    join judete_global jg on rg.id_regiune = jg.id_regiune
    join orase_global og on jg.id_judet = og.id_judet
    where og.id_oras = :new.id_oras;

    dbms_output.put_line('Noua adresa/locatie este intr-o regiune din ' || v_nume_regiune);

    -- verific daca exista deja o locatie cu acelasi PK in Bucuresti
    select count(*) into nr_locatii_acelasi_id_bucuresti
    from locatie_bucuresti@bd_bucuresti
    where id_locatie = :new.id_locatie;

    if (nr_locatii_acelasi_id_bucuresti > 0) then
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul locatie_bucuresti contine aceeasi cheie primara id_locatie = ' || :new.id_locatie);
    end if;

    -- verific daca exista deja o locatie cu acelasi PK in provincie
    select count(*) into nr_locatii_acelasi_id_provincie
    from locatie_provincie@bd_provincie
    where id_locatie = :new.id_locatie;

    if (nr_locatii_acelasi_id_provincie > 0) then
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul locatie_provincie contine aceeasi cheie primara id_locatie = ' || :new.id_locatie);
    end if;

    --inserez in fragmentul corespunzator
    if v_nume_regiune = 'Bucuresti-Ilfov' then
        dbms_output.put_line('Inserez in tabelul din Bucuresti');
        insert into locatie_bucuresti@bd_bucuresti (id_locatie, id_oras, strada, numar)
        values (:new.id_locatie, :new.id_oras, :new.strada, :new.numar);
    else
        dbms_output.put_line('Inserez in tabelul din provincie');
        insert into locatie_provincie@bd_provincie (id_locatie, id_oras, strada, numar)
        values (:new.id_locatie, :new.id_oras, :new.strada, :new.numar);
    end if;
end;
/
create or replace trigger t_update_delete_locatii_global
instead of update or delete on locatii_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    -- determin in ce regiune se afla locatia
    select rg.nume into v_nume_regiune
    from regiuni_global rg
    join judete_global jg on rg.id_regiune = jg.id_regiune
    join orase_global og on jg.id_judet = og.id_judet
    join locatii_global lg on og.id_oras = lg.id_oras
    where lg.id_locatie = :old.id_locatie;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if updating then
            update locatie_bucuresti@bd_bucuresti
            set strada = coalesce(:new.strada, :old.strada),
            numar = coalesce(:new.numar, :old.numar)
            where id_locatie = :new.id_locatie;
        else
            delete from locatie_bucuresti@bd_bucuresti
            where id_locatie = :old.id_locatie;
        end if;
    else
        if updating then
            update locatie_provincie@bd_provincie
            set strada = coalesce(:new.strada, :old.strada),
            numar = coalesce(:new.numar, :old.numar)
            where id_locatie = :new.id_locatie;
        else
            delete from locatie_provincie@bd_provincie
            where id_locatie = :old.id_locatie;
        end if;
    end if;
end;
/

create or replace trigger t_insert_cafenele_global
instead of insert on cafenele_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
    nr_cafenele_acelasi_id_bucuresti number default 0;
    nr_cafenele_acelasi_id_provincie number default 0;
begin
    -- verific daca mai exista o cafenea cu acelasi PK in fragmentul din Bucuresti
    select count(*) into nr_cafenele_acelasi_id_bucuresti
    from   cafenea_bucuresti@bd_bucuresti
    where  id_cafenea = :new.id_cafenea;

    if (nr_cafenele_acelasi_id_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul cafenea_bucuresti contine aceeasi cheie primara id_locatie = ' || :new.id_cafenea);
    end if;

    -- verific daca mai exista o cafenea cu acelasi PK in fragmentul din provincie
    select count(*) into nr_cafenele_acelasi_id_provincie
    from   cafenea_provincie@bd_provincie
    where  id_cafenea = :new.id_cafenea;

    if (nr_cafenele_acelasi_id_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul cafenea_provincie contine aceeasi cheie primara id_locatie = ' || :new.id_locatie);
    end if;
    
    -- determin in ce regiune se afla noua cafenea
    select rg.nume into v_nume_regiune
    from regiuni_global rg
    join judete_global jg on rg.id_regiune = jg.id_regiune
    join orase_global og on jg.id_judet = og.id_judet
    join locatii_global lg on og.id_oras = lg.id_oras
    where lg.id_locatie = :new.id_locatie;

    dbms_output.put_line('Noua cafenea este locata intr-o regiune din ' || v_nume_regiune);
    
    -- inserez in fragmentul corespunzator
    if v_nume_regiune = 'Bucuresti-Ilfov' then
        dbms_output.put_line('Inserez in tabelul din Bucuresti');
        insert into cafenea_bucuresti@bd_bucuresti (id_cafenea, id_locatie, nume_cafenea)
        values (:new.id_cafenea, :new.id_locatie, :new.nume_cafenea);
    else
        dbms_output.put_line('Inserez in tabelul din provincie');
        insert into cafenea_provincie@bd_provincie (id_cafenea, id_locatie, nume_cafenea)
        values (:new.id_cafenea, :new.id_locatie, :new.nume_cafenea);
    end if;
end;
/
create or replace trigger t_update_delete_cafenele_global
instead of update or delete on cafenele_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    -- determin in ce regiune se afla cafeneaua
    select rg.nume into v_nume_regiune
    from regiuni_global rg
    join judete_global jg on rg.id_regiune = jg.id_regiune
    join orase_global og on jg.id_judet = og.id_judet
    join locatii_global lg on og.id_oras = lg.id_oras
    join cafenele_global cg on lg.id_locatie = cg.id_locatie
    where cg.id_cafenea = :old.id_cafenea;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if updating then
            update cafenea_bucuresti@bd_bucuresti
            set nume_cafenea = :new.nume_cafenea
            where id_cafenea = :new.id_cafenea;
        else
            -- sterg inventarul
            delete from inventar_cafenea_bucuresti@bd_bucuresti
            where id_cafenea = :new.id_cafenea;

            -- sterg cafeneaua propriu-siza
            delete from cafenea_bucuresti@bd_bucuresti
            where id_cafenea = :old.id_cafenea;
        end if;
    else
        if updating then
            update cafenea_provincie@bd_provincie
            set nume_cafenea = :new.nume_cafenea
            where id_cafenea = :new.id_cafenea;
        else
            -- sterg inventarul
            delete from inventar_cafenea_provincie@bd_provincie
            where id_cafenea = :new.id_cafenea;

            -- sterg cafeneaua propriu-siza
            delete from cafenea_provincie@bd_provincie
            where id_cafenea = :old.id_cafenea;
        end if;
    end if;
end;
/

create or replace trigger t_insert_inventare_cafenele_global
instead of insert on inventare_cafenele_global
for each row
declare
    nr_inventare_aceeasi_pk_bucuresti number default 0;
    nr_inventare_aceeasi_pk_provincie number default 0;
    v_nume_regiune regiuni_global.nume%type;
begin
    -- verific constrangerea de PK pentru combinatia de coloane (id_cafenea, id_materie)
    select count(*) into nr_inventare_aceeasi_pk_bucuresti
    from   inventar_cafenea_bucuresti@bd_bucuresti
    where   id_cafenea = :new.id_cafenea
    and     id_materie = :new.id_materie;

    if (nr_inventare_aceeasi_pk_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul inventar_bucuresti contine aceeasi cheie primara id_cafenea = ' || :new.id_cafenea || ', id_materie = ' || :new.id_materie);
    end if;

    select count(*) into nr_inventare_aceeasi_pk_provincie
    from   inventar_cafenea_provincie@bd_provincie
    where   id_cafenea = :new.id_cafenea
    and     id_materie = :new.id_materie;

    if (nr_inventare_aceeasi_pk_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul inventar_provincie contine aceeasi cheie primara id_cafenea = ' || :new.id_cafenea || ', id_materie = ' || :new.id_materie);
    end if;
    
    -- verific in ce regiune se afla inventarul cafenelei
    select r.nume into v_nume_regiune
    from regiuni_global r
    join judete_global j    on r.id_regiune = j.id_regiune
    join orase_global o     on j.id_judet = o.id_judet
    join locatii_global l   on o.id_oras = l.id_oras
    join cafenele_global c  on l.id_locatie = c.id_locatie
    where c.id_cafenea = :new.id_cafenea;

    dbms_output.put_line('Cafeneaua se afla intr-o regiune din ' || v_nume_regiune);

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        insert into inventar_cafenea_bucuresti@bd_bucuresti (id_cafenea, id_materie, cantitate)
        values (:new.id_cafenea, :new.id_materie, :new.cantitate);

    else
        insert into inventar_cafenea_provincie@bd_provincie (id_cafenea, id_materie, cantitate)
        values (:new.id_cafenea, :new.id_materie, :new.cantitate);
    end if;
end;
/
create or replace trigger t_update_delete_inventare_cafenele_global
instead of update or delete on inventare_cafenele_global
for each row
declare
    v_nume_regiune regiuni_global.nume%type;
begin
    -- determin in ce regiune se afla cafeneaua de care apartine inventarul
    select rg.nume into v_nume_regiune
    from regiuni_global rg
    join judete_global jg on rg.id_regiune = jg.id_regiune
    join orase_global og on jg.id_judet = og.id_judet
    join locatii_global lg on og.id_oras = lg.id_oras
    join cafenele_global cg on lg.id_locatie = cg.id_locatie
    where cg.id_cafenea = :old.id_cafenea;

    if v_nume_regiune = 'Bucuresti-Ilfov' then
        if updating then
            update inventar_cafenea_bucuresti@bd_bucuresti
            set cantitate = :new.cantitate
            where id_cafenea = :new.id_cafenea
            and id_materie = :new.id_materie;
        else
            delete from inventar_cafenea_bucuresti@bd_bucuresti
            where id_cafenea = :old.id_cafenea
            and id_materie = :old.id_materie;
        end if;
    else
        if updating then
            update inventar_cafenea_provincie@bd_provincie
            set cantitate = :new.cantitate
            where id_cafenea = :new.id_cafenea
            and id_materie = :new.id_materie;
        else
            delete from inventar_cafenea_provincie@bd_provincie
            where id_cafenea = :old.id_cafenea
            and id_materie = :old.id_materie;
        end if;
    end if;
end;
/

create or replace TRIGGER "T_INSERT_COMENZI_CLIENTI_GLOBAL" instead of insert on comenzi_clienti_global
for each row
declare
    nr_comenzi_clienti_aceeasi_pk_bucuresti number default 0;
    nr_comenzi_clienti_aceeasi_pk_provincie number default 0;
    v_nume_regiune regiuni_global.nume%type;
begin
    -- constrangere de PK pentru id_comanda_client
    select count(*) into nr_comenzi_clienti_aceeasi_pk_bucuresti
    from   comanda_client_bucuresti@bd_bucuresti
    where   id_comanda_client = :new.id_comanda_client;

    if (nr_comenzi_clienti_aceeasi_pk_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_client_bucuresti contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client);
    end if;

    select count(*) into nr_comenzi_clienti_aceeasi_pk_provincie
    from   comanda_client_provincie@bd_provincie
    where   id_comanda_client = :new.id_comanda_client;

    if (nr_comenzi_clienti_aceeasi_pk_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_produs_provincie contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client);
    end if;

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
        values (seq_comanda_client_buc.nextval@bd_bucuresti, :new.id_client, :new.id_cafenea, :new.data_plasarii);
    else
        dbms_output.put_line('Inserez in tabelul COMANDA_CLIENT_PROVINCIE...'); 
        insert into comanda_client_provincie@bd_provincie (id_comanda_client, id_client, id_cafenea, data_plasarii)
        values (seq_comanda_client_prov.nextval@bd_provincie, :new.id_client, :new.id_cafenea, :new.data_plasarii);
    end if;
end;
/

create or replace TRIGGER "T_INSERT_COMENZI_PRODUSE_GLOBAL" 
instead of insert on comenzi_produse_global
for each row
declare
    nr_comenzi_produse_aceeasi_pk_bucuresti number default 0;
    nr_comenzi_produse_aceeasi_pk_provincie number default 0;
    v_nume_regiune regiuni_global.nume%type;
begin
    -- verific constrangerea de PK pentru combinatia de coloane (id_comanda_client, id_produs)
    select count(*) into nr_comenzi_produse_aceeasi_pk_bucuresti
    from   comanda_produs_bucuresti@bd_bucuresti
    where   id_comanda_client = :new.id_comanda_client
    and     id_produs = :new.id_produs;

    if (nr_comenzi_produse_aceeasi_pk_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_produs_bucuresti contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client || ', id_produs = ' || :new.id_produs);
    end if;

    select count(*) into nr_comenzi_produse_aceeasi_pk_provincie
    from   comanda_produs_provincie@bd_provincie
    where   id_comanda_client = :new.id_comanda_client
    and     id_produs = :new.id_produs;

    if (nr_comenzi_produse_aceeasi_pk_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul comanda_produs_provincie contine aceeasi cheie primara id_comanda_client = ' || :new.id_comanda_client || ', id_produs = ' || :new.id_produs);
    end if;
    
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

-- pentru vizualizarile COMENZI_PRODUSE_GLOBAL si COMENZI_CLIENTI_GLOBAL
-- nu voi mai crea trigger-e pentru update si delete
-- deoarece nu am nevoie de ele in aplicatie