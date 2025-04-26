-- ex. 8 c)
alter table produs_materie_prima
add foreign key id_produs references produs (id_produs);

alter table produs_materie_prima
add foreign key id_materie references materie_prima (id_materie);
/