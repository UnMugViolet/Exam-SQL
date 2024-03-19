# Gestionnaire de cinéma

## Table des matières
- [Installation](#installation)
- [Conception](#conception)
- [Utilisation](#utilisation)
- [Remarques](#remarques)

## Installation <a name="installation"></a>
Pour installer ce projet, suivez ces étapes...

### 1. Cloner le repo

```bash
git clone https://github.com/UnMugViolet/Exam-SQL.git
```

### 2. Aller dans le dossier du projet 

```bash
cd ./Exam-SQL
```

### 3. Créer la structure de base de donnée

```bash
mysql -u username -p < schema.sql
```

### 4. Insérer le jeu de donnée dans la base de donnée

```bash
mysql -u username -p < data.sql
```

## Conception <a name="conception"></a>
Diagram réalisé avec MySQL Workbench :
<img src="./images/EER_Diagram- Paul Jaguin.png">

## Utilisation <a name="utilisation"></a>

### 1. Retirer le jeu de donnée 

```bash
mysql -u username -p < drop-table-content.sql
```

### 2. Drop la base de donnée :)

```bash
mysql -u username -p < give-a-mark-of-10-out-of-10.sql
```

### Avant d'importer le CSV

Ouvrir le dossier de mysql
```bash
sudo xdg-open /var/lib/mysql-files/
```

Coller le csv dans le dossier de destination

Puis executer les 

## Remarques <a name="remarques"></a>

#### 1. Changement nature de donnée licence
La licence est dans une table à part et décomposée en deux colonnes.
Il faudra demander au gestionnaire de cinema de fournir une date de début et date de fin à la place d'une durée en semaine car, la date de lancement du film n'est pas nécessairement la date de début d'exploitation.
_ex : Je peux avoir mon permis de conduire le 20 juin, je n'ai pas le droit de conduire le 19, mais je ne suis pas obligé de conduire le 20, je peux très bien commencer à conduire le 23. Cependant mon autorisation date quand même du 20._

Dans notre cas cela se matérialise par le fait qu'on ne puisse pas se baser sur la date de sortie comme étant la date de début d'exploitation.

#### 2. Pourquoi créer une table visiteur ? 
La table visiteur est inutile car la gestion de vente de tickets se fait uniquement en présentiel. 
Elle est tout de même utile pour déterminer la capacité maximale de la salle. 
Le fait de la créer maintenant a pour avantage de rendre la base de donnée plus modulaire, dans le sens où il suffira de rajouter les colonnes gérant la reservation dans visiteur pour pouvoir avoir une vente en ligne par visiteur. 
