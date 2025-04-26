-- RAPORTUL DE ANALIZA

-- ex. 8 b)

-- cheie primara la nivel local

create table PRODUS as 
select * from user_bd.produs_bucuresti;
/
create or replace trigger trg_insert_produs
before insert on produs
for each row
declare
    v_count_bucuresti integer;
    v_count_provincie integer;
begin
    -- verificam daca id_produs exista in produs_bucuresti
    select count(*) into v_count_bucuresti
    from user_bd.produs_bucuresti
    where id_produs = :new.id_produs;

    -- verificam daca id_produs exista in produs_provincie
    select count(*) into v_count_provincie
    from produs_provincie@bd_provincie
    where id_produs = :new.id_produs;

    -- daca produsul nu exista in niciuna dintre statii, il adaug
    if v_count_bucuresti = 0 and v_count_provincie = 0 then
        -- inserare in produs_bucuresti
        insert into user_bd.produs_bucuresti (id_produs, denumire, dimensiune, unitate_masura, pret)
        values (:new.id_produs, :new.denumire, :new.dimensiune, :new.unitate_masura, :new.pret);

        -- inserare in produs_provincie
        insert into produs_provincie@bd_provincie (id_produs, denumire, dimensiune, unitate_masura, pret)
        values (:new.id_produs, :new.denumire, :new.dimensiune, :new.unitate_masura, :new.pret);
    else
        -- daca exista deja produsul in oricare dintre statii, generam o eroare
        raise_application_error(-20001, 'produsul cu id_produs ' || :new.id_produs || ' exista deja pe una dintre statii.');
    end if;
end;
/

create table MATERIE_PRIMA as 
select * from user_bd.materie_prima_bucuresti;
/
select * from user_bd.materie_prima
/
create or replace trigger trg_insert_materie_prima
before insert on materie_prima
for each row
declare
    v_count_bucuresti integer;
    v_count_provincie integer;
begin
    -- verificam daca id_produs exista in materie_prima_bucuresti
    select count(*) 
    into v_count_bucuresti
    from user_bd.materie_prima_bucuresti
    where id_materie = :new.id_materie;

    -- verificam daca id_produs exista in materie_prima
    select count(*) 
    into v_count_provincie
    from materie_prima_provincie@bd_provincie
    where id_materie = :new.id_materie;

    -- daca materia_prima nu exista in niciuna dintre statii, il adaug
    if v_count_bucuresti = 0 and v_count_provincie = 0 then
        -- inserare in materie_prima_bucuresti
        insert into user_bd.materie_prima_bucuresti (id_materie, nume_materie, unitate_masura)
        values (:new.id_materie, :new.nume_materie, :new.unitate_masura);

        -- inserare in produs_provincie
        insert into materie_prima_provincie@bd_provincie (id_materie, nume_materie, unitate_masura)
        values (:new.id_materie, :new.nume_materie, :new.unitate_masura);
    else
        -- daca exista deja produsul in oricare dintre statii, generam o eroare
        raise_application_error(-20001, 'Materia prima cu id_materie ' || :new.id_materie || ' exista deja pe una dintre statii.');
    end if;
end;
/


-- cheie primara la nivel global