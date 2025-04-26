-- RAPORTUL DE ANALIZA

-- ex. 8 b)

-- cheie primara la nivel local
alter table produs_bucuresti
add primary key (id_produs);
/
alter table materie_prima_bucuresti
add primary key (id_materie);
/

-- cheie primara la nivel global