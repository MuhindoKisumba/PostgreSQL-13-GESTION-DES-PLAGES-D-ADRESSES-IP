# README
## Projet : Gestion des Plages d'Adresses IP sous PostgreSQL

### Auteur
**MUHINDO KISUMBA ABDIEL**

### Version
1.0

### SGBD
PostgreSQL 13 ou version supérieure

---

# Présentation

Ce projet permet de gérer efficacement les plages d'adresses IPv4 d'une organisation à l'aide des fonctionnalités natives de PostgreSQL.

Le script exploite le type de données **INET** afin d'assurer une gestion fiable des adresses IP sans recourir à des conversions manuelles.

Le projet facilite notamment :

- la création des plages d'adresses IP ;
- la gestion des VLAN ;
- l'association des plages aux différents services ;
- le calcul automatique du nombre d'adresses disponibles ;
- la recherche rapide d'une adresse IP dans une plage ;
- la production de statistiques réseau.

---

# Objectifs

Les principaux objectifs du projet sont :

- centraliser les informations des plages IPv4 ;
- assurer la cohérence des données ;
- simplifier les recherches d'adresses IP ;
- faciliter l'administration des réseaux ;
- fournir une base exploitable pour des applications d'inventaire réseau.

---

# Fonctionnalités

Le script comporte les fonctionnalités suivantes :

- création automatique de la table principale ;
- suppression sécurisée de l'ancienne table ;
- création des index d'optimisation ;
- insertion de données d'exemple ;
- conversion des adresses IPv4 en entier (BIGINT) ;
- calcul automatique du nombre d'adresses disponibles ;
- recherche d'une adresse IP dans une plage ;
- recherche par VLAN ;
- recherche par service ;
- affichage des plages actives ;
- mise à jour des informations ;
- désactivation d'une plage ;
- génération de statistiques.

---

# Structure de la table

La table **plage_ip** contient les informations suivantes :

| Colonne | Description |
|----------|-------------|
| id_plage | Identifiant unique |
| nom_plage | Nom de la plage |
| adresse_debut | Première adresse IP |
| adresse_fin | Dernière adresse IP |
| masque | Masque CIDR |
| passerelle | Passerelle par défaut |
| dns_primaire | DNS principal |
| dns_secondaire | DNS secondaire |
| vlan | Numéro VLAN |
| localisation | Emplacement physique |
| service | Service concerné |
| commentaire | Informations complémentaires |
| active | Etat de la plage |
| date_creation | Date de création |

---

# Contraintes

Le projet applique plusieurs contraintes :

- clé primaire sur chaque plage ;
- masque compris entre 0 et 32 ;
- adresse de début inférieure ou égale à l'adresse de fin ;
- type INET pour toutes les adresses IP.

---

# Index créés

Le script crée plusieurs index afin d'améliorer les performances :

- idx_ip_debut
- idx_ip_fin
- idx_service

Ces index accélèrent les recherches sur les adresses IP et les services.

---

# Fonction SQL

Le projet contient la fonction :

```
ip_to_bigint(inet)
```

Cette fonction convertit une adresse IPv4 en entier BIGINT.

Cette conversion permet :

- le calcul du nombre total d'adresses ;
- les comparaisons numériques ;
- les statistiques réseau.

---

# Vue créée

Le script crée la vue :

```
vw_plage_ip
```

Cette vue affiche automatiquement :

- les informations de la plage ;
- le VLAN ;
- le service ;
- la localisation ;
- le nombre total d'adresses disponibles.

---

# Requêtes disponibles

Le projet fournit plusieurs exemples de requêtes.

## Recherche d'une adresse IP

```
SELECT *
FROM plage_ip
WHERE '192.168.2.45'::inet
BETWEEN adresse_debut AND adresse_fin;
```

---

## Affichage de toutes les plages

```
SELECT *
FROM vw_plage_ip;
```

---

## Recherche par VLAN

```
SELECT *
FROM plage_ip
WHERE vlan = 20;
```

---

## Recherche par service

```
SELECT *
FROM plage_ip
WHERE service ILIKE '%Administration%';
```

---

## Plages actives

```
SELECT *
FROM plage_ip
WHERE active = TRUE;
```

---

## Statistiques

Le script calcule automatiquement :

- le nombre de plages ;
- le nombre total d'adresses IP ;
- la première adresse IP enregistrée ;
- la dernière adresse IP enregistrée.

---

# Données d'essai

Le projet insère plusieurs exemples représentant différents environnements :

- Administration
- Finance
- Ressources Humaines
- Infrastructure
- Réseau Invités
- Caméras IP
- Téléphonie IP

Ces données permettent de tester immédiatement le fonctionnement du projet.

---

# Domaines d'utilisation

Cette base de données peut être utilisée pour :

- l'administration réseau ;
- les centres de données ;
- les entreprises ;
- les administrations publiques ;
- les universités ;
- les écoles ;
- les hôpitaux ;
- les fournisseurs d'accès Internet ;
- les opérateurs télécoms ;
- les réseaux d'entreprise.

---

# Avantages

Le projet présente plusieurs avantages :

- utilisation du type INET natif de PostgreSQL ;
- structure simple et facilement extensible ;
- bonnes performances grâce aux index ;
- calcul automatique des plages IP ;
- forte cohérence des données ;
- maintenance simplifiée ;
- compatible avec PostgreSQL 13 et versions supérieures.

---

# Compatibilité

Le script est compatible avec :

- PostgreSQL 13
- PostgreSQL 14
- PostgreSQL 15
- PostgreSQL 16
- PostgreSQL 17
- PostgreSQL 18

---

# Installation

1. Ouvrir pgAdmin ou psql.
2. Se connecter à la base de données.
3. Exécuter le script SQL complet.
4. Vérifier la création de la table.
5. Vérifier la création de la vue.
6. Vérifier la création de la fonction.
7. Tester les requêtes fournies.

---

# Évolutions possibles

Le projet peut être enrichi avec :

- prise en charge IPv6 ;
- gestion des sous-réseaux ;
- gestion des équipements réseau ;
- gestion des adresses MAC ;
- réservation automatique d'adresses IP ;
- historique des affectations ;
- journalisation des modifications ;
- gestion DHCP ;
- supervision réseau ;
- tableaux de bord PostgreSQL ;
- intégration avec Grafana ;
- API REST ;
- application Web d'administration.

---

# Licence

Projet pédagogique et professionnel destiné à la gestion des plages d'adresses IP sous PostgreSQL.
