-- ma conectez la schema coffee_project_bdd_bucuresti

-- tabela PRODUS trebuie sa se gaseasca in ambele scheme: bdd_bucuresti si bdd_provincie
-- facem replicare
create table produs_bucuresti as
select *
from produs@bd_all;
/

-- tabela MATERIE_PRIMA trebuie sa se gaseasca in ambele scheme
-- bdd_bucuresti si bdd_provincie
-- facem replicare
create table materie_prima_bucuresti as
select *
from materie_prima@bd_all;

/

-- tabela PRODUS_MATERIE_PRIMA trebuie sa se gaseasca in ambele scheme
-- bdd_bucuresti si bdd_provincie
-- facem replicare
create table produs_materie_prima_bucuresti as
select *
from produs_materie_prima@bd_all;