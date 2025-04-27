grant select, insert, update, delete on oras_bucuresti to user_global;
grant all on angajat_bucuresti to user_global;
grant all on cafenea_bucuresti to user_global;
grant all on client_bucuresti to user_global;
grant all on comanda_client_bucuresti to user_global;
grant all on comanda_produs_bucuresti to user_global;
grant all on inventar_cafenea_bucuresti to user_global;
grant all on judet_bucuresti to user_global;
grant all on locatie_bucuresti to user_global;
grant all on materie_prima_bucuresti to user_global;
grant all on produs_bucuresti to user_global;
grant all on regiune_bucuresti to user_global;
/
-- nu merge: grant select, insert, update, delete on user_global to user_bd;
grant all on angajat to user_bd;
grant all on client to user_bd;
grant all on user_tab_columns to user_bd;
