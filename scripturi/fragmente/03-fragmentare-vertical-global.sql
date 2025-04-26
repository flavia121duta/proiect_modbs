-- ma conectez la schema coffee_project_global

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
