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
-- ex. 8 a) ii.

-- combinatia nume_prenume_id_cafenea este unica
create or replace TRIGGER "T_CK_NUME_PRENUME_ID_CAFENEA_ANGAJATI_GLOBAL" 
instead of insert or update on angajati_global
for each row
declare
    nr_angajati_aceeasi_combinatie_atribute_bucuresti number default 0;
    nr_angajati_aceeasi_combinatie_atribute_provincie number default 0;
begin
    select count(*) into nr_angajati_aceeasi_combinatie_atribute_bucuresti
    from   angajat_bucuresti@bd_bucuresti
    where   nume = coalesce(:new.nume, :old.nume)
    and prenume = coalesce(:new.prenume, :new.prenume)
    and id_cafenea = coalesce(:new.id_cafenea, :new.id_cafenea);

    if (nr_angajati_aceeasi_combinatie_atribute_bucuresti > 0) then 
        raise_application_error (-20001,'Validare globala incalcata. Fragmentul angajat_bucuresti contine o inregistrare cu aceeasi combinatie de nume, prenume, id_cafenea');
    end if;

    select count(*) into nr_angajati_aceeasi_combinatie_atribute_provincie
    from   angajat_provincie@bd_provincie
    where   nume = coalesce(:new.nume, :old.nume)
    and prenume = coalesce(:new.prenume, :new.prenume)
    and id_cafenea = coalesce(:new.id_cafenea, :new.id_cafenea);

    if (nr_angajati_aceeasi_combinatie_atribute_provincie > 0) then 
        raise_application_error (-20001,'Validare globala incalcata. Fragmentul angajat_provincie contine o inregistrare cu aceeasi combinatie de nume, prenume, id_cafenea');
    end if;
end;
/
-- nume din REGIUNE este unic
create or replace TRIGGER t_ck_nume_regiune
instead of insert or update on regiuni_global
for each row
declare
    nr_regiuni_acelasi_nume_bucuresti number default 0;
    nr_regiuni_acelasi_nume_provincie number default 0;
begin
    select count(*) into nr_regiuni_acelasi_nume_bucuresti
    from   regiune_bucuresti@bd_bucuresti
    where   nume = :new.nume;

    if (nr_regiuni_acelasi_nume_bucuresti > 0) then 
        raise_application_error (-20001,'Validare globala incalcata. Fragmentul regiune_bucuresti contine o inregistrare cu acelasi nume.');
    end if;

    select count(*) into nr_regiuni_acelasi_nume_provincie
    from   regiune_provincie@bd_provincie
    where   nume = :new.nume;

    if (nr_regiuni_acelasi_nume_provincie > 0) then 
            raise_application_error (-20001,'Validare globala incalcata. Fragmentul regiune_provincie contine o inregistrare cu acelasi nume.');
    end if;
end;
/
-- nume din JUDET este unic
create or replace TRIGGER t_ck_nume_judete
instead of insert or update on judete_global
for each row
declare
    nr_judete_acelasi_nume_bucuresti number default 0;
    nr_judete_acelasi_nume_provincie number default 0;
begin
    select count(*) into nr_judete_acelasi_nume_bucuresti
    from   judet_bucuresti@bd_bucuresti
    where   nume = :new.nume;

    if (nr_judete_acelasi_nume_bucuresti > 0) then 
        raise_application_error (-20001,'Validare globala incalcata. Fragmentul judet_bucuresti contine o inregistrare cu acelasi nume.');
    end if;

    select count(*) into nr_judete_acelasi_nume_provincie
    from   judet_provincie@bd_provincie
    where   nume = :new.nume;

    if (nr_judete_acelasi_nume_provincie > 0) then 
            raise_application_error (-20001,'Validare globala incalcata. Fragmentul judet_provincie contine o inregistrare cu acelasi nume.');
    end if;
end;
/
-- nume din ORAS este unic
create or replace TRIGGER t_ck_nume_orase
instead of insert or update on orase_global
for each row
declare
    nr_orase_acelasi_nume_bucuresti number default 0;
    nr_orase_acelasi_nume_provincie number default 0;
begin
    select count(*) into nr_orase_acelasi_nume_bucuresti
    from   oras_bucuresti@bd_bucuresti
    where   nume = :new.nume;

    if (nr_orase_acelasi_nume_bucuresti > 0) then 
        raise_application_error (-20001,'Validare globala incalcata. Fragmentul oras_bucuresti contine o inregistrare cu acelasi nume.');
    end if;

    select count(*) into nr_orase_acelasi_nume_provincie
    from   oras_provincie@bd_provincie
    where   nume = :new.nume;

    if (nr_orase_acelasi_nume_provincie > 0) then 
            raise_application_error (-20001,'Validare globala incalcata. Fragmentul oras_provincie contine o inregistrare cu acelasi nume.');
    end if;
end;
/
-- nume_cafenea din CAFENEA este unic
create or replace TRIGGER t_ck_nume_cafenea
instead of insert or update on cafenele_global
for each row
declare
    nr_cafenele_acelasi_nume_bucuresti number default 0;
    nr_cafenele_acelasi_nume_provincie number default 0;
begin
    select count(*) into nr_cafenele_acelasi_nume_bucuresti
    from   cafenea_bucuresti@bd_bucuresti
    where   nume_cafenea = :new.nume_cafenea;

    if (nr_cafenele_acelasi_nume_bucuresti > 0) then 
        raise_application_error (-20001,'Validare globala incalcata. Fragmentul cafenea_bucuresti contine o inregistrare cu acelasi nume.');
    end if;

    select count(*) into nr_cafenele_acelasi_nume_provincie
    from   cafenea_provincie@bd_provincie
    where   nume_cafenea = :new.nume_cafenea;

    if (nr_cafenele_acelasi_nume_provincie > 0) then 
            raise_application_error (-20001,'Validare globala incalcata. Fragmentul cafenea_provincie contine o inregistrare cu acelasi nume.');
    end if;
end;

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