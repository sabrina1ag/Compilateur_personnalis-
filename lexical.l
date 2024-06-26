%{
#include "syntaxique.tab.h"
#include "ts.h"
extern nb_ligne;
extern Col;
extern file_name;
extern YYSTYPE yylval;
%}


lettre [a-zA-Z]
chiffre [0-9]
IDF {lettre}({lettre}|{chiffre}|(_{lettre}|{chiffre}))*
entier  {chiffre}+
reel {chiffre}+\.{chiffre}+
entier_signe [+-]{chiffre}+
reel_signe [+-]{chiffre}+\.{chiffre}+
chaine \"[^"]*\"

commentaire %(.)*\n

%%

"PROGRAM"    {
     printf("Mot cle PROGRAM\n");
     Col = Col + strlen(yytext);
     rechercher(yytext,"Mot cle",0,0,1);
     return mc_prog;
   
 }
"END"        {
    printf("Mot cle END\n"); 
    Col = Col + strlen(yytext);
     rechercher(yytext,"Mot cle",0,0, 1);
    return mc_end;
    }
"ROUTINE"    {printf("Mot cle Routine\n"); Col = Col + strlen(yytext);rechercher(yytext,"Mot cle",0,"", 1);  return mc_routine;}
"ENDR"       {printf("Mot cle ENDR\n");  Col = Col + strlen(yytext);rechercher(yytext,"Mot cle",0,"", 1); return mc_endr;}

"READ"       {printf("Mot cle READ\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_read;}
"WRITE"      {printf("Mot cle WRITE\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_write;}

"IF"         {printf("Mot cle IF\n"); Col = Col + strlen(yytext);  rechercher(yytext,"Mot cle",0,"", 1); return mc_if;}
"THEN"       {printf("Mot cle THEN\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_then;}
"ELSE"       {printf("Mot cle ELSE\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_else;}
"ENDIF"      {printf("Mot cle ENDIF\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_endif;}

"DOWHILE"    {printf("Mot cle DOWHILE\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_dowhile;}
"ENDDO"      {printf("Mot cle ENDDO\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_enddo;}

"EQUIVALENCE" {printf("Mot cle EQUIVALENCE\n"); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_equivalence;}

"INTEGER"    {printf("type: INTEGER\n"); Col = Col + strlen(yytext);  yylval.chaine = strdup(yytext); rechercher(yytext,"Type",0,"", 1); return INTEGER;}
"REAL"       {printf("type: REAL\n"); Col = Col + strlen(yytext);  yylval.chaine = strdup(yytext); rechercher(yytext,"Type",0,"", 1); return REAL;}
"LOGICAL"    {printf("type: LOGICAL\n "); Col = Col + strlen(yytext);  yylval.chaine = strdup(yytext); rechercher(yytext,"Type",0,"", 1); return LOGICAL;}
"CHARACTER"  {printf("type: CHARACTER\n"); Col = Col + strlen(yytext);  yylval.chaine = strdup(yytext); rechercher(yytext,"Type",0,"", 1); return CHARACTER;}

"DIMENSION"  {printf("%s\n", yytext); Col = Col + strlen(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_dimension;}

"OR"         {printf("operateur OR\n"); Col = Col + strlen(yytext);  rechercher(yytext ,"Separateur",0,"",2); return OR;} 
"AND"        {printf("operateur AND\n"); Col = Col + strlen(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return AND;}
"GT"         {printf("operateur GT\n");Col = Col + strlen(yytext);  rechercher(yytext ,"Separateur",0,"",2); return GT;}
"GE"         {printf("operateur GE\n");Col = Col + strlen(yytext);  rechercher(yytext ,"Separateur",0,"",2); return GE;}
"EQ"         {printf("operateur EQ\n"); Col = Col + strlen(yytext);   rechercher(yytext ,"Separateur",0,"",2); return EQ;}
"NE"         {printf("operateur NE\n"); Col = Col + strlen(yytext);  rechercher(yytext ,"Separateur",0,"",2); return NE;}
"LE"         {printf("operateur LE\n"); Col = Col + strlen(yytext);  rechercher(yytext ,"Separateur",0,"",2); return LE;}
"LT"         {printf("operateur LT\n"); Col = Col + strlen(yytext);  rechercher(yytext ,"Separateur",0,"",2); return LT;}
"+"          {
    printf("operateur +\n"); 
    Col = Col + strlen(yytext); 
     yylval.chaine = strdup(yytext);
     rechercher(yytext ,"Separateur",0,"",2);
    return mc_plus;
    }
"-"          {printf("operateur -\n");Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return mc_moins;}
"*"          {printf("operateur *\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2); return mc_mul;}
"/"          {printf("operateur /\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2); return mc_div;}

"CALL"       {printf("Mot cle CALL\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext); rechercher(yytext,"Mot cle",0,"", 1); return mc_call;}


"TRUE" {
     printf("valeur booleene %s\n", yytext);
       Col = Col + strlen(yytext);
       yylval.entier = 1;
       rechercher(yytext,"Cst","LOGICAL","",5);
        return True;
}

"FALSE" {
     printf("valeur booleene %s\n", yytext);
       Col = Col + strlen(yytext);
       yylval.entier = 0;
       rechercher(yytext,"Cst","LOGICAL","",5);
        return False;
}

{IDF} {
    yylval.chaine = strdup(yytext);
        if (yyleng>10){
            printf("warning :taille d'Idf plus que 10");
            return erreur;
        }
        else {
        printf(" IDF %s \n", yytext);
        rechercher(yytext,"Idf","","",0);
        Col = Col + strlen(yytext);
        return Idf;
        }
        
}

{entier} {
    printf("Constante entiere\n");
    if(atoi(yytext) > 32767 ){
    printf("la constante a depasse l'intervalle autorise\n");
        return erreur;
    }
    yylval.entier = atoi(yytext);
    rechercher(yytext,"Cst","INTEGER","",5);
    return entier;
}

{entier_signe} {
    printf("nomre entier signe\n");
    if(atoi(yytext) < -32768 || atoi(yytext) > 32767 ){
    printf("la constante a depasse l'intervalle autorise\n");
        return erreur;
    }
    yylval.entier = atoi(yytext);
    rechercher(yytext,"Cst","INTEGER","",5);
    return entier_signe;
}

{reel} {
     printf("Constante reel\n");
     if(atof(yytext) > 32767.0 ){
        printf("la constante a depasse l'intervalle autorise\n");
        return erreur;
     }
     yylval.reel = atof(yytext);
     rechercher(yytext,"Cst","REAL","",5);
     return reel;
}

{reel_signe} {
     printf("nombre reel signe\n");
     if(atof(yytext) < -32768.0 || atof(yytext) > 32767.0 ){
        printf("la constante a depasse l'intervalle autorise\n");
        return erreur;
     }
     yylval.reel = atof(yytext);
     rechercher(yytext,"Cst","REAL","",5);
     return reel_signe;
}



{chaine} {
    Col = Col + strlen(yytext);
    yylval.chaine = strdup(yytext);
    rechercher(yytext,"Cst","CHARACTER","",5);
    printf("Chaine %s\n",yytext);
    return chaine;
}

{commentaire} {
printf("commentaire : %s",yytext);
nb_ligne =nb_ligne+1;
}



"="         {printf("Operateur d'affectation\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return aff;}
";"         {printf("Point-virgule\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return pvg;}
","         {printf("Virgule\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return vrg;}
"("         {printf("Parenthese ouvrante\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return parouv;}
")"         {printf("Parenthese fermante\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return parfer;}
"."         {printf("Point\n"); Col = Col + strlen(yytext); yylval.chaine = strdup(yytext);  rechercher(yytext ,"Separateur",0,"",2);  return point;}




[ \t] {
    // ignorer les espaces et les tabulations
}


\n {
    nb_ligne = nb_ligne + 1;
    Col = 0;
}

. {
    printf("\033[1;31mErreur lexicale a la ligne %d la colone %d file name %s: Caractere non reconnu:\033[0m\n", nb_ligne,Col,file_name, yytext);
    return erreur;
    // Gerer l'erreur, par exemple, en renvoyant un token special ou en quittant le programme
}
