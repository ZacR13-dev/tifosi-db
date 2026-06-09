# 🍕 Base de données « Tifosi »

Conception et implémentation, sous **MySQL / MariaDB**, de la base de données du
restaurant de street-food italien **Le Tifosi**, à partir du MCD fourni par le
client.

> Projet réalisé dans le cadre du **Titre Professionnel Développeur Web et Web
> Mobile (DWWM)**, module *Gérer une base de données avec MySQL*.

---

## Sommaire

- [1. Contexte & mission](#1-contexte--mission)
- [2. Modèle de données (MCD)](#2-modèle-de-données-mcd)
- [3. Schéma relationnel (MLD)](#3-schéma-relationnel-mld)
- [4. Arborescence du projet](#4-arborescence-du-projet)
- [5. Installation & exécution](#5-installation--exécution)
- [6. Utilisateur de la base](#6-utilisateur-de-la-base)
- [7. Données de test](#7-données-de-test)
- [8. Requêtes de vérification](#8-requêtes-de-vérification)
- [9. Vérification & tests réalisés](#9-vérification--tests-réalisés)
- [10. Compétences couvertes (référentiel DWWM)](#10-compétences-couvertes-référentiel-dwwm)

---

## 1. Contexte & mission

Le Tifosi souhaite une base de données dynamique, hébergée en local, pour gérer
ses **focaccias** (composées d'**ingrédients**), ses **boissons** (rattachées à
une **marque**), ses **menus** (une focaccia + des boissons) et les **achats**
de menus par les **clients**.

La mission consiste à :

1. créer la base `tifosi` et un **utilisateur d'administration** dédié ;
2. construire le **schéma** à partir du MCD fourni, en soignant la sécurité
   (champs obligatoires, contraintes d'intégrité, valeurs uniques) ;
3. **peupler** la base à partir des fichiers fournis ;
4. **vérifier** la base à l'aide de 10 requêtes de test.

## 2. Modèle de données (MCD)

MCD fourni par le client (détail des cardinalités, règles de gestion et passage
au MLD dans **[docs/mcd-mld.md](docs/mcd-mld.md)**) :

![MCD du restaurant Tifosi](docs/mcd.png)

## 3. Schéma relationnel (MLD)

```
client      (id_client, nom, email, code_postal)
marque      (id_marque, nom)
ingredient  (id_ingredient, nom)
focaccia    (id_focaccia, nom, prix)
boisson     (id_boisson, nom, #id_marque)
menu        (id_menu, nom, prix, #id_focaccia)
comprend    (#id_focaccia, #id_ingredient, quantite)   -- N..N focaccia / ingrédient
contient    (#id_menu, #id_boisson)                    -- N..N menu / boisson
achete      (#id_client, #id_menu, date_achat)         -- N..N client / menu
```

`#` = clé étrangère. Les associations N..N du MCD (`comprend`, `contient`,
`achete`) deviennent des tables de jonction ; les associations 1..N
(`appartient`, `est constitué`) deviennent des clés étrangères.

## 4. Arborescence du projet

```
tifosi-db/
├── README.md
├── sql/
│   ├── 01_schema.sql      # Base + utilisateur 'tifosi' + tables (DDL)
│   ├── 02_data.sql        # Peuplement (données fournies + jeu d'exemple)
│   └── 03_requetes.sql    # Les 10 requêtes de vérification du sujet
├── docs/
│   ├── mcd.png            # MCD fourni
│   ├── mcd-mld.md         # MCD, MLD et choix de conception
│   └── resultats.md       # Sorties réelles des 10 requêtes
└── data/                  # Fichiers source (.xlsx) fournis pour le peuplement
```

## 5. Installation & exécution

Pré-requis : un serveur **MySQL 8.x** ou **MariaDB 10.x** accessible.

Exécuter les trois scripts **dans l'ordre** :

```bash
# 1. Création de la base, de l'utilisateur 'tifosi' et du schéma
mysql -u root -p < sql/01_schema.sql

# 2. Peuplement de la base
mysql -u root -p < sql/02_data.sql

# 3. Exécution des 10 requêtes de vérification
mysql -u tifosi -p tifosi < sql/03_requetes.sql
```

> Depuis un client graphique (MySQL Workbench, phpMyAdmin, HeidiSQL, DBeaver…) :
> ouvrir puis exécuter `01` → `02` → `03`.

## 6. Utilisateur de la base

Le script `01_schema.sql` crée un utilisateur dédié, limité à la base `tifosi`
(principe de moindre privilège, aucun droit global serveur) :

| Identifiant | Mot de passe  | Droits                              |
|-------------|---------------|-------------------------------------|
| `tifosi`    | `Tifosi#2025` | `ALL PRIVILEGES` sur `tifosi.*`     |

## 7. Données de test

| Origine | Tables | Volume |
|---------|--------|--------|
| **Fichiers fournis** (`*.xlsx`) | marque, boisson, ingredient, focaccia, comprend | 4 / 12 / 25 / 8 / 70 lignes |
| **Jeu d'exemple** (aucun fichier fourni) | client, menu, contient, achete | 3 / 3 / 7 / 5 lignes |

Le jeu d'exemple, clairement identifié dans `02_data.sql`, sert uniquement à
démontrer le bon fonctionnement des relations et des clés étrangères.

## 8. Requêtes de vérification

`sql/03_requetes.sql` regroupe les **10 requêtes** demandées. Pour chacune sont
indiqués, comme l'exige le sujet : le **numéro et le but**, le **code SQL**, le
**résultat attendu**, le **résultat obtenu** et le **commentaire des écarts**.

| N° | Objet |
|----|-------|
| 1 | Focaccias par ordre alphabétique |
| 2 | Nombre total d'ingrédients |
| 3 | Prix moyen des focaccias |
| 4 | Boissons avec leur marque (triées) |
| 5 | Ingrédients d'une Raclaccia |
| 6 | Nombre d'ingrédients par focaccia |
| 7 | Focaccia ayant le plus d'ingrédients |
| 8 | Focaccias contenant de l'ail |
| 9 | Ingrédients inutilisés |
| 10 | Focaccias sans champignons |

Les sorties réelles sont regroupées dans **[docs/resultats.md](docs/resultats.md)**.

## 9. Vérification & tests réalisés

Les 3 scripts ont été **exécutés sans erreur** sur **MariaDB 10.11** :

- base et utilisateur `tifosi` créés ; **connexion en tant que `tifosi`
  confirmée** ;
- peuplement complet, **intégrité des clés contrôlée** (aucune clé étrangère
  orpheline, aucun doublon de clé primaire) ;
- les **10 requêtes renvoient toutes le résultat attendu** (0 écart).

## 10. Compétences couvertes (référentiel DWWM)

> Développer la partie back-end d'une application web sécurisée. *Mettre en
> place une base de données relationnelle* :

- recensement et organisation des informations du domaine ;
- conception physique (tables, types, clés, index) ;
- instructions de **création / modification / suppression** ;
- requêtes SQL de complexité variable (sélections, jointures, agrégats,
  sous-requêtes / anti-jointures) ;
- prise en compte de la **sécurité** (utilisateur dédié, contraintes
  d'intégrité, valeurs uniques).
