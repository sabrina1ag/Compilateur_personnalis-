#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int indice;
    char oper[20];
    char op1[100];
    char op2[100];
    char res[100];
} qdr;

typedef struct elem {
    qdr val;
    int num;
    struct elem *svt;
} Quadruplet;

typedef Quadruplet *quad;

quad ListQuad = NULL;
extern int qc;



// une fonction qui verfier si deux quadrupler est egale ou pas 
bool areQuadruplesEqual(qdr q1, qdr q2) {
    return (strcmp(q1.oper, q2.oper) == 0 &&
            strcmp(q1.op1, q2.op1) == 0 &&
            strcmp(q1.op2, q2.op2) == 0 &&
            strcmp(q1.res, q2.res) == 0);
}

// ajouter un quad dans la liste des quad 
void Ajout_Quadr(char opr[], char op1[], char op2[], char res[]) {
    qdr quadruple;
    strcpy(quadruple.oper, opr);
    strcpy(quadruple.op1, op1);
    strcpy(quadruple.op2, op2);
    strcpy(quadruple.res, res);

    // Check if the quadruple already exists in the list
    quad current = ListQuad;

    // If the quadruple doesn't exist, proceed with insertion
    qc++;

    quad courantQd = (quad)malloc(sizeof(Quadruplet));
    
    if (courantQd == NULL) {
        fprintf(stderr, "Erreur d'allocation de memoire pour operateur.\n");
        exit(EXIT_FAILURE);
    }
    courantQd->val = quadruple;
    courantQd->num = qc;
    courantQd->svt = NULL;

    if (ListQuad == NULL) {
        ListQuad = courantQd;
    } else {
        quad dernier = ListQuad;
        while (dernier->svt != NULL) {
            dernier = dernier->svt;
        }
        dernier->svt = courantQd;
    }
}


// cest la fonction modifier (mettre a jour de cours que on a fait )
void Mettre_Ajour(int num_quad, int colon_quad, char val[]) {

    quad courantQd = ListQuad;
    while (courantQd != NULL && courantQd->num != num_quad+1) {
        courantQd = courantQd->svt;
    }
    if (courantQd == NULL) {
        printf("QUADRUPLER NOT FOUND\n");
    } else {
        if (colon_quad == 0){strcpy(courantQd->val.oper, val);}
        
    else if (colon_quad == 1){strcpy(courantQd->val.op1, val);}
        
    else if (colon_quad == 2){strcpy(courantQd->val.op2, val);}
        
    else if (colon_quad == 3){strcpy(courantQd->val.res, val);}
        
    }
}

void Afficher_Qdr() {
    printf("\n*********************Les Quadruplets***********************\n");
    int i = 0;
    quad courantQd = ListQuad;
    while (courantQd != NULL && courantQd->num<=qc) {
        printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )",i,courantQd->val.oper, courantQd->val.op1, courantQd->val.op2,
               courantQd->val.res);
        printf("\n---------------------------------------\n");
        courantQd = courantQd->svt;
        i++;
       
    }

}


