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