-- testez trigger-ul din coffee_project_bucuresti
select * from angajat;
/
insert into angajat(id_angajat, salariu, data_angajarii)
values (1001, 4500, '25-APR-2025');
/
insert into angajat(id_angajat, salariu, data_angajarii)
values (1002, 4500, '25-APR-2025');
/
commit;
/
select * from angajat;
/

-- teste trigger-ul din coffee_project_provincie
insert into angajat(id_angajat, salariu, data_angajarii)
values (1003, 5000, '25-APR-2025');
/
insert into angajat(id_angajat, salariu, data_angajarii)
values (1004, 5000, '25-APR-2025');
/
commit;
