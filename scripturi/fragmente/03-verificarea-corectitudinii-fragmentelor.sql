-- RAPORTUL DE ANALIZA
-- ex. 5
-- verificarea corectitudinii fragmentarilor realizate

-- tabela REGIUNE: fragmentare orizontala primara

-- COMPLETITUDINEA
-- REGIUNE_ALL \ (REGIUNE_BUCURESTI U REGIUNE_PROVINCIE) = multimea vida
select id_regiune, nume
from regiune@bd_all
minus
(
    select * from regiune_bucuresti
    union all
    select * from regiune_provincie@bd_provincie
);

/

-- RECONSTRUCTIA
-- doua multimi A si B sunt egale ddaca (A inclus in B) si (B inclus in A)

-- A inclus B
select id_regiune, nume
from regiune@bd_all
minus
(
    select * from regiune_bucuresti
    union all
    select * from regiune_provincie@bd_provincie
);

-- B inclus A
(
    select * from regiune_bucuresti
    union all
    select * from regiune_provincie@bd_provincie
)
minus
select id_regiune, nume
from regiune@bd_all;

/

-- DISJUNCTIA
-- REGIUNE_BUCURESTI ∩ REGIUNE_PROVINCIE = multimea vida
select * from regiune_bucuresti
intersect
select * from regiune_provincie@bd_provincie;

/

-- tabela JUDET: fragmentare orizontala derivata

-- COMPLETITUDINEA
-- JUDET_ALL \ (JUDET_BUCURESTI U JUDET_PROVINCIE) = multimea vida
select id_judet, id_regiune, nume
from judet@bd_all
minus
(
    select * from judet_bucuresti
    union all
    select * from judet_provincie@bd_provincie
);

/

-- RECONSTRUCTIA
-- doua multimi A si B sunt egale ddaca (A inclus in B) si (B inclus in A) 

-- A inclus B
select id_judet, id_regiune, nume
from judet@bd_all
minus
(
    select * from judet_bucuresti
    union all
    select * from judet_provincie@bd_provincie
);

-- B inclus A
(
    select * from judet_bucuresti
    union all
    select * from judet_provincie@bd_provincie
)
minus
select id_judet, id_regiune, nume
from judet@bd_all;

/

-- DISJUNCTIA
-- JUDET_BUCURESTI ∩ JUDET_PROVINCIE = multimea vida
select * from judet_bucuresti
intersect
select * from judet_provincie@bd_provincie;

/

-- tabela ORAS: fragmentare orizontala derivata

-- COMPLETITUDINEA
-- ORAS_ALL \ (ORAS_BUCURESTI U ORAS_PROVINCIE) = multimea vida
select id_oras, id_judet, nume
from oras@bd_all
minus
(
    select * from oras_bucuresti
    union all
    select * from oras_provincie@bd_provincie
);

/

-- RECONSTRUCTIA
-- doua multimi A si B sunt egale ddaca (A inclus in B) si (B inclus in A) 

-- A inclus B
select id_oras, id_judet, nume
from oras@bd_all
minus
(
    select * from oras_bucuresti
    union all
    select * from oras_provincie@bd_provincie
);

-- B inclus A
(
    select * from oras_bucuresti
    union all
    select * from oras_provincie@bd_provincie
)
minus
select id_oras, id_judet, nume
from oras@bd_all;

/

-- DISJUNCTIA
-- ORAS_BUCURESTI ∩ ORAS_PROVINCIE = multimea vida
select * from oras_bucuresti
intersect
select * from oras_provincie@bd_provincie;

/

-- tabela LOCATIE: fragmentare orizontala derivata

-- COMPLETITUDINEA
-- LOCATIE_ALL \ (LOCATIE_BUCURESTI U LOCATIE_PROVINCIE) = multimea vida
select id_locatie, id_oras, strada, numar
from locatie@bd_all
minus
(
    select * from locatie_bucuresti
    union all
    select * from locatie_provincie@bd_provincie
);

/

-- RECONSTRUCTIA
-- doua multimi A si B sunt egale ddaca (A inclus in B) si (B inclus in A) 

-- A inclus B
select id_locatie, id_oras, strada, numar
from locatie@bd_all
minus
(
    select * from locatie_bucuresti
    union all
    select * from locatie_provincie@bd_provincie
);

-- B inclus A
(
    select * from locatie_bucuresti
    union all
    select * from locatie_provincie@bd_provincie
)
minus
select id_locatie, id_oras, strada, numar
from locatie@bd_all;

/

-- DISJUNCTIA
-- BUCURESTI ∩ PROVINCIE = multimea vida
select * from locatie_bucuresti
intersect
select * from locatie_provincie@bd_provincie;

/


-- tabela CAFENEA: fragmentare orizontala derivata

-- completitudinea
-- CAFENEA_ALL \ (CAFENEA_BUCURESTI U CAFENEA_PROVINCIE) = multimea vida
select id_cafenea, id_locatie, nume_cafenea
from cafenea@bd_all
minus
(
    select * from cafenea_bucuresti
    union all
    select * from cafenea_provincie@bd_provincie
);

-- reconstructia
-- CAFENEA_ALL = CAFENEA_BUCURESTI U CAFENEA_PROVINCIE

-- A inclus in B
-- sau: A \ B diferit de multimea vida
select id_cafenea, id_locatie, nume_cafenea
from cafenea@bd_all
minus
(
    select * from cafenea_bucuresti
    union all
    select * from cafenea_provincie@bd_provincie
);

-- B inclus in A
(
    select * from cafenea_bucuresti
    union all
    select * from cafenea_provincie@bd_provincie
)
minus
select id_cafenea, id_locatie, nume_cafenea
from cafenea@bd_all;

-- disjunctia
-- CAFENEA_BUCURESTI ∩ CAFENEA_PROVINCIE = multimea vida
select * from cafenea_bucuresti
intersect
select * from cafenea_provincie@bd_provincie;

/
-- tabela COMANDA_CLIENT: fragmentare orizontala derivata

-- COMPLETITUDINEA
-- COMANDA_CLIENT_ALL \ (COMANDA_CLIENT_BUCURESTI U COMANDA_CLIENT_PROVINCIE) = multimea vida
select id_comanda_client, id_client, id_cafenea, data_plasarii
from comanda_client@bd_all
minus
(
    select * from comanda_client_bucuresti
    union all
    select * from comanda_client_provincie@bd_provincie
);
/
-- RECONSTRUCTIA
-- (A inclus B) si (B inclus A) rezulta A = B

-- A inclus B
select id_comanda_client, id_client, id_cafenea, data_plasarii
from comanda_client@bd_all
minus
(
    select * from comanda_client_bucuresti
    union all
    select * from comanda_client_provincie@bd_provincie
);

-- B inclus A
(
    select * from comanda_client_bucuresti
    union all
    select * from comanda_client_provincie@bd_provincie
)
minus
select id_comanda_client, id_client, id_cafenea, data_plasarii
from comanda_client@bd_all;

/
-- DISJUNCTIA
-- COMANDA_CLIENT_BUCURESTI ∩ COMANDA_CLIENT_PROVINCIE = multimea vida
select * from comanda_client_bucuresti
intersect
select * from comanda_client_provincie@bd_provincie;

/

-- tabela COMANDA_PRODUS: fragmentare orizontala derivata

-- COMPLETITUDINEA
-- COMANDA_PRODUS_ALL \ (COMANDA_PRODUS_BUCURESTI U COMANDA_PRODUS_PROVINCIE) = multimea vida
select id_comanda_client, id_produs, cantitate, pret_final
from comanda_produs@bd_all
minus
(
    select * from comanda_produs_bucuresti
    union all
    select * from comanda_produs_provincie@bd_provincie
);
/
-- RECONSTRUCTIA
-- doua multimi A si B sunt egale ddaca (A inclus in B) si (B inclus in A) 

-- A inclus B
select id_comanda_client, id_produs, cantitate, pret_final
from comanda_produs@bd_all
minus
(
    select * from comanda_produs_bucuresti
    union all
    select * from comanda_produs_provincie@bd_provincie
);

-- B inclus A
(
    select * from comanda_produs_bucuresti
    union all
    select * from comanda_produs_provincie@bd_provincie
)
minus
select id_comanda_client, id_produs, cantitate, pret_final
from comanda_produs@bd_all;
/
-- DISJUNCTIA
-- COMANDA_PRODUS_BUCURESTI ∩ COMANDA_PRODUS_PROVINCIE = multimea vida
select * from comanda_produs_bucuresti
intersect
select * from comanda_produs_provincie@bd_provincie;
/

-- tabela INVENTAR_CAFENEA: fragmentare orizontala derivata

-- COMPLETITUDINEA
-- INVENTAR_CAFENEA_ALL \ (INVENTAR_CAFENEA_BUCURESTI U INVENTAR_CAFENEA_PROVINCIE) = multimea vida
select id_cafenea, id_materie, cantitate
from inventar_cafenea@bd_all
minus
(
    select * from inventar_cafenea_bucuresti
    union all
    select * from inventar_cafenea_provincie@bd_provincie
);
/

-- RECONSTRUCTIA
-- doua multimi A si B sunt egale ddaca (A inclus in B) si (B inclus in A) 

-- A inclus B
select id_cafenea, id_materie, cantitate
from inventar_cafenea@bd_all
minus
(
    select * from inventar_cafenea_bucuresti
    union all
    select * from inventar_cafenea_provincie@bd_provincie
);

-- B inclus A
(
    select * from inventar_cafenea_bucuresti
    union all
    select * from inventar_cafenea_provincie@bd_provincie
)
minus
select id_cafenea, id_materie, cantitate
from inventar_cafenea@bd_all;
/

-- DISJUNCTIA
-- INVENTAR_CAFENEA_BUCURESTI ∩ INVENTAR_CAFENEA_PROVINCIE = multimea vida
select * from inventar_cafenea_bucuresti
intersect
select * from inventar_cafenea_provincie@bd_provincie;
/

-- lab. 2, ex. 3 pentru cele doua tabele fragmentate vertical:
-- ANGAJAT
-- CLIENT


-- tabela ANGAJAT: fragmentare verticala

-- RECONSTRUCTIA

-- 1000 angajati
select ab.id_angajat, ab.nume, ab.prenume, to_char(ab.id_cafenea) id_cafenea,
        ag.salariu, ag.data_angajarii
from   angajat_bucuresti ab
join   user_global.angajat ag
on     ab.id_angajat = ag.id_angajat
union all
select ap.id_angajat, ap.nume, ap.prenume, to_char(ap.id_cafenea) id_cafenea,
        ag.salariu, ag.data_angajarii
from   angajat_provincie@bd_provincie ap
join   user_global.angajat ag
on     ap.id_angajat = ag.id_angajat;

/

-- COMPLETITUDINEA

-- obtin multimea vida
(
    select id_angajat, nume, prenume, to_char(id_cafenea) id_cafenea, 
    salariu, data_angajarii
    from angajat@bd_all
)
minus
(
    select ab.id_angajat, ab.nume, ab.prenume, to_char(ab.id_cafenea),
           ag.salariu, ag.data_angajarii
    from   angajat_bucuresti ab
    join   user_global.angajat ag
    on     ab.id_angajat = ag.id_angajat
    union all
    select ap.id_angajat, ap.nume, ap.prenume, to_char(ap.id_cafenea),
           ag.salariu, ag.data_angajarii
    from   angajat_provincie@bd_provincie ap
    join   user_global.angajat ag
    on     ap.id_angajat = ag.id_angajat
);

/

-- DISJUNCTIA

-- nu exista coloane comune
select column_name
from   all_tab_columns
where   owner = 'USER_GLOBAL'           -- dau numele efectiv al utilizatorului in clar
        and  table_name = upper('ANGAJAT')
        and  column_name <> 'ID_ANGAJAT'
intersect
(
select column_name
from   user_tab_columns
where   table_name = upper('ANGAJAT_BUCURESTI')
        and  column_name <> 'ID_ANGAJAT'
union
select column_name
from   user_tab_columns@bd_provincie
where   table_name = upper('ANGAJAT_PROVINCIE')
        and  column_name <> 'ID_ANGAJAT'
);

/

-- tabela CLIENT: fragmentare verticala

-- RECONSTRUCTIA
-- folosing client_bucuresti si client (global)
select cb.id_client, cb.nume, cb.prenume, cg.email, cg.parola
from   client_bucuresti cb
join   user_global.client cg
on     cb.id_client = cg.id_client

/

-- folosing client_provincie si client (global)
select cp.id_client, cp.nume, cp.prenume, cg.email, cg.parola
from   client_provincie@bd_provincie cp
join   user_global.client cg
on     cp.id_client = cg.id_client;

/

-- COMPLETITUDINEA

-- folosing client_bucuresti si client (global)
select *
from   client@bd_all
minus
(
select a.id_client, a.nume, a.prenume,
       b.email, b.parola
from   client_bucuresti a
join   user_global.client b
on     a.id_client = b.id_client
);

/

-- folosing client_provincie si client (global)
select *
from   client@bd_all
minus
(
select a.id_client, a.nume, a.prenume,
       b.email, b.parola
from   client_provincie@bd_provincie a
join   user_global.client b
on     a.id_client = b.id_client
);

/

-- DISJUNCTIA

-- folosing client_bucuresti si client (global)
select column_name
from   user_tab_columns
where   table_name = upper('CLIENT_BUCURESTI')
        and  column_name <> 'ID_CLIENT'
intersect
select column_name
from   all_tab_columns
where   owner = 'USER_GLOBAL'
        and  table_name = upper('CLIENT')
        and  column_name <> 'ID_CLIENT'

/

-- folosing client_provincie si client (global)
select column_name
from   user_tab_columns@bd_provincie
where   table_name = upper('CLIENT_PROVINCIE')
        and  column_name <> 'ID_CLIENT'
intersect
select column_name
from   all_tab_columns
where   owner = 'USER_GLOBAL'
        and  table_name = upper('CLIENT')
        and  column_name <> 'ID_CLIENT'



