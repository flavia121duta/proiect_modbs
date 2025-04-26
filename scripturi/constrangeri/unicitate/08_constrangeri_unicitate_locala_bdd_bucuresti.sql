-- RAPORTUL DE ANALIZA

-- ex. 8 a) i.
-- unicitate locala
-- ma conectez la coffee_project_bdd_bucuresti

-- aplic constrangerea de unicitate locala pentru 
-- combinatia de coloane (denumire_dimenziune) din PRODUS_BUCURESTI
alter table produs_bucuresti
add constraint u_produs_denumire_dimensiune unique(denumire, dimensiune);
/
-- aplic constrangerea de unicitate locala pentru 
-- coloana nume_materie din MATERIE_PRIMA_BUCURESTI
alter table materie_prima_bucuresti
add constraint u_materie_prima_nume_materie unique(nume_materie);
/
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

-- ex. 8 a) ii. ????


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
        RAISE_APPLICATION_ERROR(-20001, 'Exista deja un angajat cu aceleasi nume, prenume si salariu!');
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

-- ex. 8 b)
alter table regiune_bucuresti
add primary key (id_regiune);

alter table judet_bucuresti
add primary key (id_judet);

alter table oras_bucuresti
add primary key (id_oras);

alter table locatie_bucuresti
add primary key (id_locatie);

alter table cafenea_bucuresti
add primary key (id_cafenea);

alter table inventar_cafenea_bucuresti
add primary key (id_cafenea, id_materie);

alter table comanda_client_bucuresti
add primary key (id_comanda_client);

alter table comanda_produs_bucuresti
add primary key (id_comanda_client, id_produs);

alter table client_bucuresti
add primary key (id_client);

alter table angajat_bucuresti
add primary key (id_angajat);
/
select * from comanda_client_bucuresti@bd_bucuresti order by id_comanda_client desc;

-- creez o secventa locala care va fi folosita
-- de o procedura distanta pentru a face insert in fragmentul comanda_client_bucuresti
create sequence seq_comanda_client_buc
increment by 2
start with 100002
nocycle;

-- ex. 8 c)
alter table judet_bucuresti
add foreign key (id_regiune) references regiune_bucuresti (id_regiune);

alter table oras_bucuresti
add foreign key (id_judet) references judet_bucuresti (id_judet);

alter table locatie_bucuresti
add foreign key (id_oras) references oras_bucuresti (id_oras);

alter table cafenea_bucuresti
add foreign key (id_locatie) references locatie_bucuresti (id_locatie);

alter table angajat_bucuresti
add foreign key (id_cafenea) references cafenea_bucuresti (id_cafenea);

alter table inventar_cafenea_bucuresti
add foreign key (id_cafenea) references cafenea_bucuresti (id_cafenea);

alter table comanda_client_bucuresti
add foreign key (id_cafenea) references cafenea_bucuresti (id_cafenea);

alter table comanda_client_bucuresti
add foreign key (id_client) references client_bucuresti (id_client);

alter table comanda_produs_bucuresti
add foreign key (id_comanda_client) references comanda_client_bucuresti (id_comanda_client);
/

-- ex. 8 d)

-- validare la nivel local

alter table inventar_cafenea_bucuresti
add constraint ck_cantitate_inventar_cafenea_buc check (cantitate >= 0);
/
-- pretul unui produs trebuie sa fie strict pozitiv
alter table comanda_produs_bucuresti
add constraint ck_pret_final_comanda_produs_buc check (pret_final > 0);
/
-- cantitate de produse comandate trebuie sa fie strict pozitiva
alter table comanda_produs_bucuresti
add constraint ck_cantitate_comanda_produs_buc check (cantitate > 0);
/
-- data plasarii unei comenzi nu poate fi dupa data curenta
create or replace trigger t_ck_comanda_client_buc_data_plasarii
before insert or update on comanda_client_bucuresti
for each row
begin
    if :new.data_plasarii > sysdate then
        raise_application_error(-20002, 'Data plasari nu poate fi in viitor.');
    end if;
end;
/
-- pot sa sterg o inregistrare din inventar_cafenea_bucuresti
-- doar daca cantitatea sa este 0
create or replace trigger t_delete_inventar_cafenea_buc
before delete on inventar_cafenea_bucuresti
for each row
begin
    if :old.cantitate > 0 then
        raise_application_error(-20003, 'Nu se poate sterge un produs din inventar decat daca cantitatea sa este 0.');
    end if;
end;
/

-- validare pentru relatii stocate in baze de date diferite