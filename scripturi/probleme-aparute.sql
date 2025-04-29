-- angajatii din bucuresti nu aveau id_cafenea setat in baza de date
declare
    r_angajat_bucuresti angajat_bucuresti%rowtype;
    v_id_cafenea angajat.id_cafenea@bd_all%type;
begin
    for r_angajat_bucuresti in (select * from angajat_bucuresti) loop
        begin
            select id_cafenea into v_id_cafenea
            from angajat@bd_all
            where id_angajat = r_angajat_bucuresti.id_angajat;
            
            dbms_output.put_line('Id angajat: ' || r_angajat_bucuresti.id_angajat || ', id_cafenea: ' || v_id_cafenea);
            
            update angajat_bucuresti
            set id_cafenea = v_id_cafenea
            where id_angajat = r_angajat_bucuresti.id_angajat;
            
        exception
            when no_data_found then
                dbms_output.put_line('WARNING: No matching angajat found for id_angajat = ' || r_angajat_bucuresti.id_angajat);
            when too_many_rows then
                dbms_output.put_line('ERROR: Multiple angajat found for id_angajat = ' || r_angajat_bucuresti.id_angajat);
        end;
    end loop;
    
    commit;
end;
