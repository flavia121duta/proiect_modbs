-- de intrebat
-- ANGAJATI
-- FR. MIXT DIN BUCURESTI (ORIZONTAL VERTICAL ---> ORIZONTAL): id_angajat, nume, prenume, id_cafenea
-- FR. MIXT DIN PROVINCIE:                                      id_angajat, nume, prenume, id_cafenea
-- FR. VERTICAL DIN GLOBAL: TOATE INREGISTRARILE ANGAJATILOR + SUBMULTIMEA CU RESTUL ATRIBUTELOR: id_angajat, salariu, data_angajari


-- CLIENT(id_client, nume, prenume, email, parola)
-- fr. vertical replicat : CLIENT_1(id_client, nume, prenume)
-- fr. vertical replicat: CLIENT_2(id_client, nume, prenume)
-- FR. VERTICAL DIN GLOBAL: CLIENT 3(id_client, email, parola)

desc angajat_bucuresti;
/
desc angajat_provincie@bd_provincie;






-- fragmentare orizontala pentru ANGAJAT
select a.id_angajat, a.nume, a.prenume, a.salariu, a.data_angajarii, a.id_cafenea
from angajat a, cafenea c, locatie l, oras o, judet j, regiune r
where a.id_cafenea = c.id_cafenea
and c.id_locatie = l.id_locatie
and l.id_oras = o.id_oras
and o.id_judet = j.id_judet
and j.id_regiune = r.id_regiune
and r.nume = 'Bucuresti-Ilfov';
/
select a.id_angajat, a.nume, a.prenume, a.salariu, a.data_angajarii, a.id_cafenea
from angajat a, cafenea c, locatie l, oras o, judet j, regiune r
where a.id_cafenea = c.id_cafenea
and c.id_locatie = l.id_locatie
and l.id_oras = o.id_oras
and o.id_judet = j.id_judet
and j.id_regiune = r.id_regiune
and r.nume <> 'Bucuresti-Ilfov';
/


-- fragmentare orizontala mixta/ derivata
-- trebuie sa mai aplic fragmentare verticala
-- BUCURESTI
select a.id_angajat, a.nume, a.prenume
from angajat a, cafenea c, locatie l, oras o, judet j, regiune r
where a.id_cafenea = c.id_cafenea
and c.id_locatie = l.id_locatie
and l.id_oras = o.id_oras
and o.id_judet = j.id_judet
and j.id_regiune = r.id_regiune
and r.nume = 'Bucuresti-Ilfov';
/

-- fragmentare orizontala mixta/ derivata
-- trebuie sa mai aplic fragmentare verticala
-- BUCURESTI
select a.id_angajat, a.salariu, a.data_angajarii, a.id_cafenea
from angajat a, cafenea c, locatie l, oras o, judet j, regiune r
where a.id_cafenea = c.id_cafenea
and c.id_locatie = l.id_locatie
and l.id_oras = o.id_oras
and o.id_judet = j.id_judet
and j.id_regiune = r.id_regiune
and r.nume = 'Bucuresti-Ilfov';









