-- =============================================================================
--  Projet  : Base de données "Tifosi"
--  Fichier : 03_requetes.sql
--  Rôle    : Requêtes de test, classées par ordre de complexité croissante.
--  Pré-requis : avoir exécuté 01_schema.sql puis 02_data.sql.
-- =============================================================================
--
--  Chaque requête est précédée d'un commentaire indiquant son objectif et la
--  notion SQL illustrée. Exécuter les requêtes une à une pour observer le
--  résultat de chacune.
--
-- -----------------------------------------------------------------------------

USE tifosi;


-- =====================  NIVEAU 1 : SÉLECTIONS SIMPLES  =======================

-- R1. Toutes les focaccias de la carte, de la moins chère à la plus chère.
--     Notions : SELECT, ORDER BY.
SELECT nom_focaccia, prix
FROM   focaccia
ORDER  BY prix ASC;

-- R2. Les boissons « zéro / light » (recherche textuelle insensible à la casse).
--     Notions : WHERE, LIKE.
SELECT nom_boisson
FROM   boisson
WHERE  nom_boisson LIKE '%zéro%'
    OR nom_boisson LIKE '%max%';

-- R3. Les focaccias dont le prix est compris entre 9 et 11 euros.
--     Notions : WHERE, BETWEEN.
SELECT nom_focaccia, prix
FROM   focaccia
WHERE  prix BETWEEN 9 AND 11
ORDER  BY prix;


-- =====================  NIVEAU 2 : JOINTURES  ================================

-- R4. Chaque boisson avec le nom de sa marque.
--     Notions : INNER JOIN (relation 1..N marque -> boisson).
SELECT   b.nom_boisson,
         m.nom_marque
FROM     boisson b
JOIN     marque  m ON m.id_marque = b.id_marque
ORDER BY m.nom_marque, b.nom_boisson;

-- R5. Composition détaillée de la focaccia « Paysanne » (ingrédients + grammage).
--     Notions : double jointure via la table d'association, filtre WHERE.
SELECT   f.nom_focaccia,
         i.nom_ingredient,
         c.quantite_g
FROM     composition c
JOIN     focaccia   f ON f.id_focaccia   = c.id_focaccia
JOIN     ingredient i ON i.id_ingredient = c.id_ingredient
WHERE    f.nom_focaccia = 'Paysanne'
ORDER BY c.quantite_g DESC;

-- R6. Toutes les focaccias contenant de la Mozarella.
--     Notions : jointure N..N + filtre sur l'ingrédient.
SELECT   f.nom_focaccia, f.prix
FROM     focaccia   f
JOIN     composition c ON c.id_focaccia   = f.id_focaccia
JOIN     ingredient  i ON i.id_ingredient = c.id_ingredient
WHERE    i.nom_ingredient = 'Mozarella'
ORDER BY f.nom_focaccia;


-- =====================  NIVEAU 3 : AGRÉGATS  ================================

-- R7. Nombre de boissons par marque.
--     Notions : GROUP BY, COUNT.
SELECT   m.nom_marque,
         COUNT(b.id_boisson) AS nb_boissons
FROM     marque  m
LEFT JOIN boisson b ON b.id_marque = m.id_marque  -- LEFT JOIN : inclut les marques sans boisson
GROUP BY m.id_marque, m.nom_marque
ORDER BY nb_boissons DESC;

-- R8. Prix moyen, minimum et maximum des focaccias.
--     Notions : fonctions d'agrégat AVG / MIN / MAX, arrondi.
SELECT   ROUND(AVG(prix), 2) AS prix_moyen,
         MIN(prix)           AS prix_min,
         MAX(prix)           AS prix_max
FROM     focaccia;

-- R9. Nombre d'ingrédients et poids total (en grammes) de chaque focaccia.
--     Notions : GROUP BY, COUNT, SUM.
SELECT   f.nom_focaccia,
         COUNT(c.id_ingredient) AS nb_ingredients,
         SUM(c.quantite_g)      AS poids_total_g
FROM     focaccia    f
JOIN     composition c ON c.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY poids_total_g DESC;

-- R10. Les ingrédients les plus utilisés (présents dans au moins 4 focaccias).
--      Notions : GROUP BY, COUNT, HAVING (filtre sur un agrégat).
SELECT   i.nom_ingredient,
         COUNT(c.id_focaccia) AS nb_focaccias
FROM     ingredient  i
JOIN     composition c ON c.id_ingredient = i.id_ingredient
GROUP BY i.id_ingredient, i.nom_ingredient
HAVING   COUNT(c.id_focaccia) >= 4
ORDER BY nb_focaccias DESC;


-- =====================  NIVEAU 4 : SOUS-REQUÊTES & + COMPLEXE  ===============

-- R11. La (ou les) focaccia(s) la(les) plus chère(s) de la carte.
--      Notions : sous-requête dans le WHERE.
SELECT nom_focaccia, prix
FROM   focaccia
WHERE  prix = (SELECT MAX(prix) FROM focaccia);

-- R12. Les ingrédients du catalogue qui ne sont utilisés dans AUCUNE focaccia.
--      Notions : sous-requête corrélée avec NOT EXISTS (anti-jointure).
SELECT   i.nom_ingredient
FROM     ingredient i
WHERE    NOT EXISTS (
             SELECT 1
             FROM   composition c
             WHERE  c.id_ingredient = i.id_ingredient
         )
ORDER BY i.nom_ingredient;

-- R13. Les focaccias « végétariennes » (ne contenant ni viande ni charcuterie).
--      Notions : anti-jointure NOT EXISTS avec liste d'exclusion.
SELECT   f.nom_focaccia
FROM     focaccia f
WHERE    NOT EXISTS (
             SELECT 1
             FROM   composition c
             JOIN   ingredient  i ON i.id_ingredient = c.id_ingredient
             WHERE  c.id_focaccia = f.id_focaccia
               AND  i.nom_ingredient IN ('Bacon', 'Salami', 'Jambon cuit', 'Jambon fumé')
         )
ORDER BY f.nom_focaccia;

-- R14. Les ingrédients dont le grammage a été personnalisé sur une focaccia
--      (quantité réelle différente de la quantité par défaut du catalogue).
--      Notions : jointure + comparaison de colonnes de deux tables.
SELECT   f.nom_focaccia,
         i.nom_ingredient,
         i.quantite_defaut_g           AS grammage_standard,
         c.quantite_g                  AS grammage_utilise
FROM     composition c
JOIN     focaccia   f ON f.id_focaccia   = c.id_focaccia
JOIN     ingredient i ON i.id_ingredient = c.id_ingredient
WHERE    c.quantite_g <> i.quantite_defaut_g
ORDER BY f.nom_focaccia, i.nom_ingredient;

-- R15. Prix de chaque focaccia comparé au prix moyen de la carte.
--      Notions : sous-requête scalaire dans le SELECT, expression conditionnelle.
SELECT   nom_focaccia,
         prix,
         (SELECT ROUND(AVG(prix), 2) FROM focaccia) AS prix_moyen_carte,
         CASE
             WHEN prix > (SELECT AVG(prix) FROM focaccia) THEN 'Au-dessus de la moyenne'
             WHEN prix < (SELECT AVG(prix) FROM focaccia) THEN 'En-dessous de la moyenne'
             ELSE 'Dans la moyenne'
         END AS positionnement
FROM     focaccia
ORDER BY prix DESC;

-- R16. Le « top 3 » des focaccias les plus riches en ingrédients.
--      Notions : GROUP BY + ORDER BY + LIMIT.
SELECT   f.nom_focaccia,
         COUNT(c.id_ingredient) AS nb_ingredients
FROM     focaccia    f
JOIN     composition c ON c.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY nb_ingredients DESC, f.nom_focaccia
LIMIT 3;
