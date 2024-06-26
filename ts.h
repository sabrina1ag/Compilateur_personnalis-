#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // Ajout de cet en-tête pour utiliser la fonction strcpy
#include <stdbool.h> // Ajout de cet en-tête pour utiliser le type de donnees bool




// la table des motcles

typedef struct element2
{
    int state;
    char name[20];
    char code[20];
    struct element2 *svt;
} motCle;
typedef motCle *motc;

// la table des separateurs

typedef struct element3
{
    int state;
    char name[20];
    char code[20];
    struct element3 *svt; 
} separateur;
typedef separateur *separ;

// table des constants
typedef struct element6
{
    int state;
    char name[20];
    char code[20];
    char type[20];
    struct element6 *svt;
} Constant;

typedef Constant *cst;


motc listMotCLe;
separ listSepar;
cst listCst;
extern char sav[20];

/***Step 2: initialisation de l'etat des cases des tables des symboles***/

void initialisation()
{
   
    motc tempMotCLe;
    while (listMotCLe)
    {
        tempMotCLe = listMotCLe;
        listMotCLe = listMotCLe->svt;
        free(tempMotCLe);
    }

    separ tempSepar;
    while (listSepar)
    {
        tempSepar = listSepar;
        listSepar = listSepar->svt;
        free(tempSepar);
    }

    cst tempcst;
    while (listCst)
    {
        tempcst = listCst;
        listCst = listCst->svt;
        free(tempcst);
    }
}

/***Step 3: insertion des entititees lexicales dans les tables des symboles ***/
void inserer(char entite[], char code[], char type[], char val[], int i, int y)
{
    switch (y)
    {
    
    case 1: /*insertion dans la table des mots cles*/
    {
        motc nouveauMotCLe = (motc)malloc(sizeof(motCle));
        if (nouveauMotCLe == NULL)
        {
            fprintf(stderr, "Erreur d'allocation de memoire pour motCle.\n");
            exit(EXIT_FAILURE);
        }
        nouveauMotCLe->state = 1;
        strcpy(nouveauMotCLe->name, entite);
        strcpy(nouveauMotCLe->code, code);
        // Ajouter nouveauMotCLe a la listeMotCLe
        nouveauMotCLe->svt = listMotCLe;
        listMotCLe = nouveauMotCLe;
    }
    break;

    case 2: /*insertion dans la table des separateurs*/
    {
        separ nouveauSepar = (separ)malloc(sizeof(separateur));
        if (nouveauSepar == NULL)
        {
            fprintf(stderr, "Erreur d'allocation de memoire pour separateur.\n");
            exit(EXIT_FAILURE);
        }
        nouveauSepar->state = 1;
        strcpy(nouveauSepar->name, entite);
        strcpy(nouveauSepar->code, code);

        // Ajouter nouveauSepar a la listeSepar
        nouveauSepar->svt = listSepar;
        listSepar = nouveauSepar;
    }
    break;

    case 5: /*insertion dans la table des cst*/
    {
        cst nouveaucst = (cst)malloc(sizeof(Constant));
        if (nouveaucst == NULL)
        {
            fprintf(stderr, "Erreur d'allocation de memoire pour operateur.\n");
            exit(EXIT_FAILURE);
        }
        nouveaucst->state = 1;
        strcpy(nouveaucst->name, entite);
        strcpy(nouveaucst->code, code);
        strcpy(nouveaucst->type, type);

        // Ajouter nouveauOper a la listeOper
        nouveaucst->svt = listCst;
        listCst = nouveaucst;
    }
    break;
    }
}

/***Step 4: La fonction Rechercher permet de verifier  si l'entite existe dèja dans la table des symboles */
void rechercher(char entite[], char code[], char type[], char val[], int y)
{
    switch (y)
    {
    case 1:
    {
        motc courant = listMotCLe;
        while (courant != NULL && strcmp(entite, courant->name) != 0)
        {
            courant = courant->svt;
        }

        if (courant == NULL)
        {
            // L'entite n'existe pas, on l'ajoute a la liste
            inserer(entite, code, type, val, 0, 1);
        }
    }
    break;

    case 2:
    {
        separ courant = listSepar;
        while (courant != NULL && strcmp(entite, courant->name) != 0)
        {
            courant = courant->svt;
        }

        if (courant == NULL)
        {
            // L'entite n'existe pas, on l'ajoute a la liste
            inserer(entite, code, type, val, 0, 2);
        }
    }
    break;

    case 5:
    {
        cst courant = listCst;
        while (courant != NULL && strcmp(entite, courant->name) != 0)
        {
            courant = courant->svt;
        }

        if (courant == NULL)
        {
            // L'entite n'existe pas, on l'ajoute a la liste
            inserer(entite, code, type, val, 0, 5);
        }
    }
    break;
    }
}

/***Step 5 L'affichage du contenue de la table des symboles ***/

void afficherTS()
{
   
    printf("\n/***************Table des symboles mots cles*************/\n");
    printf("__________________________________________________\n");
    printf("\t|        NomEntite     |      CodeEntie   | \n");
    printf("__________________________________________________\n");

    // Affichage de la table des symboles mots cles
    motc courantMotCLe = listMotCLe;
    while (courantMotCLe != NULL)
    {
        printf("\t|%20s |%12s | \n", courantMotCLe->name, courantMotCLe->code);
        courantMotCLe = courantMotCLe->svt;
    }

    printf("\n/***************Table des symboles separateurs*************/\n");
    printf("_____________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("_____________________________________\n");

    // Affichage de la table des symboles separateurs
    separ courantSepar = listSepar;
    while (courantSepar != NULL)
    {
        printf("\t|%10s |%12s |\n", courantSepar->name, courantSepar->code);
        courantSepar = courantSepar->svt;
    }

    printf("\n/***************Table des symboles Cst*************/\n");
    printf("_____________________________________________________________________\n");
    printf("\t|          Nom_Entite  |        Code_Entite    | Type_Entite    |\n");
    printf("____________________________________________________________________\n");

    cst courantCst = listCst;
    while (courantCst != NULL)
    {
        printf("\t|%30s |%12s | %12s |\n", courantCst->name, courantCst->code, courantCst->type);
        courantCst = courantCst->svt;
    }
}
