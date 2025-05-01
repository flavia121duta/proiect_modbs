-- ma conectez la schema coffee_project_global

-- creez fragmentele verticale pentru ANGAJAT si CLIENT cu informatiile sensibile
create table ANGAJAT
as (
        select id_angajat, salariu, data_angajarii 
        from angajat@bd_all
);
/
create table CLIENT
as (
        select id_client, email, parola
        from client@bd_all
);
/
