-- ex. 8 d)
alter table inventar_cafenea_provincie
add constraint ck_cantitate_inventar_cafenea_prov check (cantitate >= 0);
/
-- pretul unui produs trebuie sa fie strict pozitiv
alter table comanda_produs_provincie
add constraint ck_pret_final_comanda_produs_prov check (pret_final > 0);
/
-- cantitate de produse comandate trebuie sa fie strict pozitiva
alter table comanda_produs_provincie
add constraint ck_cantitate_comanda_produs_prov check (cantitate > 0);
/
-- data plasarii unei comenzi nu poate fi dupa data curenta
create or replace trigger t_ck_comanda_client_prov_data_plasarii
before insert or update on comanda_client_provincie
for each row
begin
    if :new.data_plasarii > sysdate then
        raise_application_error(-20002, 'Data plasari nu poate fi in viitor.');
    end if;
end;
/
-- pot sa sterg o inregistrare din inventar_cafenea_provincie
-- doar daca cantitatea sa este 0
create or replace trigger t_delete_inventar_cafenea_prov
before delete on inventar_cafenea_provincie
for each row
begin
    if :old.cantitate > 0 then
        raise_application_error(-20003, 'Nu se poate sterge un produs din inventar decat daca cantitatea sa este 0.');
    end if;
end;