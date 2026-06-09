-- =============================================================================
--  Projet  : Base de données "Tifosi"
--  Fichier : 02_data.sql
--  Rôle    : Peuplement de la base avec les données de test.
--  Pré-requis : exécuter 01_schema.sql au préalable.
-- =============================================================================
--
--  - marque, boisson, ingredient, focaccia, comprend : données issues des
--    fichiers fournis (marque.xlsx, boisson.xlsx, ingredient.xlsx, focaccia.xlsx).
--  - client, menu, contient, achete : aucune donnée n'était fournie pour ces
--    tables ; un petit jeu d'exemple (clairement identifié) est ajouté afin de
--    démontrer le bon fonctionnement des relations et des clés étrangères.
--
--  Les identifiants sont insérés explicitement pour garder des clés étrangères
--  stables et lisibles.
-- -----------------------------------------------------------------------------

USE tifosi;

-- Nettoyage (ordre inverse des dépendances) pour rendre le script ré-exécutable.
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE achete;
TRUNCATE TABLE contient;
TRUNCATE TABLE comprend;
TRUNCATE TABLE menu;
TRUNCATE TABLE boisson;
TRUNCATE TABLE focaccia;
TRUNCATE TABLE ingredient;
TRUNCATE TABLE marque;
TRUNCATE TABLE client;
SET FOREIGN_KEY_CHECKS = 1;


-- #############################################################################
--  DONNÉES ISSUES DES FICHIERS FOURNIS
-- #############################################################################

-- ----- marque.xlsx -----------------------------------------------------------
INSERT INTO marque (id_marque, nom) VALUES
    (1, 'Coca-cola'),
    (2, 'Cristalline'),
    (3, 'Monster'),
    (4, 'Pepsico');

-- ----- boisson.xlsx (la colonne « marque » est résolue en id_marque) ---------
INSERT INTO boisson (id_boisson, nom, id_marque) VALUES
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

-- ----- ingredient.xlsx -------------------------------------------------------
INSERT INTO ingredient (id_ingredient, nom) VALUES
    (1,  'Ail'),            (2,  'Ananas'),       (3,  'Artichaut'),
    (4,  'Bacon'),          (5,  'Base Tomate'),  (6,  'Base crème'),
    (7,  'Champignon'),     (8,  'Chevre'),       (9,  'Cresson'),
    (10, 'Emmental'),       (11, 'Gorgonzola'),   (12, 'Jambon cuit'),
    (13, 'Jambon fumé'),    (14, 'Oeuf'),         (15, 'Oignon'),
    (16, 'Olive noire'),    (17, 'Olive verte'),  (18, 'Parmesan'),
    (19, 'Piment'),         (20, 'Poivre'),       (21, 'Pomme de terre'),
    (22, 'Raclette'),       (23, 'Salami'),       (24, 'Tomate cerise'),
    (25, 'Mozarella');

-- ----- focaccia.xlsx (nom + prix) --------------------------------------------
INSERT INTO focaccia (id_focaccia, nom, prix) VALUES
    (1, 'Mozaccia',        9.80),
    (2, 'Gorgonzollaccia', 10.80),
    (3, 'Raclaccia',       8.90),
    (4, 'Emmentalaccia',   9.80),
    (5, 'Tradizione',      8.90),
    (6, 'Hawaienne',       11.20),
    (7, 'Américaine',      10.80),
    (8, 'Paysanne',        12.80);

-- ----- comprend : composition des focaccias (focaccia.xlsx) ------------------
--  quantite en grammes ; les valeurs entre parenthèses dans la carte sont des
--  quantités spécifiques (override) signalées en commentaire.
INSERT INTO comprend (id_focaccia, id_ingredient, quantite) VALUES
    -- 1. Mozaccia
    (1, 5, 200), (1, 25, 50), (1, 9, 20), (1, 13, 80), (1, 1, 2),
    (1, 3, 20),  (1, 7, 40),  (1, 18, 50), (1, 20, 1), (1, 16, 20),
    -- 2. Gorgonzollaccia
    (2, 5, 200), (2, 11, 50), (2, 9, 20), (2, 1, 2), (2, 7, 40),
    (2, 18, 50), (2, 20, 1),  (2, 16, 20),
    -- 3. Raclaccia
    (3, 5, 200), (3, 22, 50), (3, 9, 20), (3, 1, 2), (3, 7, 40),
    (3, 18, 50), (3, 20, 1),
    -- 4. Emmentalaccia
    (4, 6, 200), (4, 10, 50), (4, 9, 20), (4, 7, 40), (4, 18, 50),
    (4, 20, 1),  (4, 15, 20),
    -- 5. Tradizione (champignon 80, olive noire 10, olive verte 10)
    (5, 5, 200), (5, 25, 50), (5, 9, 20), (5, 12, 80), (5, 7, 80),
    (5, 18, 50), (5, 20, 1),  (5, 16, 10), (5, 17, 10),
    -- 6. Hawaienne
    (6, 5, 200), (6, 25, 50), (6, 9, 20), (6, 4, 80), (6, 2, 40),
    (6, 19, 2),  (6, 18, 50), (6, 20, 1), (6, 16, 20),
    -- 7. Américaine (pomme de terre 40)
    (7, 5, 200), (7, 25, 50), (7, 9, 20), (7, 4, 80), (7, 21, 40),
    (7, 18, 50), (7, 20, 1),  (7, 16, 20),
    -- 8. Paysanne
    (8, 6, 200), (8, 8, 50),  (8, 9, 20), (8, 21, 80), (8, 13, 80),
    (8, 1, 2),   (8, 3, 20),  (8, 7, 40), (8, 18, 50), (8, 20, 1),
    (8, 16, 20), (8, 14, 50);


-- #############################################################################
--  JEU D'EXEMPLE (aucune donnée fournie pour ces tables — données fictives)
-- #############################################################################

-- ----- client ----------------------------------------------------------------
INSERT INTO client (id_client, nom, email, code_postal) VALUES
    (1, 'Dupont',  'dupont@example.com',  75001),
    (2, 'Martin',  'martin@example.com',  69002),
    (3, 'Bernard', 'bernard@example.com', 13008);

-- ----- menu : chaque menu repose sur une focaccia (1,1) ----------------------
INSERT INTO menu (id_menu, nom, prix, id_focaccia) VALUES
    (1, 'Menu Mozaccia',   13.50, 1),  -- focaccia Mozaccia
    (2, 'Menu Hawaienne',  14.90, 6),  -- focaccia Hawaienne
    (3, 'Menu Paysanne',   16.00, 8);  -- focaccia Paysanne

-- ----- contient : boissons incluses dans chaque menu (N..N) ------------------
INSERT INTO contient (id_menu, id_boisson) VALUES
    (1, 1),  (1, 12),          -- Menu Mozaccia  : Coca-cola zéro + Eau de source
    (2, 3),  (2, 12),          -- Menu Hawaienne : Fanta citron + Eau de source
    (3, 6),  (3, 10), (3, 12); -- Menu Paysanne  : Pepsi + Monster gold + Eau de source

-- ----- achete : achats de menus par les clients (N..N + date) ----------------
INSERT INTO achete (id_client, id_menu, date_achat) VALUES
    (1, 1, '2026-06-01'),
    (1, 3, '2026-06-05'),
    (2, 2, '2026-06-03'),
    (3, 1, '2026-06-07'),
    (3, 2, '2026-06-07');
