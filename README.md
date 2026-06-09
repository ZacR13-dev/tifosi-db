# Base de données « Tifosi »

Conception et implémentation MySQL de la base de données du restaurant
**Tifosi** (focaccias & boissons), réalisée dans le cadre du Titre
Professionnel **Développeur Web et Web Mobile** (module *Gérer une base de
données avec MySQL*).

## Domaine modélisé

Tifosi propose une carte de **focaccias**, chacune composée de plusieurs
**ingrédients** (avec un grammage), et une carte de **boissons** rattachées à
leur **marque** commerciale.

## Schéma relationnel

```
marque      (id_marque, nom_marque)
boisson     (id_boisson, nom_boisson, #id_marque)
ingredient  (id_ingredient, nom_ingredient, quantite_defaut_g)
focaccia    (id_focaccia, nom_focaccia, prix)
composition (#id_focaccia, #id_ingredient, quantite_g)
```

La modélisation détaillée (MCD, MLD, règles de gestion, choix techniques) est
documentée dans **[docs/mcd-mld.md](docs/mcd-mld.md)**.

## Arborescence du projet

```
tifosi-db/
├── README.md
├── sql/
│   ├── 01_schema.sql      # Création de la base et des tables (DDL)
│   ├── 02_data.sql        # Insertion du jeu de données de test (DML)
│   └── 03_requetes.sql    # Requêtes de test, par complexité croissante
├── docs/
│   └── mcd-mld.md         # Modèle conceptuel et logique de données
└── data/                  # Fichiers source (.xlsx) ayant servi au recensement
```

## Mise en œuvre

Pré-requis : un serveur **MySQL 8.x** (ou MariaDB 10.5+) accessible.

### En ligne de commande

```bash
# 1. Création du schéma
mysql -u root -p < sql/01_schema.sql

# 2. Insertion des données de test
mysql -u root -p < sql/02_data.sql

# 3. Exécution des requêtes de test
mysql -u root -p tifosi < sql/03_requetes.sql
```

### Depuis un client graphique (MySQL Workbench, phpMyAdmin, DBeaver…)

Ouvrir et exécuter les trois scripts **dans l'ordre** : `01_schema.sql`, puis
`02_data.sql`, puis `03_requetes.sql`.

## Contenu des requêtes de test

Le fichier `03_requetes.sql` illustre une difficulté croissante :

| Niveau | Notions SQL illustrées |
|--------|------------------------|
| 1 — Sélections simples | `SELECT`, `WHERE`, `ORDER BY`, `LIKE`, `BETWEEN` |
| 2 — Jointures | `INNER JOIN`, jointures multiples via la table d'association |
| 3 — Agrégats | `GROUP BY`, `COUNT`, `SUM`, `AVG`, `MIN`/`MAX`, `HAVING` |
| 4 — Sous-requêtes | sous-requête scalaire, `NOT EXISTS` (anti-jointure), `CASE`, `LIMIT` |

## Données de test

- 4 marques, 12 boissons
- 25 ingrédients, 8 focaccias
- 70 lignes de composition (couples focaccia / ingrédient)

L'intégrité du jeu de données (unicité des clés primaires, résolution de
toutes les clés étrangères) a été vérifiée avant livraison.
