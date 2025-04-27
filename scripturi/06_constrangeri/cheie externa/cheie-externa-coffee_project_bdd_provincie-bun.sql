-- ex. 8 c)

-- validare la nivel local

alter table judet_provincie
add foreign key (id_regiune) references regiune_provincie (id_regiune);

alter table oras_provincie
add foreign key (id_judet) references judet_provincie (id_judet);

alter table locatie_provincie
add foreign key (id_oras) references oras_provincie (id_oras);

alter table cafenea_provincie
add foreign key (id_locatie) references locatie_provincie (id_locatie);

alter table angajat_provincie
add foreign key (id_cafenea) references cafenea_provincie (id_cafenea);

alter table inventar_cafenea_provincie
add foreign key (id_cafenea) references cafenea_provincie (id_cafenea);

alter table comanda_client_provincie
add foreign key (id_cafenea) references cafenea_provincie (id_cafenea);

alter table comanda_client_provincie
add foreign key (id_client) references client_provincie (id_client);

alter table comanda_produs_provincie
add foreign key (id_comanda_client) references comanda_client_provincie (id_comanda_client);