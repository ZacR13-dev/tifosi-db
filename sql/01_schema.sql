-- =============================================================================
--  Projet  : Base de données "Tifosi" (restaurant de street-food italien)
--  Fichier : 01_schema.sql
--  Rôle    : Création de la base, de l'utilisateur d'administration et du
--            schéma relationnel, d'après le MCD fourni par le client.
--  SGBD    : MySQL 8.x / MariaDB 10.x
--  Auteur  : Kevin Reis
-- =============================================================================
--
--  MCD -> MLD (transformation des associations) :
--    comprend (N..N, ingredient <-> focaccia, attribut quantite) -> table comprend
--    appartient (boisson 1,1 -> marque 0,n)                      -> FK id_marque dans boisson
--    est constitué (menu 1,1 -> focaccia 0,n)                    -> FK id_focaccia dans menu
--    contient (N..N, menu <-> boisson)                           -> table contient
--    achete (N..N, client <-> menu, attribut date_achat)         -> table achete
--
--  Sécurité / intégrité :
--    - champs obligatoires        -> NOT NULL
--    - valeurs uniques            -> UNIQUE (noms, email)
--    - intégrité référentielle    -> FOREIGN KEY + ON UPDATE/DELETE
--    - règles métier              -> CHECK (prix > 0)
--  Moteur InnoDB (clés étrangères) et jeu utf8mb4 (accents é, è, œ...).
--
-- -----------------------------------------------------------------------------

-- 1) Création de la base de données -------------------------------------------
DROP DATABASE IF EXISTS tifosi;
CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- 2) Création de l'utilisateur d'administration de la base --------------------
--    L'utilisateur 'tifosi' administre UNIQUEMENT la base tifosi (moindre
--    privilège : aucun droit global sur le serveur).
CREATE USER IF NOT EXISTS 'tifosi'@'localhost' IDENTIFIED BY 'Tifosi#2025';
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

USE tifosi;

-- 3) Tables « entités » (sans clé étrangère) ----------------------------------

-- Clients du restaurant.
CREATE TABLE client (
    id_client    INT          NOT NULL AUTO_INCREMENT,
    nom          VARCHAR(50)  NOT NULL,
    email        VARCHAR(150) NOT NULL,
    code_postal  INT          NULL,
    CONSTRAINT pk_client PRIMARY KEY (id_client),
    CONSTRAINT uq_client_email UNIQUE (email)        -- un email identifie un client
) ENGINE = InnoDB;

-- Marques commerciales des boissons.
CREATE TABLE marque (
    id_marque  INT         NOT NULL AUTO_INCREMENT,
    nom        VARCHAR(50) NOT NULL,
    CONSTRAINT pk_marque PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom)
) ENGINE = InnoDB;

-- Catalogue des ingrédients.
CREATE TABLE ingredient (
    id_ingredient INT         NOT NULL AUTO_INCREMENT,
    nom           VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ingredient PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom UNIQUE (nom)
) ENGINE = InnoDB;

-- Focaccias proposées à la carte.
CREATE TABLE focaccia (
    id_focaccia INT          NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)  NOT NULL,
    prix        DECIMAL(5,2) NOT NULL,
    CONSTRAINT pk_focaccia PRIMARY KEY (id_focaccia),
    CONSTRAINT uq_focaccia_nom UNIQUE (nom),
    CONSTRAINT ck_focaccia_prix CHECK (prix > 0)
) ENGINE = InnoDB;

-- 4) Tables « entités » avec clé étrangère ------------------------------------

-- Boissons : chaque boisson appartient à exactement une marque (1,1).
CREATE TABLE boisson (
    id_boisson INT         NOT NULL AUTO_INCREMENT,
    nom        VARCHAR(50) NOT NULL,
    id_marque  INT         NOT NULL,
    CONSTRAINT pk_boisson PRIMARY KEY (id_boisson),
    CONSTRAINT fk_boisson_marque
        FOREIGN KEY (id_marque) REFERENCES marque (id_marque)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
CREATE INDEX idx_boisson_marque ON boisson (id_marque);

-- Menus : chaque menu est constitué d'exactement une focaccia (1,1).
CREATE TABLE menu (
    id_menu     INT          NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)  NOT NULL,
    prix        DECIMAL(5,2) NOT NULL,
    id_focaccia INT          NOT NULL,
    CONSTRAINT pk_menu PRIMARY KEY (id_menu),
    CONSTRAINT uq_menu_nom UNIQUE (nom),
    CONSTRAINT ck_menu_prix CHECK (prix > 0),
    CONSTRAINT fk_menu_focaccia
        FOREIGN KEY (id_focaccia) REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
CREATE INDEX idx_menu_focaccia ON menu (id_focaccia);

-- 5) Tables « associations » (relations N..N) ---------------------------------

-- comprend : composition d'une focaccia en ingrédients (+ quantité en grammes).
CREATE TABLE comprend (
    id_focaccia   INT NOT NULL,
    id_ingredient INT NOT NULL,
    quantite      INT NOT NULL,
    CONSTRAINT pk_comprend PRIMARY KEY (id_focaccia, id_ingredient),
    CONSTRAINT fk_comprend_focaccia
        FOREIGN KEY (id_focaccia) REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_comprend_ingredient
        FOREIGN KEY (id_ingredient) REFERENCES ingredient (id_ingredient)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
CREATE INDEX idx_comprend_ingredient ON comprend (id_ingredient);

-- contient : boissons incluses dans un menu.
CREATE TABLE contient (
    id_menu    INT NOT NULL,
    id_boisson INT NOT NULL,
    CONSTRAINT pk_contient PRIMARY KEY (id_menu, id_boisson),
    CONSTRAINT fk_contient_menu
        FOREIGN KEY (id_menu) REFERENCES menu (id_menu)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_contient_boisson
        FOREIGN KEY (id_boisson) REFERENCES boisson (id_boisson)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
CREATE INDEX idx_contient_boisson ON contient (id_boisson);

-- achete : achats d'un menu par un client à une date donnée.
-- La date fait partie de la clé : un client peut racheter le même menu un autre jour.
CREATE TABLE achete (
    id_client  INT  NOT NULL,
    id_menu    INT  NOT NULL,
    date_achat DATE NOT NULL,
    CONSTRAINT pk_achete PRIMARY KEY (id_client, id_menu, date_achat),
    CONSTRAINT fk_achete_client
        FOREIGN KEY (id_client) REFERENCES client (id_client)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_achete_menu
        FOREIGN KEY (id_menu) REFERENCES menu (id_menu)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
CREATE INDEX idx_achete_menu ON achete (id_menu);
