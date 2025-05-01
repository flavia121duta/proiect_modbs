set serveroutput on;
/
-- populez regiune, judet, oras, locatie
DECLARE
    -- Variables for Regiune
    v_id_regiune INT;
    v_nume_regiune VARCHAR2(30);
    
    -- Variables for Judet
    v_id_judet INT;
    v_id_regiune_fk INT;
    v_nume_judet VARCHAR2(30);
    
    -- Variables for Oras
    v_id_oras INT;
    v_id_judet_fk INT;
    v_nume_oras VARCHAR2(30);
    
    -- Variables for Locatie
    v_id_locatie INT;
    v_id_oras_fk INT;
    v_strada VARCHAR2(50);
    v_numar VARCHAR2(10);

    -- Counter variables
    regiune_counter INT := 1;
    judet_counter INT := 1;
    oras_counter INT := 1;
    locatie_counter INT := 1;
BEGIN
    -- Insert data for Regiune
    FOR i IN 1..8 LOOP
        v_id_regiune := regiune_counter;
        v_nume_regiune := CASE regiune_counter
                            WHEN 1 THEN 'Bucuresti-Ilfov'
                            WHEN 2 THEN 'Nord-Est'
                            WHEN 3 THEN 'Sud-Est'
                            WHEN 4 THEN 'Sud-Muntenia'
                            WHEN 5 THEN 'Sud-Vest Oltenia'
                            WHEN 6 THEN 'Vest'
                            WHEN 7 THEN 'Nord-Vest'
                            WHEN 8 THEN 'Centru'
                          END;

        INSERT INTO regiune (id_regiune, nume)
        VALUES (v_id_regiune, v_nume_regiune);
        
        regiune_counter := regiune_counter + 1;
    END LOOP;

    -- Insert data for Judet
    FOR i IN 1..41 LOOP
        v_id_judet := judet_counter;
        v_id_regiune_fk := MOD(judet_counter - 1, 8) + 1; -- Assign judet to a regiune
        v_nume_judet := 'Judet ' || judet_counter;

        INSERT INTO judet (id_judet, id_regiune, nume)
        VALUES (v_id_judet, v_id_regiune_fk, v_nume_judet);
        
        judet_counter := judet_counter + 1;
    END LOOP;

    -- Insert data for Oras
    FOR i IN 1..100 LOOP
        v_id_oras := oras_counter;
        v_id_judet_fk := MOD(oras_counter - 1, 41) + 1; -- Assign oras to a judet
        v_nume_oras := 'Oras ' || oras_counter;

        INSERT INTO oras (id_oras, id_judet, nume)
        VALUES (v_id_oras, v_id_judet_fk, v_nume_oras);
        
        oras_counter := oras_counter + 1;
    END LOOP;

    -- Insert data for Locatie
    FOR i IN 1..200 LOOP
        v_id_locatie := locatie_counter;
        v_id_oras_fk := MOD(locatie_counter - 1, 100) + 1; -- Assign locatie to an oras
        v_strada := 'Strada ' || CHR(65 + MOD(i, 26)); -- Random streets like Strada A, Strada B, etc.
        v_numar := TO_CHAR(MOD(i, 50) + 1); -- Random house number between 1 and 50

        INSERT INTO locatie (id_locatie, id_oras, strada, numar)
        VALUES (v_id_locatie, v_id_oras_fk, v_strada, v_numar);
        
        locatie_counter := locatie_counter + 1;
    END LOOP;

    -- Commit the changes
    COMMIT;
END;
/
-- populez cafenea
DECLARE
    -- Variables for Cafenea
    v_id_cafenea INT;
    v_nume_cafenea VARCHAR2(100);
    v_id_locatie INT;

    -- Variables for Locatie
    v_id_oras_fk INT;
    v_strada VARCHAR2(50);
    v_numar VARCHAR2(10);

    -- Counter variables
    cafenea_counter INT := 31;
    locatie_counter INT := 31;
BEGIN
    -- Loop to insert data for Cafenea
    FOR i IN 31..100 LOOP
        -- Generate a unique ID for each cafenea
        v_id_cafenea := cafenea_counter;

        -- Generate a name for the cafenea
        v_nume_cafenea := 'Cafenea ' || TO_CHAR(cafenea_counter);

        -- Assign a random location (ID of location)
        v_id_locatie := MOD(cafenea_counter - 1, 200) + 1; -- Randomly assign one of the 200 locations

        -- Insert data into the cafenea table
        INSERT INTO cafenea (id_cafenea, nume_cafenea, id_locatie)
        VALUES (v_id_cafenea, v_nume_cafenea, v_id_locatie);

        -- Increment the cafenea counter
        cafenea_counter := cafenea_counter + 1;
    END LOOP;

    -- Commit the changes to the database
    COMMIT;
END;
/
-- populez angajat
DECLARE
    -- Variables for Angajat (Employee)
    v_id_angajat INT;
    v_nume_angajat VARCHAR2(30);
    v_prenume_angajat VARCHAR2(30);
    v_salariu DECIMAL(12, 2);
    v_data_angajarii DATE;
    v_id_cafenea INT;

    -- Counter variables
    rol_counter INT := 1;
    angajat_counter INT := 1;
BEGIN
    -- Insert data for Angajat (Employee)
    FOR i IN 1..1000 LOOP
        v_id_angajat := angajat_counter;
        
        -- Generate random employee names
        v_nume_angajat := 'Nume ' || TO_CHAR(angajat_counter);
        v_prenume_angajat := 'Prenume ' || TO_CHAR(angajat_counter);
        
        -- Random salary between 1500 and 4000
        v_salariu := ROUND(DBMS_RANDOM.VALUE(1500, 4000), 2);
        
        -- Random date for hiring, in the last 5 years
        v_data_angajarii := TO_DATE(
              TRUNC(
                   DBMS_RANDOM.VALUE(TO_CHAR(DATE '2023-01-01','J')
                                    ,TO_CHAR(DATE '2025-01-01','J')
                                    )
                    ),'J'
               );
        
        v_id_cafenea := DBMS_RANDOM.value(1, 100);

        -- Insert into ANGAJAT table
        INSERT INTO angajat (id_angajat, nume, prenume, salariu, data_angajarii, id_cafenea)
        VALUES (v_id_angajat, v_nume_angajat, v_prenume_angajat, v_salariu, v_data_angajarii, v_id_cafenea);

        angajat_counter := angajat_counter + 1;
    END LOOP;

    -- Commit the changes to the database
    COMMIT;
END;
/
-- populez materie_prima, inventar_cafenea
DECLARE
    -- Variables for Materie_Prima (Raw Material)
    v_id_materie INT;
    v_nume_materie VARCHAR2(30);

    -- Variables for Inventar_Cafenea (Inventory)
    v_id_cafenea INT;
    v_id_materie_fk INT;
    v_cantitate FLOAT;

    -- Counter variables
    materie_counter INT := 1;
    inventar_counter INT := 1;
    
    check_combination int;
BEGIN
    -- Insert data for Materie_Prima (Raw Materials)
    FOR i IN 1..30 LOOP
        v_id_materie := materie_counter;

        -- Assign raw material names with more variety
        v_nume_materie := CASE materie_counter
                             WHEN 1 THEN 'Cafea Arabica'
                             WHEN 2 THEN 'Lapte'
                             WHEN 3 THEN 'Zahăr'
                             WHEN 4 THEN 'Ciocolată'
                             WHEN 5 THEN 'Sirop de caramel'
                             WHEN 6 THEN 'Pahare'
                             WHEN 7 THEN 'Linguri'
                             WHEN 8 THEN 'Praf de cacao'
                             WHEN 9 THEN 'Șervețele'
                             WHEN 10 THEN 'Lămâie'
                             WHEN 11 THEN 'Scorțișoară'
                             WHEN 12 THEN 'Frișcă'
                             WHEN 13 THEN 'Alune'
                             WHEN 14 THEN 'Gheață'
                             WHEN 15 THEN 'Apa plată'
                             WHEN 16 THEN 'Sirop de vanilie'
                             WHEN 17 THEN 'Menta'
                             WHEN 18 THEN 'Fructe de pădure'
                             WHEN 19 THEN 'Lapte de migdale'
                             WHEN 20 THEN 'Lapte de soia'
                             WHEN 21 THEN 'Făină de grâu'
                             WHEN 22 THEN 'Miere'
                             WHEN 23 THEN 'Glazură de ciocolată'
                             WHEN 24 THEN 'Sirop de fructe de pădure'
                             WHEN 25 THEN 'Nuci pecan'
                             WHEN 26 THEN 'Zahăr brun'
                             WHEN 27 THEN 'Lapte condensat'
                             WHEN 28 THEN 'Pulbere de vanilie'
                             WHEN 29 THEN 'Șerbet'
                             WHEN 30 THEN 'Căpșuni proaspete'
                         END;

        -- Insert into MATERIE_PRIMA table
        INSERT INTO materie_prima (id_materie, nume_materie)
        VALUES (v_id_materie, v_nume_materie);

        materie_counter := materie_counter + 1;
    END LOOP;

    -- Insert data for Inventar_Cafenea (Inventory)
    FOR i IN 1..1000 LOOP
        v_id_cafenea := MOD(i - 1, 70) + 1; -- Assign one of the 10 cafeneas
        v_id_materie_fk := MOD(i - 1, 30) + 1; -- Assign one of the 30 raw materials
        v_cantitate := ROUND(DBMS_RANDOM.VALUE(5, 50)); -- Random quantity between 5 and 50

        -- Insert into INVENTAR_CAFENEA table
        
        dbms_output.put_line(v_id_materie_fk || ' ' || v_id_cafenea);
        
        select count(*) 
        into check_combination
        from inventar_cafenea
        where id_materie = v_id_materie_fk and
        id_cafenea = v_id_cafenea;
        
        if check_combination < 1 then
            INSERT INTO inventar_cafenea (id_cafenea, id_materie, cantitate)
            VALUES (v_id_cafenea, v_id_materie_fk, v_cantitate);
        end if;

        inventar_counter := inventar_counter + 1;
    END LOOP;

    -- Commit the changes to the database
    COMMIT;
END;
/
create or replace FUNCTION is_in_collection(p_collection SYS.ODCINUMBERLIST, p_value NUMBER) RETURN BOOLEAN IS
    BEGIN
        FOR idx IN 1 .. p_collection.COUNT LOOP
            IF p_collection(idx) = p_value THEN
                RETURN TRUE;
            END IF;
        END LOOP;
        RETURN FALSE;
END;
/
-- populez produs
DECLARE
    v_id_produs INT;
    v_denumire_produs VARCHAR2(30);
    v_dimensiune VARCHAR2(30);
    v_unitate_masura VARCHAR2(10);
    v_pret DECIMAL(10, 2);
    v_activ VARCHAR2(1);
    
    v_num_products INT;
    k int default 0;
    v_is_a_drink number default 0;
BEGIN
    for i in 1..20 loop
        v_id_produs := i * 10 + k; -- unique id
        k := k + 1;
        
        v_denumire_produs := 'Produs ' || TO_CHAR(v_id_produs);
        
        v_is_a_drink := dbms_random.value(0, 1);
        if (v_is_a_drink < 0.75) then
            -- assign all three sizes
            FOR i IN 1..3 LOOP
                    CASE i
                        WHEN 1 THEN v_dimensiune := 'mic';
                        WHEN 2 THEN v_dimensiune := 'mare';
                        WHEN 3 THEN v_dimensiune := 'foarte mare';
                    END CASE;
                    
                    -- Random values for the product
                    v_unitate_masura := 'ml';
                    v_pret := i * 2 + ROUND(DBMS_RANDOM.VALUE(7, 14), 2);
                    v_activ := '1';
                    
                    -- insert the product into the `produs` table with the current size
                    INSERT INTO produs (id_produs, denumire, dimensiune, unitate_masura, pret, activ)
                    VALUES (v_id_produs, v_denumire_produs, v_dimensiune, v_unitate_masura, v_pret, v_activ);
            END LOOP;
        else
                -- assign One Size for other categories
                v_dimensiune := 'one size';
                
                -- Random values for the product
                v_unitate_masura := case 
                                        when MOD(k, 2)=0 then 'buc'
                                        else 'g'
                                    end;
                            
                v_pret := round(DBMS_RANDOM.VALUE(5, 20), 2);
                v_activ := '1';
                
                -- insert the product into the `produs` table with One Size
                INSERT INTO produs (id_produs, denumire, dimensiune, unitate_masura, pret, activ)
                VALUES (v_id_produs, v_denumire_produs, v_dimensiune, v_unitate_masura, v_pret, v_activ);
        end if;
    end loop;
    
    -- Commit the changes
    COMMIT;
END;
/
-- populez produs_materie_prima
DECLARE
    v_id_produs INT;
    v_id_materie INT;
    v_cantitate DECIMAL(10, 2);
    v_num_raw_materials INT;
    v_total_produs INT;

    -- Collection to track used raw materials for the current product
    TYPE MaterieList IS TABLE OF INT;
    used_materii MaterieList := MaterieList();

    -- Helper function to check if a value exists in the collection
    FUNCTION is_in_collection(p_collection MaterieList, p_value INT) RETURN BOOLEAN IS
    BEGIN
        FOR idx IN 1 .. p_collection.COUNT LOOP
            IF p_collection(idx) = p_value THEN
                RETURN TRUE;
            END IF;
        END LOOP;
        RETURN FALSE;
    END;
BEGIN
    -- Step 1: Get the total number of products in the "produs" table
    SELECT COUNT(*) INTO v_total_produs FROM produs;

    -- Step 2: Loop through each product
    FOR i IN 1..v_total_produs LOOP
        -- Randomly pick a product
        v_id_produs := i + 98;

        -- Clear the collection for the current product
        used_materii.DELETE;

        -- Step 3: For each product, generate a random number of raw materials (between 1 and 5 raw materials)
        v_num_raw_materials := TRUNC(DBMS_RANDOM.VALUE(1, 6));

        FOR j IN 1..v_num_raw_materials LOOP
            LOOP
                -- Randomly select a raw material
                v_id_materie := TRUNC(DBMS_RANDOM.VALUE(1, 31));  -- Assuming there are 30 raw materials

                -- Check if the raw material is already used for this product
                IF NOT is_in_collection(used_materii, v_id_materie) THEN
                    -- Add the raw material to the collection
                    used_materii.EXTEND;
                    used_materii(used_materii.COUNT) := v_id_materie;
                    EXIT; -- Exit the loop if a unique material is found
                END IF;
            END LOOP;

            -- Generate random quantity for each raw material
            v_cantitate := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);  -- Random quantity between 1 and 10

            DBMS_OUTPUT.PUT_LINE(v_id_produs || ' ' || v_id_materie);

            -- Step 4: Insert into produs_materie_prima table
            INSERT INTO produs_materie_prima (id_produs, id_materie, cantitate)
            VALUES (v_id_produs, v_id_materie, v_cantitate);
        END LOOP;
    END LOOP;

    -- Commit the changes
    COMMIT;
END;
/
-- populez client
DECLARE
    v_id_client INT;
    v_nume VARCHAR2(30);
    v_prenume VARCHAR2(30);
    v_email VARCHAR2(50);
    v_parola VARCHAR2(50);
    v_client_counter INT := 1;
    v_total_clients INT := 100;  -- Example: Generate 100 clients, adjust as needed
BEGIN
    -- Step 1: Loop through to generate random clients
    FOR i IN 1..v_total_clients LOOP
        -- Generate random first and last name
        v_nume := 'Client' || v_client_counter;
        v_prenume := 'Prenume' || v_client_counter;

        -- Generate random email address
        v_email := LOWER(v_nume) || '.' || LOWER(v_prenume) || '@example.com';

        -- Generate random password (simple logic, can be enhanced)
        v_parola := 'password' || v_client_counter;

        -- Step 2: Insert client data into the "client" table
        INSERT INTO client (id_client, nume, prenume, email, parola)
        VALUES (v_client_counter, v_nume, v_prenume, v_email, v_parola);

        -- Increment client counter for the next client
        v_client_counter := v_client_counter + 1;
    END LOOP;

    -- Commit the changes
    COMMIT;
END;
/
-- populez comanda_client si comanda_produs
DECLARE
    v_id_client INT;
    v_data_plasarii DATE;
    v_comanda_counter INT := 1;
    v_total_comenzi INT := 20;
    v_total_clients INT;
    v_total_products INT;
    v_random_quantity INT;
    v_id_produs INT;
    
    v_pret_final NUMBER;
    v_procent_reducere NUMBER;
    
    TYPE product_set IS TABLE OF INT INDEX BY PLS_INTEGER;
    v_used_products product_set;
BEGIN
    SELECT COUNT(*) 
    INTO v_total_clients
    FROM client;
    
    SELECT COUNT(*) 
    INTO v_total_products
    FROM produs;
    
    FOR i IN 1..v_total_comenzi LOOP
        v_used_products.DELETE;

        v_id_client := MOD(i, v_total_clients) + 1; -- valid client id

        v_data_plasarii := TO_DATE(
              TRUNC(
                   DBMS_RANDOM.VALUE(TO_CHAR(DATE '2023-01-01', 'J'),
                                     TO_CHAR(DATE '2025-01-01', 'J'))
              ), 'J'
        );

        INSERT INTO comanda_client (id_comanda, id_client, data_plasarii)
        VALUES (v_comanda_counter, v_id_client, v_data_plasarii);

        FOR j IN 1..TRUNC(DBMS_RANDOM.VALUE(1, 5)) LOOP
            LOOP
                v_id_produs := MOD(DBMS_RANDOM.VALUE(99, v_total_products), v_total_products) + 1;

                IF NOT v_used_products.EXISTS(v_id_produs) THEN
                    v_used_products(v_id_produs) := 1;
                    EXIT;
                END IF;
            END LOOP;

            v_random_quantity := TRUNC(DBMS_RANDOM.VALUE(1, 5));

            SELECT pret
            INTO v_pret_final
            FROM produs
            WHERE id_produs = v_id_produs;

            INSERT INTO comanda_produs (id_comanda, id_produs, cantitate, pret_final)
            VALUES (v_comanda_counter, v_id_produs, v_random_quantity, v_pret_final);
        END LOOP;

        v_comanda_counter := v_comanda_counter + 1;
    END LOOP;

    COMMIT;
END;
/
