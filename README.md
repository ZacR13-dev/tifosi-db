# Base de données « Tifosi »

Conception et implémentation, sous **MySQL / MariaDB**, de la base de données du
restaurant de street-food italien **Le Tifosi**, à partir du MCD fourni par le
client. Projet réalisé dans le cadre du Titre Professionnel **Développeur Web et
Web Mobile** (module *Gérer une base de données avec MySQL*).

## Domaine modélisé

Le Tifosi gère ses **focaccias** (composées d'**ingrédients**), ses **boissons**
(rattachées à une **marque**), ses **menus** (une focaccia + des boissons) et les
**achats** de menus par les **clients**.

## Schéma relationnel

```
client      (id_client, nom, email, code_postal)
marque      (id_marque, nom)
ingredient  (id_ingredient, nom)
focaccia    (id_focaccia, nom, prix)
boisson     (id_boisson, nom, #id_marque)
menu        (id_menu, nom, prix, #id_focaccia)
comprend    (#id_focaccia, #id_ingredient, quantite)   -- N..N focaccia/ingrédient
contient    (#id_menu, #id_boisson)                    -- N..N menu/boisson
achete      (#id_client, #id_menu, date_achat)         -- N..N client/menu
```

Le détail de la modélisation (MCD fourni, règles de gestion, passage au MLD,
choix de sécurité et techniques) est documenté dans
**[docs/mcd-mld.md](docs/mcd-mld.md)**.

## Arborescence du projet

```
tifosi-db/
├── README.md
├── sql/
│   ├── 01_schema.sql      # Base + utilisateur 'tifosi' + tables (DDL)
│   ├── 02_data.sql        # Peuplement (données fournies + jeu d'exemple)
│   └── 03_requetes.sql    # Les 10 requêtes de vérification du sujet
├── docs/
│   └── mcd-mld.md         # MCD fourni, MLD et choix de conception
└── data/                  # Fichiers source (.xlsx) fournis pour le peuplement
```

## Mise en œuvre

Pré-requis : un serveur **MySQL 8.x** ou **MariaDB 10.x** accessible.

```bash
# 1. Création de la base, de l'utilisateur 'tifosi' et du schéma
mysql -u root -p < sql/01_schema.sql

# 2. Peuplement de la base
mysql -u root -p < sql/02_data.sql

# 3. Exécution des 10 requêtes de vérification
mysql -u tifosi -p tifosi < sql/03_requetes.sql
```

> Depuis un client graphique (MySQL Workbench, phpMyAdmin, HeidiSQL, DBeaver…) :
> exécuter les trois scripts **dans l'ordre** `01` → `02` → `03`.

### Utilisateur de la base

Le script `01_schema.sql` crée un utilisateur dédié à l'administration de la
base `tifosi` :

| Identifiant | Mot de passe | Droits |
|-------------|--------------|--------|
| `tifosi`    | `Tifosi#2025` | `ALL PRIVILEGES` sur `tifosi.*` uniquement |

## Données de test

- **Fournies (xlsx)** : 4 marques, 12 boissons, 25 ingrédients, 8 focaccias,
  70 lignes de composition (`comprend`).
- **Jeu d'exemple** (aucun fichier fourni pour ces tables) : 3 clients, 3 menus,
  7 lignes `contient`, 5 lignes `achete` — pour démontrer les relations.

## Vérification

Les 3 scripts ont été **exécutés sans erreur** sur MariaDB 10.11, et les **10
requêtes du sujet renvoient toutes le résultat attendu** (résultats détaillés en
commentaire dans `sql/03_requetes.sql`, et regroupés dans
**[docs/resultats.md](docs/resultats.md)**). L'intégrité des clés a été contrôlée.
