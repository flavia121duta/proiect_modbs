-- RAPORTUL DE ANALIZA

-- ex. 8 a) i.
-- unicitate locala
-- ma conectez la coffee_project_bdd_provincie

-- aplic constrangerea de unicitate locala pentru 
-- combinatia de coloane (denumire_dimenziune) din PRODUS_PROVINCIE
alter table produs_provincie
add constraint u_produs_denumire_dimensiune unique(denumire, dimensiune);
/
-- aplic constrangerea de unicitate locala pentru 
-- coloana nume_materie din MATERIE_PRIMA_PROVINCIE
alter table materie_prima_provincie
add constraint u_materie_prima_nume_materie unique(nume_materie);
/
-- aplic constrangerea de unicitate locala pentru 
-- combinatia de coloane (nume, prenume, id_cafenea) din ANGAJAT_PROVINCIE
alter table angajat_provincie
add constraint u_angajat_nume_prenume_id_cafenea unique(nume, prenume, id_cafenea);

-- ex. 8 a) ii.
-- unicitate globala pe fragmente orizontale

-- aplic constrangerea de unicitate pentru coloana nume din REGIUNE_PROVINCIE
alter table regiune_provincie
add constraint u_nume_regiune unique(nume);
/
-- aplic constrangerea de unicitate pentru coloana nume din JUDET_PROVINCIE
alter table judet_provincie
add constraint u_nume_judet unique(nume);
/
-- aplic constrangerea de unicitate pentru coloana nume din ORAS_PROVINCIE
alter table oras_provincie
add constraint u_nume_oras unique(nume);
/
-- aplic constrangerea de unicitate pentru coloana nume_cafenea din CAFENEA_PROVINCIE
alter table cafenea_provincie
add constraint u_nume_cafenea unique(nume_cafenea);
/

-- in bd_provincie creez urmatorul link pentru a accesa datele din global
CREATE PUBLIC DATABASE LINK bd_global
  CONNECT TO user_global
  IDENTIFIED BY Admin#DB1
USING '(DESCRIPTION=
            (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
            (CONNECT_DATA=(SERVICE_NAME=homedb1))
          )';
/

-- ex. 8 a) iii.
-- unicitate globala pentru combinatie de coloane din fragmente verticale diferite

-- analog ca atunci cand am creat trigger in schema de Bucuresti

CREATE OR REPLACE TRIGGER trg_check_unicitate_angajat_provincie
BEFORE INSERT OR UPDATE ON angajat_provincie
FOR EACH ROW
DECLARE
    v_salariu number;
    v_data_angajarii date;
    v_conflict_count integer;
BEGIN
  -- extrag salariul si data_angajarii din global
  select salariu, data_angajarii
  into v_salariu, v_data_angajarii
  from angajat@bd_global
  where id_angajat = :new.id_angajat;

    -- verific daca exista alt angajat cu aceeasi combinatie de
    -- id_cafenea, salariu, data_angajarii
    select count(*) 
    into v_conflict_count
    from (
        select id_angajat, to_number(id_cafenea) id_cafenea from angajat_bucuresti@bd_bucuresti
        union all
        select id_angajat, id_cafenea from angajat_provincie
    ) fr_orizontale
    join angajat@bd_global ag on fr_orizontale.id_angajat = ag.id_angajat
    where fr_orizontale.id_cafenea = :new.id_cafenea
        and ag.salariu = v_salariu
        and ag.data_angajarii = v_data_angajarii
        and ag.id_angajat != :new.id_angajat;

    if v_conflict_count > 0 then
        RAISE_APPLICATION_ERROR(-20001, 'Exista deja un angajat cu aceleasi nume, prenume si salariu!');
    end if;
END;
/
select * from cafenea_provincie;
/
insert into angajat_provincie(id_angajat, nume, prenume, id_cafenea)
values (1003, 'Maria', 'Ionescu', 2);
/
-- aici se va activa trigger-ul TRG_CHECK_UNICITATE_ANGAJAT_BUCURESTI
insert into angajat_provincie(id_angajat, nume, prenume, id_cafenea)
values (1004, 'Crina', 'Sevastre', 2);
/
-- dar daca incerc sa inserez in alta cafenea, atunci voi putea insera
insert into angajat_provincie(id_angajat, nume, prenume, id_cafenea)
values (1004, 'Crina', 'Sevastre', 3);
/
select * from angajat_provincie;