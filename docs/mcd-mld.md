# Du MCD au schéma de la base

## Le MCD de départ

Voici le modèle conceptuel fourni avec le sujet. C'est lui qui m'a servi de base
pour construire la base de données.

![MCD du restaurant Tifosi](mcd.png)

On y trouve 6 entités : `client`, `marque`, `ingredient`, `focaccia`, `menu` et
`boisson`. Et 5 associations entre elles : `comprend`, `appartient`,
`est constitué`, `contient` et `achete`.

## Comment j'ai lu le modèle

En partant des cardinalités du MCD :

- Une focaccia est faite de plusieurs ingrédients, et un même ingrédient peut se
  retrouver dans plusieurs focaccias (ou dans aucune). C'est du plusieurs à
  plusieurs, avec en plus une quantité. C'est l'association `comprend`.
- Une boisson appartient à une seule marque, mais une marque a plusieurs
  boissons.
- Un menu est construit autour d'une seule focaccia, et une focaccia peut servir
  à plusieurs menus.
- Un menu contient plusieurs boissons, et une boisson peut être dans plusieurs
  menus.
- Un client peut acheter plusieurs menus, et un menu peut être acheté par
  plusieurs clients, à une date donnée. C'est l'association `achete`.

## Le schéma obtenu (MLD)

Pour passer au schéma réel, les associations "plusieurs à plusieurs"
(`comprend`, `contient`, `achete`) deviennent des tables à part entière. Les
associations "un à plusieurs" (`appartient`, `est constitué`) deviennent juste
une clé étrangère dans la table concernée.

Ce qui donne 9 tables (`#` = clé étrangère) :

```
client      (id_client, nom, email, code_postal)
marque      (id_marque, nom)
ingredient  (id_ingredient, nom)
focaccia    (id_focaccia, nom, prix)
boisson     (id_boisson, nom, #id_marque)
menu        (id_menu, nom, prix, #id_focaccia)
comprend    (#id_focaccia, #id_ingredient, quantite)
contient    (#id_menu, #id_boisson)
achete      (#id_client, #id_menu, date_achat)
```

## Les choix que j'ai faits

Côté sécurité et intégrité, comme demandé dans le sujet :

- un utilisateur `tifosi` dédié, avec les droits uniquement sur sa base et pas
  sur tout le serveur ;
- les champs importants en `NOT NULL` (noms, prix, dates, clés étrangères) ;
- des `UNIQUE` sur les noms et sur l'email d'un client, pour éviter les doublons ;
- des clés étrangères partout pour garder les liens cohérents ;
- un `CHECK (prix > 0)` pour ne pas avoir de prix négatif.

Quelques détails techniques :

- les prix sont en `DECIMAL(5,2)`, plus fiable que les nombres à virgule pour de
  l'argent ;
- la quantité d'un ingrédient est stockée dans la table `comprend`, parce
  qu'elle dépend de la focaccia (une même base tomate peut être dosée
  différemment d'une focaccia à l'autre) ;
- la date d'achat fait partie de la clé de `achete`, comme ça un client peut
  racheter le même menu un autre jour sans souci ;
- tout est en `InnoDB` et `utf8mb4` pour gérer les clés étrangères et les accents.
