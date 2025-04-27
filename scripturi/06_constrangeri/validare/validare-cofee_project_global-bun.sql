-- ex. 8 d)

-- validare la nivel local

-- salariul unui angajat trebuie sa fie strict pozitiv
alter table angajat
add constraint ck_angajat_salariu check (salariu > 0);
/
-- data angajarii nu poate fi dupa data curenta
create or replace trigger t_ck_angajat_data_angajarii
before insert or update on angajat
for each row
begin
    if :new.data_angajarii > sysdate then
        raise_application_error(-20002, 'Data angajarii nu poate fi in viitor.');
    end if;
end;
/
-- pretul unui produs trebuie sa fie strict pozitiv
alter table produs
add constraint ck_pret_produs check (pret > 0);