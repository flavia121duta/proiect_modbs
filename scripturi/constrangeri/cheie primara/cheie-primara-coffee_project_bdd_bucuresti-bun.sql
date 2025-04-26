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