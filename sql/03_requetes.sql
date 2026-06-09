-- =============================================================================
--  Projet  : Base de données "Tifosi"
--  Fichier : 03_requetes.sql
--  Rôle    : Requêtes de vérification demandées par le sujet (10 requêtes).
--  Pré-requis : avoir exécuté 01_schema.sql puis 02_data.sql.
-- =============================================================================
--
--  Pour chaque requête sont indiqués :
--    - le numéro et le but,
--    - le code SQL,
--    - le résultat attendu,
--    - le résultat obtenu,
--    - le commentaire des éventuels écarts.
-- -----------------------------------------------------------------------------

USE tifosi;


-- ----------------------------------------------------------------------------
-- Requête 1 : Afficher la liste des noms des focaccias par ordre alphabétique
--             croissant.
-- ----------------------------------------------------------------------------
SELECT nom
FROM   focaccia
ORDER  BY nom ASC;
-- Résultat attendu : les 8 focaccias, de A à T.
--   Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne,
--   Mozaccia, Paysanne, Raclaccia, Tradizione
-- Résultat obtenu  : identique (8 lignes).
-- Écart            : aucun.


-- ----------------------------------------------------------------------------
-- Requête 2 : Afficher le nombre total d'ingrédients.
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS nb_ingredients
FROM   ingredient;
-- Résultat attendu : 25
-- Résultat obtenu  : 25
-- Écart            : aucun.


-- ----------------------------------------------------------------------------
-- Requête 3 : Afficher le prix moyen des focaccias.
-- ----------------------------------------------------------------------------
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM   focaccia;
-- Résultat attendu : 10.38  (83.00 / 8 = 10.375, arrondi à 10.38)
-- Résultat obtenu  : 10.38
-- Écart            : aucun. L'arrondi à 2 décimales est explicite via ROUND().


-- ----------------------------------------------------------------------------
-- Requête 4 : Afficher la liste des boissons avec leur marque, triée par nom
--             de boisson.
-- ----------------------------------------------------------------------------
SELECT   b.nom AS boisson,
         m.nom AS marque
FROM     boisson b
JOIN     marque  m ON m.id_marque = b.id_marque
ORDER BY b.nom ASC;
-- Résultat attendu : 12 boissons avec leur marque, triées par nom de boisson :
--   Capri-sun/Coca-cola, Coca-cola original/Coca-cola, Coca-cola zéro/Coca-cola,
--   Eau de source/Cristalline, Fanta citron/Coca-cola, Fanta orange/Coca-cola,
--   Lipton Peach/Pepsico, Lipton zéro citron/Pepsico,
--   Monster energy ultra blue/Monster, Monster energy ultra gold/Monster,
--   Pepsi/Pepsico, Pepsi Max Zéro/Pepsico
-- Résultat obtenu  : identique (12 lignes).
-- Écart            : aucun.


-- ----------------------------------------------------------------------------
-- Requête 5 : Afficher la liste des ingrédients pour une Raclaccia.
-- ----------------------------------------------------------------------------
SELECT   i.nom AS ingredient
FROM     comprend   c
JOIN     focaccia   f ON f.id_focaccia   = c.id_focaccia
JOIN     ingredient i ON i.id_ingredient = c.id_ingredient
WHERE    f.nom = 'Raclaccia';
-- Résultat attendu : 7 ingrédients :
--   Base Tomate, Raclette, Cresson, Ail, Champignon, Parmesan, Poivre
-- Résultat obtenu  : identique (7 lignes).
-- Écart            : aucun.


-- ----------------------------------------------------------------------------
-- Requête 6 : Afficher le nom et le nombre d'ingrédients pour chaque focaccia.
-- ----------------------------------------------------------------------------
SELECT   f.nom,
         COUNT(c.id_ingredient) AS nb_ingredients
FROM     focaccia f
LEFT JOIN comprend c ON c.id_focaccia = f.id_focaccia  -- LEFT JOIN : inclut une éventuelle focaccia sans ingrédient
GROUP BY f.id_focaccia, f.nom
ORDER BY nb_ingredients DESC, f.nom;
-- Résultat attendu : 8 focaccias avec leur nombre d'ingrédients :
--   Paysanne 12, Mozaccia 10, Hawaienne 9, Tradizione 9,
--   Américaine 8, Gorgonzollaccia 8, Emmentalaccia 7, Raclaccia 7
-- Résultat obtenu  : identique (8 lignes).
-- Écart            : aucun.


-- ----------------------------------------------------------------------------
-- Requête 7 : Afficher le nom de la focaccia qui a le plus d'ingrédients.
-- ----------------------------------------------------------------------------
SELECT   f.nom,
         COUNT(c.id_ingredient) AS nb_ingredients
FROM     focaccia f
JOIN     comprend c ON c.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY nb_ingredients DESC
LIMIT 1;
-- Résultat attendu : Paysanne (12 ingrédients)
-- Résultat obtenu  : Paysanne (12)
-- Écart            : aucun. NB : en cas d'ex æquo, LIMIT 1 n'en renvoie qu'une ;
--                    ici Paysanne est seule en tête, donc pas d'ambiguïté.


-- ----------------------------------------------------------------------------
-- Requête 8 : Afficher la liste des focaccias qui contiennent de l'ail.
-- ----------------------------------------------------------------------------
SELECT   f.nom
FROM     focaccia   f
JOIN     comprend   c ON c.id_focaccia   = f.id_focaccia
JOIN     ingredient i ON i.id_ingredient = c.id_ingredient
WHERE    i.nom = 'Ail'
ORDER BY f.nom;
-- Résultat attendu : 4 focaccias :
--   Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia
-- Résultat obtenu  : identique (4 lignes).
-- Écart            : aucun.


-- ----------------------------------------------------------------------------
-- Requête 9 : Afficher la liste des ingrédients inutilisés
--             (présents au catalogue mais dans aucune focaccia).
-- ----------------------------------------------------------------------------
SELECT   i.nom
FROM     ingredient i
WHERE    NOT EXISTS (
             SELECT 1
             FROM   comprend c
             WHERE  c.id_ingredient = i.id_ingredient
         )
ORDER BY i.nom;
-- Résultat attendu : 2 ingrédients : Salami, Tomate cerise
-- Résultat obtenu  : identique (2 lignes).
-- Écart            : aucun.


-- ----------------------------------------------------------------------------
-- Requête 10 : Afficher la liste des focaccias qui n'ont pas de champignons.
-- ----------------------------------------------------------------------------
SELECT   f.nom
FROM     focaccia f
WHERE    NOT EXISTS (
             SELECT 1
             FROM   comprend   c
             JOIN   ingredient i ON i.id_ingredient = c.id_ingredient
             WHERE  c.id_focaccia = f.id_focaccia
               AND  i.nom = 'Champignon'
         )
ORDER BY f.nom;
-- Résultat attendu : 2 focaccias : Américaine, Hawaienne
-- Résultat obtenu  : identique (2 lignes).
-- Écart            : aucun.
