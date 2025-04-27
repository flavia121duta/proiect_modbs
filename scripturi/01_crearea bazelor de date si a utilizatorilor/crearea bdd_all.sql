-- acest script a fost creat semestrul trecut pentru materia DW&BI
-- crearea bazei de date

CREATE TABLE cafenea (
    id_cafenea INT PRIMARY KEY,
    nume_cafenea VARCHAR2(100) NOT NULL
);

CREATE TABLE materie_prima (
    id_materie INT PRIMARY KEY,
    nume_materie VARCHAR2(30) NOT NULL,
    unitate_masura VARCHAR2(20) constraint ck_materie_prima_um check (unitate_masura in ('kg', 'l', 'buc'))
);

CREATE TABLE inventar (
    id_cafenea INT,
    id_materie INT,
    cantitate FLOAT,
    
    PRIMARY KEY(id_cafenea, id_materie),
    FOREIGN KEY(id_cafenea) REFERENCES cafenea(id_cafenea) ON DELETE CASCADE,
    FOREIGN KEY(id_materie) REFERENCES MATERIE_PRIMA(id_materie) ON DELETE CASCADE
);

CREATE TABLE produs (
    id_produs INT PRIMARY KEY,
    denumire VARCHAR2(30),
    dimensiune VARCHAR2(30) constraint ck_produs_dim check (dimensiune in ('mic', 'mare', 'foare mare', 'one size')), -- mic, mare, foarte mare, one size
    cantitate DECIMAL(10, 2) constraint ck_produs_cantitate check (cantitate > 0),
    unitate_masura VARCHAR2(10) constraint ck_produs_um check (unitate_masura in ('g', 'ml', 'buc')),
    pret DECIMAL(10,2) constraint ck_produs_pret check (pret > 0),
    activ VARCHAR2(1 BYTE) constraint ck_produs_activ check (activ in (0, 1))
);

CREATE TABLE categorie (
    id_categorie INT PRIMARY KEY,
    denumire_categorie VARCHAR2(30) not null
);

CREATE TABLE subcategorie (
    id_subcategorie INT,
    id_categorie INT,
    denumire_subcategorie VARCHAR2(30) not null,
    
    PRIMARY KEY(id_subcategorie),
    FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie) ON DELETE SET NULL
);

alter table produs
add id_subcategorie INT;

alter table produs
add foreign key (id_subcategorie) 
references subcategorie(id_subcategorie);

CREATE TABLE produs_materie_prima (
    id_produs INT,
    id_materie INT,
    cantitate DECIMAL(10,2) constraint ck_produs_mp_cantitate check (cantitate > 0),
    
    PRIMARY KEY(id_produs, id_materie),
    FOREIGN KEY (id_produs) REFERENCES produs(id_produs) ON DELETE CASCADE,
    FOREIGN KEY (id_materie) REFERENCES MATERIE_PRIMA(id_materie) ON DELETE CASCADE
);

CREATE TABLE oferta (
    id_oferta INT PRIMARY KEY,
    procent_reducere DECIMAL(4,2) constraint ck_oferta_procent check (procent_reducere between 0 and 1),
    data_inceput DATE,
    data_finalizare DATE,
    
    constraint ck_oferta_data check (data_inceput < data_finalizare)
);

create table oferta_produs (
    id_produs int, 
    id_oferta int,
    
    FOREIGN KEY (id_produs) REFERENCES produs(id_produs) ON DELETE SET NULL,
    FOREIGN KEY (id_oferta) REFERENCES oferta(id_oferta) ON DELETE SET NULL
);

CREATE TABLE client (
    id_client INT PRIMARY KEY,
    nume varchar2(30),
    prenume varchar2(30),
    email varchar2(50),
    parola varchar2(50)
);

CREATE TABLE recenzie (
    id_recenzie INT PRIMARY KEY,
    id_client INT,
    id_produs INT,
    nota INT constraint ck_recenzie_nota check (nota between 1 and 5),
    recenzie VARCHAR2(1024),
    data_aparitie DATE,
    
    FOREIGN KEY (id_client) REFERENCES client(id_client) ON DELETE SET NULL,
    FOREIGN KEY (id_produs) REFERENCES produs(id_produs) ON DELETE SET NULL
);
    
CREATE TABLE favorit (
    id_produs INT,
    id_client INT,
    
    PRIMARY KEY(id_produs, id_client),
    FOREIGN KEY (id_produs) REFERENCES produs(id_produs) ON DELETE CASCADE,
    FOREIGN KEY (id_client) REFERENCES client(id_client) ON DELETE CASCADE
);
    
CREATE TABLE rol (
    id_rol INT PRIMARY KEY,
    denumire varchar2(20) constraint ck_rol_denumire unique
);

create table angajat (
    id_angajat INT PRIMARY KEY,
    id_rol INT,
    nume varchar2(30),
    prenume varchar2(30),
    salariu DECIMAL(12,2) constraint ck_angajat_salariu check (salariu > 0),
    data_angajarii DATE,
    
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE SET NULL
);

CREATE TABLE regiune (
    id_regiune INT PRIMARY KEY,
    nume VARCHAR2(30)
);

CREATE TABLE judet(
    id_judet INT PRIMARY KEY,
    id_regiune INT,
    nume VARCHAR2(30),
    
    FOREIGN KEY (id_regiune) REFERENCES regiune(id_regiune) ON DELETE CASCADE
);

CREATE TABLE oras(
    id_oras int PRIMARY KEY,
    id_judet INT,
    nume varchar2(30),
    
    FOREIGN KEY (id_judet) REFERENCES judet(id_judet) ON DELETE CASCADE
);
    
CREATE TABLE locatie (
    id_locatie INT PRIMARY KEY,
    id_oras INT,
    strada VARCHAR2(50),
    numar VARCHAR2(10)
);
    
ALTER TABLE cafenea ADD id_locatie INT;
ALTER TABLE cafenea ADD FOREIGN KEY (id_locatie) REFERENCES locatie(id_locatie); 

CREATE TABLE furnizor (
    id_furnizor INT PRIMARY KEY,
    id_locatie INT,
    nume_firma VARCHAR2(50),
    email VARCHAR2(50),
    telefon VARCHAR2(20),
    
    FOREIGN KEY (id_locatie) REFERENCES locatie(id_locatie) ON DELETE SET NULL
);

create table comanda_furnizor (
    id_comanda_furnizor INT,
    id_furnizor INT,
    id_cafenea INT,
    data_plasarii DATE,
    data_livrarii DATE,
    
    PRIMARY KEY (id_comanda_furnizor),
    FOREIGN KEY (id_furnizor) REFERENCES furnizor(id_furnizor) ON DELETE SET NULL,
    FOREIGN KEY (id_cafenea) REFERENCES cafenea(id_cafenea) ON DELETE SET NULL,
    constraint ck_comanda_furnizot_data check (data_plasarii <= data_livrarii)
);

create table comanda_materie_prima (
    id_comanda_furnizor INT,
    id_materie INT,
    cantitate INT constraint ck_comanda_materie_cantitate check (cantitate > 0),
    
    PRIMARY KEY (id_comanda_furnizor, id_materie),
    FOREIGN KEY (id_comanda_furnizor) REFERENCES comanda_furnizor(id_comanda_furnizor) ON DELETE SET NULL,
    FOREIGN KEY (id_materie) REFERENCES materie_prima(id_materie) ON DELETE SET NULL
);


create table comanda_client (
    id_comanda_client NUMBER,
    id_client NUMBER,
    data_plasarii DATE,
    
    PRIMARY KEY (id_comanda_client),
    FOREIGN KEY (id_client) REFERENCES client(id_client) ON DELETE SET NULL
);

create table comanda_produs (
    id_comanda_client INT,
    id_produs INT,
    cantitate INT constraint ck_comanda_produs_cantitate check (cantitate > 0),
    
    PRIMARY KEY (id_comanda_client, id_produs),
    FOREIGN KEY (id_comanda_client) REFERENCES comanda_client(id_comanda_client) ON DELETE SET NULL,
    FOREIGN KEY (id_produs) REFERENCES produs(id_produs) ON DELETE SET NULL
);

create table factura_furnizor (
    id_factura_furnizor INT,
    id_comanda_furnizor INT,
    pret_total NUMBER,
    data_emiterii DATE,
    status VARCHAR2(15),
    
    PRIMARY KEY (id_factura_furnizor),
    FOREIGN KEY (id_comanda_furnizor) REFERENCES comanda_furnizor(id_comanda_furnizor) ON DELETE SET NULL
);

create table factura_client (
    id_factura_client INT,
    id_comanda_client INT,
    pret_total NUMBER,
    data_emiterii DATE,
    status VARCHAR2(15) constraint ck_factura_client_status check (status in ('validata', 'anulata', 'inchisa')),
    metoda_plata VARCHAR2(20) constraint ck_factura_client_metoda_plata check (metoda_plata in ('card', 'numerar')),
    
    PRIMARY KEY (id_factura_client),
    FOREIGN KEY (id_comanda_client) REFERENCES comanda_client(id_comanda_client)ON DELETE SET NULL
);

-- modificari ulterioare

alter table locatie
add foreign key (id_oras)
references oras(id_oras);

alter table comanda_materie_prima
add pret NUMBER(10, 2);

ALTER TABLE inventar
RENAME TO inventar_cafenea;

-- creez un trigger care se va declara la insert in tabela produs
-- care va asigna automat o valoare
-- pentru id_produs folosind o secventa de numere

-- creez o secventa de la 10..1000 pentru id_produs
create sequence secventa_id
increment by 1
start with 10
minvalue 10
maxvalue 1000;

create or replace trigger produs_on_insert
    before insert on produs
    for each row
begin
    select secventa_id.nextval
    into :new.id_produs
    from dual;
end;

-- creez un trigger pentru tabela FACTURI care se va declansa la update sau insert
-- pentru a verifica ca data_emiterii sa nu fie o data din viitor

create or replace trigger facturi_on_insert_update
    before insert or update of data_emiterii on factura_client
    for each row
begin
    if :new.data_emiterii > sysdate then
        raise_application_error(-20000, 'Data emiterii unui facturi nu poate fi in viitor');
    end if;
end;

-- creez un trigger pentru tabela OFERTE care se va declansa la update sau insert
-- pentru a verifica ca data_inceput < data_finalizare

create or replace trigger oferte_on_insert_update
    before insert or update on oferta
    for each row
begin
    if :new.data_inceput > :new.data_finalizare then
        raise_application_error(-20001, 'Data inceput nu poate fi dupa data finalizare'); 
    end if;
end;

alter table angajat
add id_cafenea int;

alter table angajat
add constraint fk_angajat_cafenea foreign key (id_cafenea)
references cafenea(id_cafenea);