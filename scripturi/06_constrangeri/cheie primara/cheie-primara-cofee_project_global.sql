-- ex. 8 b)
-- trigger care asigura constrangerea de PK pentru id_regiune
-- din fragmentele REGIUNE_BUCURESTI si REGIUNE_PROVINCIE
create or replace trigger t_pk_id_regiuni
instead of insert on regiuni_global
for each row
declare
    nr_regiuni_acelasi_id_bucuresti number default 0;
    nr_regiuni_acelasi_id_provincie number default 0;
begin
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
end;
/
-- testez trigger-ul t_pk_id_regiuni

-- se intoarce o eroare, ptc incerc ca inserez o regiune noua cu un id_regiune existent
insert into regiuni_global (id_regiune, nume)
values (1, 'Bucuresti');

-- dar aceasta noua inregistrare va functiona
-- pentru ca inca nu exista o regiune cu id-ul 9
insert into regiuni_global (id_regiune, nume)
values (9, 'Moldova');
select * from regiune_bucuresti@bd_bucuresti;
select * from regiune_provincie@bd_provincie;
/

-- trigger care asigura constrangerea de PK pentru id_judet
-- din fragmentele JUDET_BUCURESTI si JUDET_PROVINCIE
create or replace trigger t_pk_id_judete
instead of insert on judete_global
for each row
declare
    nr_judete_acelasi_id_bucuresti number default 0;
    nr_judete_acelasi_id_provincie number default 0;
begin
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
end;
/
-- trigger care asigura constrangerea de PK pentru id_oras
-- din fragmentele ORAS_BUCURESTI si ORAS_PROVINCIE
create or replace trigger t_pk_id_orase
instead of insert on orase_global
for each row
declare
    nr_orase_acelasi_id_bucuresti number default 0;
    nr_orase_acelasi_id_provincie number default 0;
begin
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
end;
/
-- trigger care asigura constrangerea de PK pentru id_locatie
-- din fragmentele LOCATIE_BUCURESTI si LOCATIE_PROVINCIE
create or replace trigger t_pk_id_locatii
instead of insert on locatii_global
for each row
declare
    nr_locatii_acelasi_id_bucuresti number default 0;
    nr_locatii_acelasi_id_provincie number default 0;
begin
    select count(*) into nr_locatii_acelasi_id_bucuresti
    from   locatie_bucuresti@bd_bucuresti
    where  id_locatie = :new.id_locatie;
    
    if (nr_locatii_acelasi_id_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul locatie_bucuresti contine aceeasi cheie primara id_locatie = ' || :new.id_locatie);
    end if;
    
    select count(*) into nr_locatii_acelasi_id_provincie
    from   locatie_provincie@bd_provincie
    where  id_locatie = :new.id_locatie;
    
    if (nr_locatii_acelasi_id_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul locatie_provincie contine aceeasi cheie primara id_locatie = ' || :new.id_locatie);
    end if;
end;
/
-- trigger care asigura constrangerea de PK pentru id_cafenea
-- din fragmentele CAFENEA_BUCURESTI si CAFENEA_PROVINCIE
create or replace trigger t_pk_id_cafenele
instead of insert on cafenele_global
for each row
declare
    nr_cafenele_acelasi_id_bucuresti number default 0;
    nr_cafenele_acelasi_id_provincie number default 0;
begin
    select count(*) into nr_cafenele_acelasi_id_bucuresti
    from   cafenea_bucuresti@bd_bucuresti
    where  id_cafenea = :new.id_cafenea;
    
    if (nr_cafenele_acelasi_id_bucuresti > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul cafenea_bucuresti contine aceeasi cheie primara id_locatie = ' || :new.id_cafenea);
    end if;
    
    select count(*) into nr_cafenele_acelasi_id_provincie
    from   cafenea_provincie@bd_provincie
    where  id_cafenea = :new.id_cafenea;
    
    if (nr_cafenele_acelasi_id_provincie > 0) then 
        raise_application_error (-20001,'Constrangere de cheie primara incalcata. Fragmentul cafenea_provincie contine aceeasi cheie primara id_locatie = ' || :new.id_locatie);
    end if;
end;
/
-- trigger care asigura constrangerea de PK pentru (i_cafenea, id_materie)
-- din fragmentele INVENTAR_CAFENEA_BUCURESTI si INVENTAR_CAFENEA_PROVINCIE
create or replace trigger t_pk_id_inventare_cafenele
instead of insert on inventare_cafenele_global
for each row
declare
    nr_inventare_aceeasi_pk_bucuresti number default 0;
    nr_inventare_aceeasi_pk_provincie number default 0;
begin
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
end;
/
-- pentru a asigura constrangerea de pk pentru comenzi_clienti_global
-- voi folosi niste secvente locale definite in bdd_bucuresti si bdd_provincie
select * from comenzi_clienti_global order by id_comanda_client desc;

-- verific daca pot folosi o secventa distanta
select seq_comanda_client_buc.nextval@bd_bucuresti from dual;

-- inserez o noua valoare intr-o cafenea din Bucuresti
insert into comenzi_clienti_global (id_client, id_cafenea, data_plasarii)
values (3, 1, '26-APR-2025');

-- verific daca s-a inserat
select * from comanda_client_bucuresti@bd_bucuresti order by id_comanda_client desc;
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
end;
/
-- trigger care asigura constrangerea de PK pentru (id_comanda_client, id_produs)
-- din fragmentele COMANDA_PRODUS_BUCURESTI si COMANDA_PRODUS_PROVINCIE
create or replace trigger t_pk_id_comenzi_produse
instead of insert on comenzi_produse_global
for each row
declare
    nr_comenzi_produse_aceeasi_pk_bucuresti number default 0;
    nr_comenzi_produse_aceeasi_pk_provincie number default 0;
begin
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
end;
/
-- trigger care asigura constrangerea de PK pentru id_angajat
-- din fragmentele ANGAJAT_BUCURESTI, ANGAJAT_PROVINCIE
create or replace trigger t_pk_id_angajati
instead of insert on angajati_global
for each row
declare
    nr_clienti_aceeasi_pk_bucuresti number default 0;
    nr_clienti_aceeasi_pk_provincie number default 0;
begin
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
end;
/