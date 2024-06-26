%{   
#include <stdio.h>
#include "sym.h"
#include "quad.h"
int nb_ligne = 1;
int Col =1;
char* file_name = NULL;
FILE* yyin;
char * type_tracker;
char* Data_tracker;
char * source_tracker;
char * size_tracker;
char * div_tracker;
char * val_tracker;
int qc = 0 ;
int deb_while=0  ,fin_while=0, fin_if=0;
char temp[20];
char *oper1;
char *oper2;
int NombreParam = 0;
int retourFunc=0;
int cpt = 0;
int posX;
%}





%union{
        int entier;
        char* chaine;
        float reel;
}

%token mc_prog mc_end mc_routine mc_endr mc_read mc_write mc_if mc_then mc_else mc_endif mc_dowhile mc_enddo mc_equivalence  <chaine>mc_mul mc_call <chaine>Idf <entier>entier  aff pvg vrg <chaine>parouv <chaine>parfer  <reel>reel <chaine>chaine  mc_dimension <entier>True 
<entier>False erreur
 <chaine>mc_moins <chaine>mc_plus <chaine>mc_div  point  <chaine>INTEGER <chaine>LOGICAL <chaine>CHARACTER <chaine>REAL <entier>entier_signe <reel>reel_signe OR AND LT LE GE GT EQ NE 

%left mc_plus mc_moins 
%left mc_mul mc_div
%left GT GE EQ NE LT LE
%left AND OR


%%
S : Fonctions  {
    printf("\n\033[1;32m---------------------------------------------------\n");
    printf("\ncompilation lexical et syntaxique a bien marche\n");
    printf("\n ---------------------------------------------------\033[0m\n");
    YYACCEPT;
    }

Fonctions : T1 Fonctions 
|T2  Fonctions  

|T3  Fonctions 

|T4 Fonctions 

| Programme_Principale 

T1:type1 parouv multipleVariables parfer  DeclarationFonction mc_endr {NombreParam=0;}

T2:type2 parouv multipleVariables parfer  DeclarationFonction mc_endr {NombreParam=0;}

T3:type3 parouv multipleVariables parfer  DeclarationFonction mc_endr {NombreParam=0;}

T4:type4 parouv multipleVariables parfer  DeclarationFonction mc_endr {NombreParam=0;}

type1:REAL mc_routine Idf    { source_tracker =strdup($3); AjouterDec($3,source_tracker); insererType($3,$1); verifierDoubleDeclaration($3,source_tracker);  }

type2:CHARACTER mc_routine Idf {source_tracker =strdup($3); AjouterDec($3,source_tracker); insererType($3,$1); verifierDoubleDeclaration($3,source_tracker);   }

type3:INTEGER mc_routine Idf { source_tracker =strdup($3);  AjouterDec($3,source_tracker); insererType($3,$1); verifierDoubleDeclaration($3,source_tracker); }

type4:LOGICAL mc_routine Idf { AjouterDec($3,source_tracker); source_tracker =strdup($3); insererType($3,$1); verifierDoubleDeclaration($3,source_tracker);  }



multipleVariables : Idf vrg multipleVariables {NombreParam++; Params(source_tracker,NombreParam); }
| Idf {NombreParam++; Params(source_tracker,NombreParam);}


TYPE : REAL {type_tracker =strdup($1);}
| LOGICAL {type_tracker =strdup($1);}
| INTEGER {type_tracker =strdup($1);}
| CHARACTER {type_tracker =strdup($1);}

Data : entier  { Data_tracker = strdup(intToString($1));}
    | entier_signe { Data_tracker = strdup(intToString($1));}
    | True { Data_tracker = strdup("TRUE");}
    | False { Data_tracker = strdup("FALSE");}
    | reel {   Data_tracker = strdup(floatToString($1));}
    | reel_signe { Data_tracker = strdup(floatToString($1));}
    | chaine { Data_tracker = strdup($1);}
    | Tabelement
    | Idf { Data_tracker = strdup($1);}


DeclarationFonction:  TYPE List_Idf pvg  DeclarationFonction 
| TYPE  List_tab pvg DeclarationFonction 
| InstructionFonction


Declaration:   TYPE List_Idf pvg  Declaration 
| TYPE List_tab pvg Declaration 
| Instruction


List_Idf : Idf  vrg List_Idf {   
    AjouterDec($1,source_tracker); 
    insererType($1, type_tracker); 
    verifierDoubleDeclaration($1,source_tracker);  }

| Idf    {  
    AjouterDec($1,source_tracker); 
    insererType($1, type_tracker); 
    verifierDoubleDeclaration($1,source_tracker);  } 

| InstructionAffectationDeclaration vrg List_Idf 
| InstructionAffectationDeclaration  

List_tab : Idf  mc_dimension parouv entier parfer vrg List_tab {  
    AjouterDec($1,source_tracker);   
    insererType($1, type_tracker); 
    insererTailleTab($1,$4); 
    size_tracker=strdup(intToString($4)); 
    verifierDoubleDeclaration($1,source_tracker); 
    if($4== 0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }  
    
    }


|   Idf  mc_dimension parouv entier_signe parfer vrg List_tab {  
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    insererTailleTab($1,$4); 
     if($4<= 0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    size_tracker=strdup(intToString($4)); 
    verifierDoubleDeclaration($1,source_tracker);
    
      }


| Idf  mc_dimension parouv entier vrg entier parfer vrg List_tab { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    insererTailleMat($1,$4,$6); 
    verifierDoubleDeclaration($1,source_tracker);
    if($4 == 0 || $6 == 0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
     }

| Idf  mc_dimension parouv entier_signe vrg entier_signe parfer vrg List_tab { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    insererTailleMat($1,$4,$6); 
    verifierDoubleDeclaration($1,source_tracker);
     if($4<=0 || $6<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
     }

|Idf  mc_dimension parouv entier_signe vrg entier parfer vrg List_tab { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    insererTailleMat($1,$4,$6); 
     verifierDoubleDeclaration($1,source_tracker);
     if($4<=0 || $6<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
        if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    }  


|Idf  mc_dimension parouv entier vrg entier_signe parfer vrg List_tab { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    insererTailleMat($1,$4,$6); 
     verifierDoubleDeclaration($1,source_tracker);
     if($4<=0 || $6<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
        if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    }  

| Idf  mc_dimension parouv entier vrg entier parfer { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker);
    insererTailleMat($1,$4,$6); 
    verifierDoubleDeclaration($1,source_tracker); 
    if($4<=0 || $6<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
     
     }

| Idf  mc_dimension parouv entier_signe vrg entier_signe parfer { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker);
    insererTailleMat($1,$4,$6); 
     verifierDoubleDeclaration($1,source_tracker);
    if($4<=0 || $6<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
     }

|Idf  mc_dimension parouv entier vrg entier_signe parfer { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker);
    insererTailleMat($1,$4,$6); 
     verifierDoubleDeclaration($1,source_tracker);
    if($4<=0 || $6<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
      if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    }

|Idf  mc_dimension parouv entier_signe vrg entier parfer { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker);
    insererTailleMat($1,$4,$6);
      verifierDoubleDeclaration($1,source_tracker);
    if($4<=0 || $6<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
          if ($4 > $6){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE BORNE MINIMALE DOIT ETRE INFERIEURE A LA BORNE MAXIMALE\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
     }        

| Idf  mc_dimension parouv entier parfer { 
    AjouterDec($1,source_tracker); 
    insererType($1, type_tracker); 
    insererTailleTab($1,$4); 
    verifierDoubleDeclaration($1,source_tracker);
    if($4 == 0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }  }

| Idf  mc_dimension parouv entier_signe parfer { 
    AjouterDec($1,source_tracker); 
    insererType($1, type_tracker); 
    insererTailleTab($1,$4); 
    if($4<=0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        printYellow("ERREUR SEMANTIQUE TAILLE <= 0\n");
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    }
    verifierDoubleDeclaration($1,source_tracker);  }

| Idf  mc_mul entier vrg List_tab { 
    AjouterDec($1,source_tracker); 
    insererType($1, type_tracker);  
    verifierDoubleDeclaration($1,source_tracker); }

| Idf  mc_mul entier aff chaine vrg List_tab { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    insererVal($1,$5); 
    verifierDoubleDeclaration($1,source_tracker); }

| Idf  mc_mul entier { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    verifierDoubleDeclaration($1,source_tracker); }

| Idf  mc_mul entier aff chaine { 
    AjouterDec($1,source_tracker);  
    insererType($1, type_tracker); 
    insererVal($1,$5); 
    verifierDoubleDeclaration($1,source_tracker); }



InstructionFonction : InstructionEntreSortie InstructionFonction
| InstructionDoWhile InstructionFonction
| InstructionIfEls InstructionFonction
| InstructionEquivalence InstructionFonction
| InstructionAppel InstructionFonction
| InstructionAffectation pvg InstructionFonction
| InstructionAffectation  pvg 


             
Instruction : InstructionEntreSortie Instruction
| InstructionDoWhile Instruction
| InstructionIfEls Instruction
| InstructionEquivalence Instruction
| InstructionAffectation pvg Instruction
| InstructionAppel Instruction
| 


// instruction affectation de données

InstructionAffectationDeclaration : Idf aff Data {
       AjouterDec($1,source_tracker);  
       insererType($1, type_tracker);
       if(strcmp(type_tracker,"CHARACTER")==0){
        if(strlen(Data_tracker)>1){
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
            printYellow("ERREUR SEMANTIQUE  TAILLE DE CHARACTER > 1 !!!!!!!!!!!!!!!!\n");
            printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        }
       }
       insererVal($1,Data_tracker); 
       verifierCompatibilite($1,Data_tracker); 
       verifierDoubleDeclaration($1,source_tracker); 
       Ajout_Quadr(":=",Data_tracker,"Vide",$1);
        }

| Idf aff Expression mc_plus  Expression  {  AjouterDec($1,source_tracker); insererType($1, type_tracker); Ajout_Quadr("+",oper1,oper2,$1);}

| Idf aff Expression mc_moins  Expression  { AjouterDec($1,source_tracker); insererType($1, type_tracker); Ajout_Quadr("-",oper1,oper2,$1);}

| Idf aff Expression mc_div  Expression  { AjouterDec($1,source_tracker);  insererType($1, type_tracker);  if (strcmp(div_tracker,"0")==0){
    printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    printYellow("ERREUR SEMANTIQUE! DIVISION PAR ZERO !!!!!!!!!!!!!!!!\n");
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
     Ajout_Quadr("*",oper1,oper2,$1);
}}

| Idf aff Expression mc_mul  Expression {  AjouterDec($1,source_tracker);  insererType($1, type_tracker); }

| Idf aff parouv Expression parfer  { AjouterDec($1,source_tracker);    insererType($1, type_tracker); }


InstructionAffectation : Idf aff Data  {  insererVal($1,Data_tracker);  verifierCompatibilite($1,Data_tracker); Ajout_Quadr(":=",Data_tracker,"Vide",$1);}   
| Idf aff Expression  mc_plus   Expression  { Ajout_Quadr("+",oper1,oper2,$1); }
| Idf aff Expression  mc_moins  Expression   { Ajout_Quadr("-",oper1,oper2,$1);  }
| Idf aff Expression  mc_div  Expression   {  if (strcmp(div_tracker,"0")==0){
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    printYellow("ERREUR SEMANTIQUE! DIVISION PAR ZERO !!!!!!!!!!!!!!!!\n");
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
}
Ajout_Quadr("/",oper1,oper2,$1);
 }
| Idf aff Expression  mc_mul  Expression  { Ajout_Quadr("*",oper1,oper2,$1);   }
| Idf aff parouv  Expression parfer 


// instruction write and read

InstructionEntreSortie : mc_read parouv Idf parfer pvg 
| mc_write parouv Something parfer pvg 

Something : Idf vrg Something
| chaine vrg Something
| Idf { if (verifierDeclaration($1)==0){ printf("ERREUR SYMENTIQUE ELEMENT NON DECLARER!!!!!!!!"); } } 
| chaine


// instruction equivalence 

InstructionEquivalence : mc_equivalence parouv  EquivalenceVariables parfer vrg parouv EquivalenceVariables parfer pvg

EquivalenceVariables: Idf vrg  EquivalenceVariables 
{  if (verifierDeclaration($1)==0){ printf("ERREUR SYMENTIQUE ELEMENT NON DECLARER!!!!!!!!"); }  }
|  Tabelement vrg  EquivalenceVariables
| Idf { if (verifierDeclaration($1)==0){ printf("ERREUR SYMENTIQUE ELEMENT NON DECLARER!!!!!!!!"); }  } 
| Tabelement 



// Instruction Appel fonction

InstructionAppel : Idf aff mc_call Idf parouv Arguments parfer pvg {Verifier_Declaration_Des_Fonction($4); Verfier_nombre_Params($4,NombreParam);   }

Arguments : Data vrg  Arguments {NombreParam++;}
| Data {NombreParam++;}






 
InstructionIfEls : U  mc_endif pvg {
    sprintf(temp,"%d",qc);
    // metre a jour le quad du saut a la fin avec le qc de la fin
    Mettre_Ajour(fin_if,1,temp);
    }

U: V mc_else Instruction 


V: W Instruction  { 
     fin_if = qc;
     // quad pour sauter a la fin
     Ajout_Quadr("BR","","Vide","Vide");
    
    // mettre a jour quad de saut vers else avec le qc du else
    // je dois depiler ici 
     sprintf(temp,"%d",qc);
     Mettre_Ajour(popIf(),1,temp);
    }

W: mc_if parouv LogicalExpression parfer mc_then 
{
    // je dois empiler ici les position des if
    pushIf(qc);
    // quad pour sauter au Else
    Ajout_Quadr("BZ","","temp_cond","Vide");
    }



  

// Instruction do while

InstructionDoWhile: Z mc_enddo pvg
Z: Y Instruction {
    posX = popWhile(qc);
    sprintf(temp,"%d",posX);
    Ajout_Quadr("BR",temp,"Vide","Vide");
    sprintf(temp,"%d",qc);
    Mettre_Ajour(posX,1,temp);
        }
Y: X parouv LogicalExpression parfer
{    pushWhile(qc);
     Ajout_Quadr("BZ","","temp_cond","Vide");
     
}
                                    
X : mc_dowhile {deb_while=qc;}


// formule de condition 

LogicalExpression :     LogicalExpression point OperLogique point Condition  
| LogicalExpression point OperCompare point Condition 
| Condition  

Condition :   parouv Condition point OperCompare   point LogicalExpression    parfer
|  parouv Condition point  OperLogique point LogicalExpression    parfer
|  Expression
|  True 
|  False 

OperCompare :GT | GE | EQ | NE | LT | LE
OperLogique :AND | OR

// Expression arithmetique 

// on peut supprimer Terme pour ne pas permettre de donner une expression sans operateur
Expression :   Expression  mc_plus   Expression {  Ajout_Quadr("+",oper1,oper2,"temp");}
| Expression  mc_moins  Expression {Ajout_Quadr("-",oper1,oper2,"temp");}
| Expression mc_div  Expression {if (strcmp(div_tracker,"0")==0){
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
     printYellow("ERREUR SEMANTIQUE! DIVISION PAR ZERO !!!!!!!!!!!!!!!!\n");
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
}
 Ajout_Quadr("/",oper1,oper2,"temp");
}
| Expression mc_mul  Expression { Ajout_Quadr("*",oper1,oper2,"temp");  }
| parouv Expression parfer {}
| Expression_item 



Expression_item : Idf { 
    if ( verifierDeclaration($1) == 0) printf("\033[1;33m## erreur semnatique IDF non declaree  a la ligne : %d col : %d  ##\033[0m\n", nb_ligne, Col); 
     if(cpt == 0){
     oper1=strdup($1); 
     cpt++;
     }else if(cpt!=0){
        oper2=strdup($1); 
       
        cpt=0;
     }
}

|  entier { 
     div_tracker=strdup(intToString($1)); 
     if(cpt == 0){
     oper1=strdup(intToString($1)); 
     cpt++;
     }else if(cpt!=0){
        oper2=strdup(intToString($1)); 
        cpt=0;
     }
   
 }

|  parouv entier_signe parfer {
     div_tracker=strdup(intToString($2)); 
     if(cpt == 0){
     oper1=strdup(intToString($2)); 
     cpt++;
     }else if(cpt!=0){
        oper2=strdup(intToString($2)); 
        cpt=0;
     }
     
    
    }
|  Tabelement
|  reel  { 
   div_tracker=strdup(floatToString($1));
   if(cpt == 0){
     oper1=strdup(floatToString($1)); 
     cpt++;
     }else if(cpt!=0){
        oper2=strdup(floatToString($1)); 
        cpt=0;
     }
   
    }
|  parouv reel_signe parfer { 
   if(cpt == 0){
     oper1=strdup(floatToString($2)); 
     cpt++;
     }else if(cpt!=0){
        oper2=strdup(floatToString($2)); 
        cpt=0;
     }
    }

Tabelement : Idf parouv entier parfer 

{ Verfier_Depassement_de_TailleTab($1,$3); sprintf(Data_tracker,"%s(%d)",$1,$3);  if (verifierDeclaration($1) == 0) printf("## erreur semnatique IDF non declaree  a la ligne : %d col : %d  ##\n", nb_ligne, Col);
if($3<0){
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
     printYellow("ERREUR SEMANTIQUE TAILLE <  0\n");
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
}
     }
| Idf parouv entier_signe parfer 

{ Verfier_Depassement_de_TailleTab($1,$3); sprintf(Data_tracker,"%s(%d)",$1,$3);  if (verifierDeclaration($1) == 0) printf("## erreur semnatique IDF non declaree  a la ligne : %d col : %d  ##\n", nb_ligne, Col);
if($3<0){
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    printYellow("ERREUR SEMANTIQUE TAILLE <  0\n");
     printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
}
     }

| Idf parouv entier vrg entier parfer { 
     Verfier_Depassement_de_TailleMAT($1,$3,$5);
     sprintf(Data_tracker,"%s(%d,%d)",$1,$3,$5);
     if (verifierDeclaration($1) == 0) printf("\033[1;33m## erreur semnatique IDF non declaree  a la ligne : %d col : %d  ##\033[0m\n", nb_ligne, Col); 
     if($3<0 || $5<0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE TAILLE <  0!!!!!!!!!!!!!!!!!!\n");
          printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
     }
     }
|   Idf parouv entier_signe vrg entier_signe parfer { 
     Verfier_Depassement_de_TailleMAT($1,$3,$5);
     sprintf(Data_tracker,"%s(%d,%d)",$1,$3,$5);
     if (verifierDeclaration($1) == 0) printf("\033[1;33m## erreur semnatique IDF non declaree  a la ligne : %d col : %d  ##\033[0m\n", nb_ligne, Col); 
     if($3<0 || $5<0){
         printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
         printYellow("ERREUR SEMANTIQUE TAILLE <  0!!!!!!!!!!!!!!!!!!\n");
          printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
     }
     }



Programme_Principale : PGM  Declaration mc_end 

PGM : mc_prog Idf {source_tracker =strdup($2);}

         
%%
int yyerror(char *msg)
{ printf("\033[1;31mErreur syntaxique a la ligne %d la colone %d le fichier %s\033[0m\n", nb_ligne,Col,file_name);
return 1; }

int main(int argc ,char* argv[]) {

file_name = argv[1];

yyin = fopen( file_name , "r" );

if (yyin == NULL) {

printf("erreur dans le nom du fichier txt \n"); 

return 1;

    }
    initialisation();
    yyparse();
    afficheDeclaration();
    afficherTS();
    Afficher_Qdr();
    

}
yywrap()
{}