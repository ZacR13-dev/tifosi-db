# Résultats obtenus : requêtes de vérification

Sorties réelles des 10 requêtes de `sql/03_requetes.sql`, exécutées avec
l'utilisateur `tifosi` sur **MariaDB 10.11** (base peuplée par `02_data.sql`).
Aucun écart avec les résultats attendus.

---

### Requête 1 : Liste des focaccias par ordre alphabétique croissant
```
+-----------------+
| nom             |
+-----------------+
| Américaine      |
| Emmentalaccia   |
| Gorgonzollaccia |
| Hawaienne       |
| Mozaccia        |
| Paysanne        |
| Raclaccia       |
| Tradizione      |
+-----------------+
8 lignes, aucun écart.
```

### Requête 2 : Nombre total d'ingrédients
```
+----------------+
| nb_ingredients |
+----------------+
|             25 |
+----------------+
aucun écart.
```

### Requête 3 : Prix moyen des focaccias
```
+------------+
| prix_moyen |
+------------+
|      10.38 |
+------------+
aucun écart (83.00 / 8 = 10.375 → arrondi à 10.38).
```

### Requête 4 : Boissons avec leur marque, triées par nom de boisson
```
+---------------------------+-------------+
| boisson                   | marque      |
+---------------------------+-------------+
| Capri-sun                 | Coca-cola   |
| Coca-cola original        | Coca-cola   |
| Coca-cola zéro            | Coca-cola   |
| Eau de source             | Cristalline |
| Fanta citron              | Coca-cola   |
| Fanta orange              | Coca-cola   |
| Lipton Peach              | Pepsico     |
| Lipton zéro citron        | Pepsico     |
| Monster energy ultra blue | Monster     |
| Monster energy ultra gold | Monster     |
| Pepsi                     | Pepsico     |
| Pepsi Max Zéro            | Pepsico     |
+---------------------------+-------------+
12 lignes, aucun écart.
```

### Requête 5 : Ingrédients d'une Raclaccia
```
+-------------+
| ingredient  |
+-------------+
| Ail         |
| Base Tomate |
| Champignon  |
| Cresson     |
| Parmesan    |
| Poivre      |
| Raclette    |
+-------------+
7 lignes, aucun écart.
```

### Requête 6 : Nom et nombre d'ingrédients pour chaque focaccia
```
+-----------------+----------------+
| nom             | nb_ingredients |
+-----------------+----------------+
| Paysanne        |             12 |
| Mozaccia        |             10 |
| Hawaienne       |              9 |
| Tradizione      |              9 |
| Américaine      |              8 |
| Gorgonzollaccia |              8 |
| Emmentalaccia   |              7 |
| Raclaccia       |              7 |
+-----------------+----------------+
8 lignes, aucun écart.
```

### Requête 7 : Focaccia ayant le plus d'ingrédients
```
+----------+----------------+
| nom      | nb_ingredients |
+----------+----------------+
| Paysanne |             12 |
+----------+----------------+
aucun écart.
```

### Requête 8 : Focaccias contenant de l'ail
```
+-----------------+
| nom             |
+-----------------+
| Gorgonzollaccia |
| Mozaccia        |
| Paysanne        |
| Raclaccia       |
+-----------------+
4 lignes, aucun écart.
```

### Requête 9 : Ingrédients inutilisés
```
+---------------+
| nom           |
+---------------+
| Salami        |
| Tomate cerise |
+---------------+
2 lignes, aucun écart.
```

### Requête 10 : Focaccias sans champignons
```
+-------------+
| nom         |
+-------------+
| Américaine  |
| Hawaienne   |
+-------------+
2 lignes, aucun écart.
```
