

# Projet de Compilation avec FLEX et Bison

## Introduction

Ce projet vise à créer un mini-compilateur prenant en charge différentes étapes de compilation, incluant l'analyse lexicale avec FLEX, l'analyse syntaxico-sémantique avec Bison, la génération de code intermédiaire, l'optimisation et la génération de code objet. Le projet gère également la table des symboles et le traitement des erreurs durant les différentes phases de compilation.

## Description du Langage

### Structure d'un Programme

Un programme est composé de plusieurs fonctions et d'un programme principal :

```
Fonction_1
Fonction_2
...
Fonction_n
Programme_principal
```

#### Programme Principal

```
PROGRAM nom_programme_principal
% Déclarations
% Instructions
END
```

#### Fonctions

```
type ROUTINE nom_fonction (liste_paramètres)
% Déclarations
% Instructions
nom_fonction = valeur retournée
ENDR
```

### Commentaires

Les commentaires sont ignorés par le compilateur et commencent par « % ».

Exemple :

```
% Cette ligne est ignorée par le compilateur ;
```

### Déclarations

Les variables peuvent être déclarées de différentes manières :

```
type nom_variable1 ;  % Déclaration d’une variable simple
type nom_variable2, nom_variable3 ;  % Déclaration de variables de même type
type nom_variable4 DIMENSION (20) ;  % Déclaration d’un tableau
type nom_variable5 DIMENSION (20, 200) ;  % Déclaration d’une matrice
```

### Types

Les types de variables possibles sont :

- INTEGER
- CHARACTER
- REAL
- LOGICAL

### Identificateurs

Un identificateur doit :

- Commencer par une lettre suivie d'une séquence de lettres et de chiffres.
- Ne pas contenir plus de 10 caractères. Un avertissement est affiché si la taille est supérieure.
- Faire la différence entre majuscules et minuscules.

### Instructions

Chaque instruction doit se terminer par un point-virgule `;`.

#### Affectation

```
nom_variable = expression;
```

#### Entrées / Sorties

```
READ (nom_variable);
WRITE ("...", nom_variable, "...");
```

#### Conditions

```
IF (expression conditionnelle) THEN
  Instruction_1 ;
  Instruction_2;
  ...
ELSE
  Instruction_n+1;
  ...
ENDIF
```

#### Boucles

```
DOWHILE (expression conditionnelle)
  Instructions
ENDDO
```

#### Appel de Fonction

```
nom_variable = CALL nom_fonction (liste_paramètres);
```

#### Équivalence

```
EQUIVALENCE (liste_variables), (liste_variables);
```

## Analyse Lexicale avec FLEX

L'analyse lexicale associe chaque mot du programme source à une catégorie lexicale à l'aide d'expressions régulières définies dans un fichier FLEX.

## Analyse Syntaxico-Sémantique avec Bison

L'analyse syntaxico-sémantique nécessite l'écriture de la grammaire générant le langage dans un fichier Bison. Cette grammaire doit être LALR, et les routines sémantiques doivent être associées aux règles de la grammaire.

## Gestion de la Table des Symboles

La table des symboles est créée durant l'analyse lexicale et regroupe toutes les variables et constantes définies par le programmeur. Elle est mise à jour au fur et à mesure de la compilation.

## Traitement des Erreurs

Les messages d'erreurs doivent être affichés de manière précise à chaque étape de la compilation. Le format d'affichage recommandé est :

```
File "NomFichier", line X, character Y: type d'erreur


```
## Petite remarque sur ce projet

Je souhaite attirer votre attention sur une petite erreur relative aux expressions arithmétiques concernant les signes + et -. Il est nécessaire d'insérer des espaces entre l'opérateur et les opérandes. Sans ces espaces, l'analyseur lexical pourrait identifier incorrectement l'entité comme un entier signé, même s'il ne l'est pas.
Par exemple, dans l'expression "1+2", l'analyseur interprétera "1" comme un entier et "+2" comme un entier signé, ce qui n'est pas le résultat souhaité.

À part cela, tout le programme fonctionne correctement.



## Pour executer le compilateur, aprés avoir executer votre commandes.bat.

le_nom_du_executable espace le_nom_de_l'exemple


--- par exemple --- :

compil.exe exemple.txt

---
