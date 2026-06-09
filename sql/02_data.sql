-- =============================================================================
--  Projet  : Base de données "Tifosi"
--  Fichier : 02_data.sql
--  Rôle    : Insertion des données de test (jeu d'essai issu des fichiers source).
--  Pré-requis : exécuter 01_schema.sql au préalable.
-- =============================================================================
--
--  Les identifiants sont insérés explicitement afin que les clés étrangères
--  des tables filles restent stables et lisibles.
--
-- -----------------------------------------------------------------------------

USE tifosi;

-- Nettoyage des données (ordre inverse des dépendances) pour rendre le script
-- ré-exécutable sans recréer le schéma.
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE composition;
TRUNCATE TABLE boisson;
TRUNCATE TABLE focaccia;
TRUNCATE TABLE ingredient;
TRUNCATE TABLE marque;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
--  Marques
-- -----------------------------------------------------------------------------
INSERT INTO marque (id_marque, nom_marque) VALUES
    (1, 'Coca-cola'),
    (2, 'Cristalline'),
    (3, 'Monster'),
    (4, 'Pepsico');

-- -----------------------------------------------------------------------------
--  Boissons (chaque boisson référence une marque)
-- -----------------------------------------------------------------------------
INSERT INTO boisson (id_boisson, nom_boisson, id_marque) VALUES
    (1,  'Coca-cola zéro',            1),
    (2,  'Coca-cola original',        1),
    (3,  'Fanta citron',              1),
    (4,  'Fanta orange',              1),
    (5,  'Capri-sun',                 1),
    (6,  'Pepsi',                     4),
    (7,  'Pepsi Max Zéro',            4),
    (8,  'Lipton zéro citron',        4),
    (9,  'Lipton Peach',              4),
    (10, 'Monster energy ultra gold', 3),
    (11, 'Monster energy ultra blue', 3),
    (12, 'Eau de source',             2);

-- -----------------------------------------------------------------------------
--  Ingrédients (avec le grammage standard appliqué par défaut)
-- -----------------------------------------------------------------------------
INSERT INTO ingredient (id_ingredient, nom_ingredient, quantite_defaut_g) VALUES
    (1,  'Ail',            2),
    (2,  'Ananas',         40),
    (3,  'Artichaut',      20),
    (4,  'Bacon',          80),
    (5,  'Base Tomate',    200),
    (6,  'Base crème',     200),
    (7,  'Champignon',     40),
    (8,  'Chevre',         50),
    (9,  'Cresson',        20),
    (10, 'Emmental',       50),
    (11, 'Gorgonzola',     50),
    (12, 'Jambon cuit',    80),
    (13, 'Jambon fumé',    80),
    (14, 'Oeuf',           50),
    (15, 'Oignon',         20),
    (16, 'Olive noire',    20),
    (17, 'Olive verte',    20),
    (18, 'Parmesan',       50),
    (19, 'Piment',         2),
    (20, 'Poivre',         1),
    (21, 'Pomme de terre', 80),
    (22, 'Raclette',       50),
    (23, 'Salami',         80),
    (24, 'Tomate cerise',  40),
    (25, 'Mozarella',      50);

-- -----------------------------------------------------------------------------
--  Focaccias (carte + prix de vente en euros)
-- -----------------------------------------------------------------------------
INSERT INTO focaccia (id_focaccia, nom_focaccia, prix) VALUES
    (1, 'Mozaccia',        9.80),
    (2, 'Gorgonzollaccia', 10.80),
    (3, 'Raclaccia',       8.90),
    (4, 'Emmentalaccia',   9.80),
    (5, 'Tradizione',      8.90),
    (6, 'Hawaienne',       11.20),
    (7, 'Américaine',      10.80),
    (8, 'Paysanne',        12.80);

-- -----------------------------------------------------------------------------
--  Composition (focaccia <-> ingrédient + grammage réel)
--  Le grammage reprend la valeur par défaut de l'ingrédient, SAUF pour les cas
--  signalés entre parenthèses dans la carte (override), repérés ci-dessous.
-- -----------------------------------------------------------------------------

-- 1. Mozaccia
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (1, 5,  200),  -- Base Tomate
    (1, 25, 50),   -- Mozarella
    (1, 9,  20),   -- Cresson
    (1, 13, 80),   -- Jambon fumé
    (1, 1,  2),    -- Ail
    (1, 3,  20),   -- Artichaut
    (1, 7,  40),   -- Champignon
    (1, 18, 50),   -- Parmesan
    (1, 20, 1),    -- Poivre
    (1, 16, 20);   -- Olive noire

-- 2. Gorgonzollaccia
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (2, 5,  200),  -- Base Tomate
    (2, 11, 50),   -- Gorgonzola
    (2, 9,  20),   -- Cresson
    (2, 1,  2),    -- Ail
    (2, 7,  40),   -- Champignon
    (2, 18, 50),   -- Parmesan
    (2, 20, 1),    -- Poivre
    (2, 16, 20);   -- Olive noire

-- 3. Raclaccia
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (3, 5,  200),  -- Base Tomate
    (3, 22, 50),   -- Raclette
    (3, 9,  20),   -- Cresson
    (3, 1,  2),    -- Ail
    (3, 7,  40),   -- Champignon
    (3, 18, 50),   -- Parmesan
    (3, 20, 1);    -- Poivre

-- 4. Emmentalaccia
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (4, 6,  200),  -- Base crème
    (4, 10, 50),   -- Emmental
    (4, 9,  20),   -- Cresson
    (4, 7,  40),   -- Champignon
    (4, 18, 50),   -- Parmesan
    (4, 20, 1),    -- Poivre
    (4, 15, 20);   -- Oignon

-- 5. Tradizione  (overrides : champignon 80, olive noire 10, olive verte 10)
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (5, 5,  200),  -- Base Tomate
    (5, 25, 50),   -- Mozarella
    (5, 9,  20),   -- Cresson
    (5, 12, 80),   -- Jambon cuit
    (5, 7,  80),   -- Champignon (override : 80 au lieu de 40)
    (5, 18, 50),   -- Parmesan
    (5, 20, 1),    -- Poivre
    (5, 16, 10),   -- Olive noire (override : 10 au lieu de 20)
    (5, 17, 10);   -- Olive verte (override : 10 au lieu de 20)

-- 6. Hawaienne
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (6, 5,  200),  -- Base Tomate
    (6, 25, 50),   -- Mozarella
    (6, 9,  20),   -- Cresson
    (6, 4,  80),   -- Bacon
    (6, 2,  40),   -- Ananas
    (6, 19, 2),    -- Piment
    (6, 18, 50),   -- Parmesan
    (6, 20, 1),    -- Poivre
    (6, 16, 20);   -- Olive noire

-- 7. Américaine  (override : pomme de terre 40)
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (7, 5,  200),  -- Base Tomate
    (7, 25, 50),   -- Mozarella
    (7, 9,  20),   -- Cresson
    (7, 4,  80),   -- Bacon
    (7, 21, 40),   -- Pomme de terre (override : 40 au lieu de 80)
    (7, 18, 50),   -- Parmesan
    (7, 20, 1),    -- Poivre
    (7, 16, 20);   -- Olive noire

-- 8. Paysanne
INSERT INTO composition (id_focaccia, id_ingredient, quantite_g) VALUES
    (8, 6,  200),  -- Base crème
    (8, 8,  50),   -- Chevre
    (8, 9,  20),   -- Cresson
    (8, 21, 80),   -- Pomme de terre
    (8, 13, 80),   -- Jambon fumé
    (8, 1,  2),    -- Ail
    (8, 3,  20),   -- Artichaut
    (8, 7,  40),   -- Champignon
    (8, 18, 50),   -- Parmesan
    (8, 20, 1),    -- Poivre
    (8, 16, 20),   -- Olive noire
    (8, 14, 50);   -- Oeuf
