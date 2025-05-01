-- RAPORTUL DE ANALIZA

-- ex. 8 a) i.
-- unicitate locala
-- ma conectez la coffee_project_bdd_bucuresti

-- aplic constrangerea de unicitate locala pentru 
-- combinatia de coloane (nume, prenume, id_cafenea) din ANGAJAT_BUCURESTI
alter table angajat_bucuresti
add constraint u_angajat_nume_prenume_id_cafenea unique(nume, prenume, id_cafenea);
/
-- aplic constrangerea de unicitate pentru coloana nume din REGIUNE_BUCURESTI
alter table regiune_bucuresti
add constraint u_nume_regiune unique(nume);
/
-- aplic constrangerea de unicitate pentru coloana nume din JUDET_BUCURESTI
alter table judet_bucuresti
add constraint u_nume_judet unique(nume);
/
-- aplic constrangerea de unicitate pentru coloana nume din ORAS_BUCURESTI
alter table oras_bucuresti
add constraint u_nume_oras unique(nume);
/
-- aplic constrangerea de unicitate pentru coloana nume_cafenea din CAFENEA_BUCURESTI
alter table cafenea_bucuresti
add constraint u_nume_cafenea unique(nume_cafenea);

/
-- ex. 8 a) iii.
-- unicitate globala pentru combinatie de coloane din fragmente verticale diferite

create or replace TRIGGER trg_check_unicitate_angajat_bucuresti
BEFORE INSERT OR UPDATE ON ANGAJAT_BUCURESTI
FOR EACH ROW
DECLARE
    v_salariu user_global.angajat.salariu%TYPE;
    v_data_angajarii user_global.angajat.data_angajarii%TYPE;
    v_conflict_count integer;
BEGIN
  -- extrag salariul si data_angajarii din global
  select salariu, data_angajarii
  into v_salariu, v_data_angajarii
  from user_global.angajat
  where id_angajat = :new.id_angajat;

    -- verific daca exista alt angajat in provincie cu aceeasi combinatie
    -- de nume_prenume_salariu_salariu_data_angajarii
    select count(*)
    into v_conflict_count
    from angajat_provincie@bd_provincie ap
    join user_global.angajat ag on ap.id_angajat = ag.id_angajat
    where ap.id_cafenea = to_char(:new.id_cafenea)
        and ag.salariu = v_salariu
        and ag.data_angajarii = v_data_angajarii
        and ag.id_angajat != :new.id_angajat;

    IF v_conflict_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista deja un angajat cu aceleasi nume, prenume si id_cafenea!');
    END IF;
END;
/
insert into angajat_bucuresti(id_angajat, nume, prenume, id_cafenea)
values (1001, 'Mihai', 'Popescu', 1);
/
-- aici se va activa trigger-ul TRG_CHECK_UNICITATE_ANGAJAT_BUCURESTI
insert into angajat_bucuresti(id_angajat, nume, prenume, id_cafenea)
values (1002, 'Irina', 'Popa', 1);
/
-- dar daca incerc sa inserez in alta cafenea, atunci voi putea insera
insert into angajat_bucuresti(id_angajat, nume, prenume, id_cafenea)
values (1002, 'Irina', 'Popa', 9);
/
select * from angajat_bucuresti;
/