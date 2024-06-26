#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Definition de la structure pour les mots-cles

typedef struct element2
{
    int state;
    char name[20];
    char code[20];
    struct element2 *svt;
} motCle;
typedef motCle *motc;

// Definition de la structure pour les separateurs

typedef struct element3
{
    int state;
    char name[20];
    char code[20];
    struct element3 *svt;
} separateur;
typedef separateur *separ;

// Definition de la structure pour les constantes
typedef struct element8
{
    int state;
    char name[20];
    char code[20];
    char type[20];
    struct element8 *svt;
} Constant;

typedef Constant *cst;

// Definition de la structure des IDFS
typedef struct element5
{
    char Dec[20];
    char Src[20];
    char code[20];
    char value[20];
    char taille[20];
    char type[20];
    char NbrPar[20];
    struct element5 *svt;
} Declaration;
typedef Declaration *dec;


// Definition de la structure pour les tableaux
typedef struct element6
{
    char NomTab[20];
    char taille[20];
    struct element6 *svt;
} Tab;
typedef Tab *tab;




tab listTab;
motc listMotCLe;
separ listSepar;
cst listCst;
dec listDec;               // liste des declarations
char tableauOperation[50]; // tableau pour stocker l'operation en forme postfixe
extern char sav[20];

// fonciton d'affichage d'erreurs semantiques

void printYellow(const char *text) {
    printf("\033[1;33m%s\033[0m", text);
}



// fonction d'insertion des type des valeurs
void insererType(char Nentite[], char type[])
{
    dec courantDec = listDec;
    motc courantMots = listMotCLe;
    char temp[20];
    while (strcmp(courantDec->Dec, Nentite) != 0)
    {
        courantDec = courantDec->svt;
    }
    while (courantMots != NULL)

    {
        if (strcmp(courantMots->name, type) == 0)
        {
            strcpy(temp, courantMots->name);
        }
        courantMots = courantMots->svt;
    }

    if (courantDec != NULL)
    {
        strcpy(courantDec->type, temp);
    }
}

// fonction pour ajouter les declaration des idfs avec leurs source
void AjouterDec(char Entite[], char source[])
{

    dec courantDec = (dec)malloc(sizeof(Declaration));
    if (courantDec == NULL)
    {
        fprintf(stderr, "Erreur d'allocation de memoire pour operateur.\n");
        exit(EXIT_FAILURE);
    }

    strcpy(courantDec->Dec, Entite);
    strcpy(courantDec->Src, source);
    strcpy(courantDec->value, "");
    strcpy(courantDec->taille, "");
    strcpy(courantDec->type, "");
    strcpy(courantDec->code, "Idf");
    strcpy(courantDec->NbrPar, "");

    courantDec->svt = listDec;
    listDec = courantDec;
}

void Params(char Nentite[], int cpt)
{
    dec courantDec = listDec;
    char temp[20];
    while (courantDec != NULL && strcmp(courantDec->Dec, Nentite) != 0)
    {
        courantDec = courantDec->svt;
    }

    if (courantDec != NULL)
    {
        sprintf(temp, "%d", cpt);
        strcpy(courantDec->NbrPar, temp);
    }
}

void Verfier_nombre_Params(char Nentite[], int cpt)
{
    dec courantDec = listDec;
    char temp[20];
    while (courantDec != NULL && strcmp(courantDec->Dec, Nentite) != 0)
    {
        courantDec = courantDec->svt;
    }
    if (courantDec != NULL)
    {
        sprintf(temp, "%d", cpt);
        if (strcmp(courantDec->NbrPar, temp) != 0)
        {
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
            printYellow("ERREUR SEMANTIQUE : NOMBRE DE PARAMETRES INVALIDE.\n");
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        }
    }
}



// fonction pour verifier la declaration des fonctions
void Verifier_Declaration_Des_Fonction(char Nentite[])
{
    dec courantDec = listDec; // la liste des source qui vas contenir toutes les fonctions utilse dans le code + le programme principal
    while (courantDec != NULL && strcmp(courantDec->Src, Nentite) != 0)
    {
        courantDec = courantDec->svt;
    }
    if (courantDec == NULL)
    {
       printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
       printYellow("Erreur SEMANTIQUE : fonction non declaree.\n");
       printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

    }
}

// la fonction afficher qui vas affciher les idfs.
void afficheDeclaration()
{
    dec courantDec = listDec;
    printf("\n/***************Table des symboles des Idf*************/\n");
    printf("________________________________________________________________________________________________________________\n");
    printf("\t| NomEntite |  CodeEntite | Valeur Entite | TailleEntite |  Type Entite |  Source Entite | NombreParams  |  \n");
    printf("________________________________________________________________________________________________________________\n");
    while (courantDec != NULL)
    {
        printf("\t|%10s |%12s | %12s  |%12s  | %12s |  %12s  | %12s  |\n", courantDec->Dec, courantDec->code, courantDec->value, courantDec->taille, courantDec->type, courantDec->Src, courantDec->NbrPar);
        courantDec = courantDec->svt;
    }
}

// fonction pour verifer la decalration des idfs
int verifierDeclaration(char Entite[])
{
    dec courantDec = listDec;
    while (courantDec != NULL && strcmp(courantDec->Dec, Entite) != 0)
    {
        courantDec = courantDec->svt;
    }

    if (courantDec == NULL)
    {
        return 0;
    }
    return 1;
}

// fonction pour verifier les double decalration on appelle dans la decalration des variable
void verifierDoubleDeclaration(char Nentite[], char Source[])
{
    dec courantDec = listDec;
    int cpt = 0;
    while (courantDec != NULL)
    {
        if (strcmp(courantDec->Dec, Nentite) == 0 && strcmp(courantDec->Src, Source) == 0)
        {
            cpt++;
        }
        courantDec = courantDec->svt;
    }
    if (cpt > 1)
    {
        printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("Erreur SEMANTIQUE : double declaration.\n");
        printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
}


// verfier la compatibilite dans le cas d'affectaion des valeurs pour les variable
void verifierCompatibilite(char Nentite[], char *Constant)
{
    dec courantDec1 = listDec;
    dec courantDec2 = listDec;
    cst courantCst = listCst;


    while (courantCst != NULL)
    {
        if (strcmp(courantCst->type, "REAL") == 0){
            float convertedToFloat1 = strtof(courantCst->name, NULL);
            float convertedToFloat2 = strtof(Constant, NULL);
            if (convertedToFloat1 == convertedToFloat2 ){
                break;
            }
        }else{
            if (strcmp(Constant, courantCst->name)== 0){
                break;
            }
        }
        courantCst = courantCst->svt;
    }


    while (courantDec1 != NULL && strcmp(courantDec1->Dec, Nentite) != 0)
    {
        courantDec1 = courantDec1->svt;
    }


    // le cas ou la constante est un idf par exemple Comp = A;


    if (courantCst != NULL && courantDec1 != NULL) // ici le cas ou on a A = 20  on affect les entier ou les reel ou n'import quelle valeur
    {
        if (strcmp(courantCst->type, courantDec1->type) != 0)
        {
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
            printYellow("Erreur SEMANTIQUE : type incompatible.\n");
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        }
    }


    while (courantDec2 != NULL && strcmp(courantDec2->Dec, Constant) != 0)
    {
        courantDec2 = courantDec2->svt;
    }
    // ici le cas ou l'affectation se fait comme sa A = B  telle que A et B deux idf donc on verfife les deux
    if (courantDec2 != NULL && courantDec1 != NULL)
    {
        if (strcmp(courantDec1->type, courantDec2->type) != 0)
        {
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
            printYellow("Erreur SEMANTIQUE : type incompatible.\n");
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        }
    }
}







// la focntion qui inserer les valeur en cas  d'utilisation de la variable
void insererVal(char Nentit[], char Val[])
{
    dec courantDec = listDec;
    int cpt1, cpt2;
    cpt1 = verifierDeclaration(Nentit); // l'appel de la focntion pour verifier si la variable elle est declarer
    if (cpt1 == 1)
    {

        while (courantDec != NULL && strcmp(courantDec->Dec, Nentit) != 0)
        {
            courantDec = courantDec->svt;
        }
        if (courantDec != NULL)
        {
            strcpy(courantDec->value, Val);
        }
    }
    else
    {
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("Erreur SEMANTIQUE : element non declare.\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

    }
}



// fonction pour convertir les reels en chaine de caractere
char *floatToString(float number)
{
    char *result = (char *)malloc(10); // Ajuster la taille sur choix
    sprintf(result, "%.2f", number);
    return result;
}

// fonction pour convertire les entier en chaine de caractere
char *intToString(int number)
{
    // Ajuster la taille sur choix
    char *result = (char *)malloc(20);

    if (result != NULL)
    {
        if (sprintf(result, "%d", number) < 0)
        {
            free(result);
            return NULL; // En cas D'erreur
        }
    }

    return result;
}

// fonction pour ajouter les tableaux declarés
void Ajouter_Tab(char Nentit[], int Taille)
{
    char temp[20];
    tab courantTab = (tab)malloc(sizeof(Tab));
    if (courantTab == NULL)
    {
        fprintf(stderr, "Erreur d'allocation de memoire pour operateur.\n");
        exit(EXIT_FAILURE);
    }
    sprintf(temp, "%d", Taille);

    strcpy(courantTab->NomTab, Nentit);
    strcpy(courantTab->taille, temp);

    courantTab->svt = listTab;
    listTab = courantTab;
}

// fonction pour ajouter les matrices declarés
void Ajouter_Mat(char Nentit[], int Taille1, int Taille2)
{
    char temp1[20];
    char temp2[20];
    tab courantTab = (tab)malloc(sizeof(Tab));
    if (courantTab == NULL)
    {
        fprintf(stderr, "Erreur d'allocation de memoire pour operateur.\n");
        exit(EXIT_FAILURE);
    }

    sprintf(temp1, "%d", Taille1);
    sprintf(temp2, "%d", Taille2);

    strcpy(courantTab->NomTab, Nentit);
    sprintf(courantTab->taille, "(%s,%s)", temp1, temp2); // Utiliser temp1 et temp2 ici

    courantTab->svt = listTab;
    listTab = courantTab;
}

// inserer la taille des tableaux
void insererTailleTab(char Nentite[], int taille)
{
    dec courantDec = listDec;
    Ajouter_Tab(Nentite, taille);
    char ch[20];

    sprintf(ch, "%d", taille);

    while (courantDec != NULL && strcmp(courantDec->Dec, Nentite) != 0)
    {

        courantDec = courantDec->svt;
    }

    if (courantDec != NULL)
    {

        strcpy(courantDec->taille, ch);
    }
}

// inserer la taille des matrices
void insererTailleMat(char Nentite[], int taille1, int taille2)
{
    dec courantDec = listDec;

    char ch1[20];

    char ch2[20];

    sprintf(ch1, "%d", taille1);

    sprintf(ch2, "%d", taille2);

    while (courantDec != NULL && strcmp(courantDec->Dec, Nentite) != 0)
    {

        courantDec = courantDec->svt;
    }
    Ajouter_Mat(Nentite, taille1, taille2);
    if (courantDec != NULL)
    {

        sprintf(courantDec->taille, "(%s,%s)", ch1, ch2);
    }
}

// fonction pour verfier le depassemment de taille pour les tableaux
void Verfier_Depassement_de_TailleTab(char nomtab[], int tailleTab)
{
    tab courantTab = listTab;
    int taille;
    while (courantTab != NULL && strcmp(courantTab->NomTab, nomtab) != 0)
    {
        courantTab = courantTab->svt;
    }
    if (courantTab != NULL)
    {
        taille = atoi(courantTab->taille);
        if (tailleTab > taille)
        {
           printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
           printYellow("Erreur SEMANTIQUE : depassement de taille.\n");
           printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

        }
    }
}

// fonction pour verifer le depassemment de taille pour les matrices
void Verfier_Depassement_de_TailleMAT(char nomtab[], int taille1, int taille2)
{
    tab courantMat = listTab;
    int val1, val2;

    while (courantMat != NULL && strcmp(courantMat->NomTab, nomtab) != 0)
    {
        courantMat = courantMat->svt;
    }

    if (courantMat != NULL)
    {
        if (sscanf(courantMat->taille, "(%d,%d)", &val1, &val2) == 2)
        { // la focntion fscanf cest une fonction utilser pour extraire les donner a partie d'une chaine de caractere
            if (val1 < taille1)
            {
                printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
                printYellow("Erreur : depassement de taille dans les lignes.\n");
                printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

            }
            if (val2 < taille2)
            {
                printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
                printYellow("Erreur : depassement de taille dans les colonnes.\n");
                printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
            }
        }
    }
}


typedef struct Ifelement
{
    int pos;
    struct Ifelement *next;
} if_element;

typedef if_element *traceIf;

traceIf stack_if = NULL;

typedef struct Whileelement
{
    int pos;
    struct Whileelement *next;
} While_element;

typedef While_element *traceWhile;

traceWhile stack_while = NULL;

void pushIf(int data) {
    traceIf newNode = (traceIf)malloc(sizeof(traceIf));
    if (newNode == NULL) {
        printf("Memory allocation failed.\n");
        exit(EXIT_FAILURE);
    }
    newNode->pos = data;
    newNode->next = stack_if;
    stack_if = newNode;
}

int popIf() {
    if (stack_if == NULL) {
        printf("Stack is empty.\n");
        exit(EXIT_FAILURE);
    }
    
    int poppedValue = stack_if->pos;  
    
    traceIf temp = stack_if;         
    stack_if = stack_if->next;       
    free(temp);                      
    
    return poppedValue;              
}

void pushWhile(int data) {
    traceWhile newNode = (traceWhile)malloc(sizeof(traceWhile));
    if (newNode == NULL) {
        printf("Memory allocation failed.\n");
        exit(EXIT_FAILURE);
    }
    newNode->pos = data;
    newNode->next = stack_while;
    stack_while = newNode;
}

int popWhile() {
    if (stack_while == NULL) {
        printf("Stack is empty.\n");
        exit(EXIT_FAILURE);
    }
    
    int poppedValue = stack_while->pos;  
    
    traceWhile temp = stack_while;         
    stack_while = stack_while->next;       
    free(temp);                      
    
    return poppedValue;              
}

