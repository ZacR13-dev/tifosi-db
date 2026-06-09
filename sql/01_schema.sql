-- =============================================================================
--  Projet      : Base de données "Tifosi" (restaurant de focaccias & boissons)
--  Fichier     : 01_schema.sql
--  Rôle        : Création de la base de données et de son schéma relationnel.
--  SGBD        : MySQL 8.x
--  Auteur      : Kevin Reis
-- =============================================================================
--
--  Le script est ré-exécutable : il supprime puis recrée intégralement la base.
--  Moteur InnoDB  -> support des clés étrangères et des transactions.
--  Jeu utf8mb4    -> gestion correcte des accents (é, è, ç, œ...).
--
-- -----------------------------------------------------------------------------

DROP DATABASE IF EXISTS tifosi;
CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE tifosi;

-- -----------------------------------------------------------------------------
--  Table : marque
--  Marques commerciales des boissons (Coca-cola, Pepsico, ...).
-- -----------------------------------------------------------------------------
CREATE TABLE marque (
    id_marque   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_marque  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_marque PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom_marque)
) ENGINE = InnoDB;

-- -----------------------------------------------------------------------------
--  Table : boisson
--  Boissons proposées à la carte. Chaque boisson appartient à une seule marque.
--  Relation marque (1) --- (N) boisson.
-- -----------------------------------------------------------------------------
CREATE TABLE boisson (
    id_boisson   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_boisson  VARCHAR(80)  NOT NULL,
    id_marque    INT UNSIGNED NOT NULL,
    CONSTRAINT pk_boisson PRIMARY KEY (id_boisson),
    CONSTRAINT fk_boisson_marque
        FOREIGN KEY (id_marque) REFERENCES marque (id_marque)
        ON UPDATE CASCADE
        ON DELETE RESTRICT          -- on interdit la suppression d'une marque encore utilisée
) ENGINE = InnoDB;

-- Index sur la clé étrangère pour accélérer les jointures et les filtres par marque.
CREATE INDEX idx_boisson_marque ON boisson (id_marque);

-- -----------------------------------------------------------------------------
--  Table : ingredient
--  Catalogue des ingrédients utilisables sur les focaccias.
--  quantite_defaut_g : grammage standard appliqué « sauf indication contraire ».
-- -----------------------------------------------------------------------------
CREATE TABLE ingredient (
    id_ingredient      INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    nom_ingredient     VARCHAR(50)    NOT NULL,
    quantite_defaut_g  SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    CONSTRAINT pk_ingredient PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom UNIQUE (nom_ingredient)
) ENGINE = InnoDB;

-- -----------------------------------------------------------------------------
--  Table : focaccia
--  Focaccias proposées à la carte, avec leur prix de vente.
-- -----------------------------------------------------------------------------
CREATE TABLE focaccia (
    id_focaccia   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nom_focaccia  VARCHAR(50)   NOT NULL,
    prix          DECIMAL(5,2)  NOT NULL,
    CONSTRAINT pk_focaccia PRIMARY KEY (id_focaccia),
    CONSTRAINT uq_focaccia_nom UNIQUE (nom_focaccia),
    CONSTRAINT ck_focaccia_prix CHECK (prix > 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------------------------------
--  Table : composition  (table d'association / table de jonction)
--  Modélise la relation N..N entre focaccia et ingredient :
--      - une focaccia est composée de plusieurs ingrédients ;
--      - un ingrédient peut entrer dans plusieurs focaccias.
--  L'attribut quantite_g porte sur la RELATION (grammage réellement utilisé
--  pour cette focaccia, qui peut différer du grammage par défaut).
--  La clé primaire composite (id_focaccia, id_ingredient) interdit les doublons.
-- -----------------------------------------------------------------------------
CREATE TABLE composition (
    id_focaccia    INT UNSIGNED      NOT NULL,
    id_ingredient  INT UNSIGNED      NOT NULL,
    quantite_g     SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT pk_composition PRIMARY KEY (id_focaccia, id_ingredient),
    CONSTRAINT fk_compo_focaccia
        FOREIGN KEY (id_focaccia) REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE
        ON DELETE CASCADE,          -- supprimer une focaccia supprime sa composition
    CONSTRAINT fk_compo_ingredient
        FOREIGN KEY (id_ingredient) REFERENCES ingredient (id_ingredient)
        ON UPDATE CASCADE
        ON DELETE RESTRICT          -- on interdit la suppression d'un ingrédient encore utilisé
) ENGINE = InnoDB;

-- Index sur la 2e colonne de la FK composite (la 1re est déjà couverte par la PK)
-- pour accélérer la recherche « dans quelles focaccias se trouve cet ingrédient ? ».
CREATE INDEX idx_compo_ingredient ON composition (id_ingredient);
