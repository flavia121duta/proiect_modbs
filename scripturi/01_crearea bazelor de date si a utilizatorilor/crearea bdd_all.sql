-- acest script a fost creat semestrul trecut pentru materia DW&BI
-- am realizat modificari pentru a-l adapta la cerintele proiectului de MODBD

CREATE TABLE cafenea (
    id_cafenea INT PRIMARY KEY,
    nume_cafenea VARCHAR2(100) NOT NULL
);

CREATE TABLE materie_prima (
    id_materie INT PRIMARY KEY,
    nume_materie VARCHAR2(30) NOT NULL,
    unitate_masura VARCHAR2(20) constraint ck_materie_prima_um check (unitate_masura in ('kg', 'l', 'buc'))
);

CREATE TABLE inventar_cafenea (
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
    dimensiune VARCHAR2(30) constraint ck_produs_dim check (dimensiune in ('mic', 'mare', 'foarte mare', 'one size')), -- mic, mare, foarte mare, one size
    cantitate DECIMAL(10, 2) constraint ck_produs_cantitate check (cantitate > 0),
    unitate_masura VARCHAR2(10) constraint ck_produs_um check (unitate_masura in ('g', 'ml', 'buc')),
    pret DECIMAL(10,2) constraint ck_produs_pret check (pret > 0),
    activ VARCHAR2(1 BYTE) constraint ck_produs_activ check (activ in (0, 1))
);

CREATE TABLE produs_materie_prima (
    id_produs INT,
    id_materie INT,
    cantitate DECIMAL(10,2) constraint ck_produs_mp_cantitate check (cantitate > 0),
    
    PRIMARY KEY(id_produs, id_materie),
    FOREIGN KEY (id_produs) REFERENCES produs(id_produs) ON DELETE CASCADE,
    FOREIGN KEY (id_materie) REFERENCES MATERIE_PRIMA(id_materie) ON DELETE CASCADE
);

CREATE TABLE client (
    id_client INT PRIMARY KEY,
    nume varchar2(30),
    prenume varchar2(30),
    email varchar2(50),
    parola varchar2(50)
);

create table angajat (
    id_angajat INT PRIMARY KEY,
    nume varchar2(30),
    prenume varchar2(30),
    salariu DECIMAL(12,2) constraint ck_angajat_salariu check (salariu > 0),
    data_angajarii DATE
);

CREATE TABLE regiune (
    id_regiune INT PRIMARY KEY,
    nume VARCHAR2(30)
);

CREATE TABLE judet (
    id_judet INT PRIMARY KEY,
    id_regiune INT,
    nume VARCHAR2(30),
    
    FOREIGN KEY (id_regiune) REFERENCES regiune(id_regiune) ON DELETE CASCADE
);

CREATE TABLE oras (
    id_oras int PRIMARY KEY,
    id_judet INT,
    nume varchar2(30),
    
    FOREIGN KEY (id_judet) REFERENCES judet(id_judet) ON DELETE CASCADE
);
    
CREATE TABLE locatie (
    id_locatie INT PRIMARY KEY,
    id_oras INT,
    strada VARCHAR2(50),
    numar VARCHAR2(10),

    FOREIGN KEY (id_oras) REFERENCES oras (id_oras) ON DELETE SET NULL,
);
    
ALTER TABLE cafenea ADD id_locatie INT;
ALTER TABLE cafenea ADD FOREIGN KEY (id_locatie) REFERENCES locatie(id_locatie); 

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
    id_cafenea NUMBER,
    data_plasarii DATE,
    
    PRIMARY KEY (id_comanda_client),
    FOREIGN KEY (id_client) REFERENCES client(id_client) ON DELETE SET NULL,
    FOREIGN KEY (id_cafenea) REFERENCES cafenea(id_cafenea) ON DELETE SET NULL
);

create table comanda_produs (
    id_comanda_client INT,
    id_produs INT,
    cantitate INT constraint ck_comanda_produs_cantitate check (cantitate > 0),
    pret_final DECIMAL(10,2) constraint ck_comanda_produs_pret check (pret_final > 0),
    
    PRIMARY KEY (id_comanda_client, id_produs),
    FOREIGN KEY (id_comanda_client) REFERENCES comanda_client(id_comanda_client) ON DELETE SET NULL,
    FOREIGN KEY (id_produs) REFERENCES produs(id_produs) ON DELETE SET NULL
);
