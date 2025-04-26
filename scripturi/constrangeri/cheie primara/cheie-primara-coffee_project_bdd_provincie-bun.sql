-- ex. 8 b)
alter table regiune_provincie
add primary key (id_regiune);

alter table judet_provincie
add primary key (id_judet);

alter table oras_provincie
add primary key (id_oras);

alter table locatie_provincie
add primary key (id_locatie);

alter table cafenea_provincie
add primary key (id_cafenea);

alter table inventar_cafenea_provincie
add primary key (id_cafenea, id_materie);

alter table comanda_client_provincie
add primary key (id_comanda_client);

alter table comanda_produs_provincie
add primary key (id_comanda_client, id_produs);

alter table client_provincie
add primary key (id_client);

alter table angajat_provincie
add primary key (id_angajat);

/
-- creez o secventa locala care va fi folosita
-- de o procedura distanta pentru a face insert in fragmentul comanda_client_provincie
create sequence seq_comanda_client_prov
increment by 2
start with 100003
nocycle;