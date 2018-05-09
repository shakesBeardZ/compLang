/*
*
* Authors : MohDasilva & ShakesBeardz
* Compilers Project
* Compil Lang 
*/
%{ 
    #include<stdio.h> 
	#include<stdlib.h> 
	#include<string.h> 
	extern FILE * yyin;
	extern int yylineno;
	extern char *yytext;
 	int l = 1, c =1;

typedef struct TSelement { 
		char nom[8] ; 
		int nature; 
		int type; 
		int taille; 
		struct TSelement *suivant;
}TSelement; 

TSelement *TS[10000];
FILE* fichierTableSymboles = NULL;

int  indiceIDFS = 0;

/****************************************** Initialiser la table de symboles *****************************************************/
void initialise(){
	fichierTableSymboles = fopen("./tableSymboles.txt","w");
	fputs(" ------------------------------------------------------------------------------- \n", fichierTableSymboles);
	fputs("| variable	| 	nature		| 	type		| 	taille	|\n", fichierTableSymboles);
	fputs(" ------------------------------------------------------------------------------- \n", fichierTableSymboles);
	fclose(fichierTableSymboles);
	int i; 	
	for(i=0;i<1000;i++) TS[i]=NULL; 
}
/********************************************************************************************************************************/

/************************* rechercher un element dans la table de symboles *****************************************************/
TSelement* rechercher(char *e){ 
	TSelement* C;
	int hach=hachage(e);

	if (TS[hach]->nom == NULL) return NULL; 
	else if (! strcmp( TS[hach]->nom , e ) ) {
		return (TSelement*)TS[hach];  
	}
	else 
	{
	    C=TS[hach]->suivant;
	    while (C!=NULL)
		{
		    if (!strcmp(C->nom, e)) return C; 
		    else C=C->suivant;
		}
	    return NULL;
	}
/* 
	int i;
	TSelement *parcour;
	for(i = 0; i<1000; i++){
		if(TS[i] != NULL) {
			parcour=TS[i];
			while(parcour!= NULL){
				if(strcmp(parcour->nom,e) == 0) return 1;
				parcour = parcour->suivant;
			}
		}
	}
	return 0; */
}
/********************************************************************************************************************************/

void ERREUR(char*probleme, int ligne,int colonne,int num)
{
	int taille=strlen(probleme);colonne=colonne-taille;
	switch(num)
    {
     case 1: printf("\nErreur semantique => double decalration de l'identificateur %s  => ligne: %d colonne: %d\n",probleme,ligne,colonne);
                break;
     case 2: printf("\nErreur semantique => %s Identificateur non Declare  => ligne: %d colonne: %d\n",probleme,ligne,colonne);
                break;
     case 3: printf("\nErreur semantique => %s : Incompatibilte des Types => ligne: %d colonne: %d\n",probleme,ligne,colonne);
                break;
    }
}



/*********************** Ecrire dans le fichier apres chaque insertion **********************************************************/
void ecrireDansLeFichier(char* nom, int nature, int type, int taille){
	fichierTableSymboles = fopen("tableSymboles.txt","a");
	fprintf(fichierTableSymboles,"|	%s	|",nom);
	switch(nature){
		case 0 : fputs("	variable	|", fichierTableSymboles); break;
		case 1 : fputs("	tableau		|", fichierTableSymboles);  break;
	}
	switch(type){
		case 0 : fputs("	NATURAL		|", fichierTableSymboles);  break;
		case 1 : fputs("	FLOAT		|", fichierTableSymboles);    break;
		case 2 : fputs("	STRING		|", fichierTableSymboles);   break;
	}
	fprintf(fichierTableSymboles,"	%d	|",taille);
	fputs("\n ------------------------------------------------------------------------------- \n", fichierTableSymboles);
	fclose(fichierTableSymboles);	
}
/********************************************************************************************************************************/


/********************************** Inserer dans la table de symboles **********************************************************/
void inserer(char nom[8], int nature, int type, int taille){ 
	int indice = hachage(nom);
	if(!existeElement(indice)){
		// existe 
		TSelement *parcour, *newElement = malloc(sizeof(TSelement));
		strcpy(newElement->nom,nom); 
		newElement->nature=nature;
		newElement->type=type;
		newElement->taille=taille;
		newElement->suivant=NULL;
		ecrireDansLeFichier(nom, nature, type, taille);
		parcour = TS[indice]; 
		while(parcour->suivant != NULL) parcour = parcour->suivant;
		parcour->suivant = newElement;
	}else{
		// n'existe pas 
		TS[indice] = malloc(sizeof(TSelement));
		strcpy(TS[indice]->nom,nom); 
		TS[indice]->nature=nature;
		TS[indice]->type=type;
		TS[indice]->taille=taille;
		TS[indice]->suivant=NULL;
		ecrireDansLeFichier(nom, nature, type, taille);
	}
}
/********************************************************************************************************************************/

/*********************************************** Afficher la table de symboles *************************************************/

void afficher() { 
	printf("\n--------------------\n table des symboles \n--------------------\n");
    printf("\n|NOM    |NATURE    |TYPE    |TAILLE    |\t");
    printf("\n|--------------------------------------| \t");
	int i;
	TSelement *parcour;
	for(i = 0; i<10000; i++){
		if(TS[i] != NULL) {
			parcour=TS[i];
			while(parcour!= NULL){				
				printf("\n| %s\t|%d\t|%d   \t|%d\t|", parcour->nom,parcour->nature,parcour->type,parcour->taille);
				parcour = parcour->suivant;
			}
		}
	}
	printf("\n*****************************************************************\t\n\n");
}

/************************************ Une simple fonction de hachage (ASCII) ******************************************************/

int hachage(char *elt){
	int code = 0;
    int len = strlen (elt);
    int i;
 
    for (i = 0; i < len; i++)
    {
   	  	code = ((int)elt[i]) + 31 * code;
    }
    return code % 10000;
}

/********************************************************************************************************************************/

/************************************** Verifier si un element est inseré a cette indice ****************************************/

int existeElement(int indice){
	if(TS[indice] != NULL) return 0;
	return 1;
}

/********************************************************************************************************************************/

 void sauv_type(int typevar,char* elt)
{
	TSelement* C;
	char * res = strtok(elt, ",");
	int i;
	while (res != NULL)
	{
		C = rechercher(res);
		printf(" \n %s ", C->nom );
		if(C->type == -1 ){
			C->type=typevar;
			res = strtok (NULL, ",");
		}else {
			ERREUR( C->nom , l , c, 1);
			return;
		}
    }
}


 void sauv_taille_nature(int taille,char* elt)
{
	TSelement* C;
	C = rechercher(elt);
	if(C != NULL){
		C->taille =taille;
		C->nature =1;
		return ;
	}
}



/*********** | Routine de déclaration type simple | ***********/

int Routine_Dec(char* elt)
{
	TSelement* C = rechercher(elt);
	if ( C->type !=-1 ) return 0; 
	else return -1;
}

%} 

%union {
char *chaine;
int entier;
float reel;
}

%token MAIN CODE VERIF AUTRE TANTQUE NATURAL FLOAT STRING
%token pointVirgule virgule deuxPoints
%token addition soustraction division multiplication affectation egale different superieur inferieur superieurEg inferieurEg
%token OU ET negation
%token accoladeOuvrante accoladeFermante crochetOuvrant crochetFermant parentheseOuvrante parentheseFermante  

%token <chaine> idf
%token <chaine> chaine
%token <chaine> entier
%token <chaine> reel

%type <entier> TYPE
%type <chaine> IDFS

%left '+' '-'
%left '*' '/'

%start PROGRAMME
%%
PROGRAMME:  MAIN accoladeOuvrante DECLARATION accoladeFermante { printf("declaration correcte \n");} 
	        CODE accoladeOuvrante INSTRUCTIONS accoladeFermante {
						printf("instruction correcte \n");
						printf("programme correcte \n"); return; 
			};

/******************************************************* partie declarations ************************************************************/

DECLARATION:     IDFS deuxPoints TYPE { 
            	sauv_type($3,$1); 
			}  pointVirgule DECLARATION 
            |  
            ;
 
IDFS :  idf virgule IDFS  {
	    $1 = strcat($1, ",");
		$$ = strcat($1 , $3);
		}
    | idf {
		 	
	  }
    | idf crochetOuvrant  entier crochetFermant virgule IDFS {
    		sauv_taille_nature(atoi($3) , $1 );
			$1 = strcat($1, ",");
			$$ = strcat($1, $6);
		}
    | idf crochetOuvrant  entier crochetFermant {
				sauv_taille_nature(atoi($3) ,$1);
	     }
    ;




TYPE: NATURAL {$$=0;}| FLOAT {$$=1;}| STRING {$$=2;};

/******************************************************* partie instrcution ************************************************************/
INSTRUCTIONS :INSTRUCTION INSTRUCTIONS | ;
INSTRUCTION: AFFECTATION | BOUCLEIF | BOUCLETQ;

AFFECTATION:  idf affectation EXPRESSION_ARTH pointVirgule
			| idf affectation EXPRESSION_LOGQ pointVirgule
			;

/** AIDE BOUCLE **/
ACCOLADEOUVRANTE :parentheseFermante  accoladeOuvrante;
ACCOLADEFERMANTE: accoladeFermante ;
ACCOLADEOUVRANTE: accoladeOuvrante ;


/** BOUCLE VERIF **/
BOUCLEIF:   VERIF parentheseOuvrante EXPRESSION_LOGQ parentheseFermante ACCOLADEOUVRANTE INSTRUCTIONS  ACCOLADEFERMANTE BOUCLEELSE
		;
BOUCLEELSE: AUTRE ACCOLADEOUVRANTE INSTRUCTIONS ACCOLADEFERMANTE | ;

/** BOUCLE TANTQUE **/
BOUCLETQ: TANTQUE parentheseOuvrante  AFFECTATIONTQ virgule EXPRESSION_LOGQ virgule AFFECTATIONTQ parentheseFermante ACCOLADEOUVRANTE  INSTRUCTIONS ACCOLADEFERMANTE;
AFFECTATIONTQ: idf affectation EXPRESSION_ARTH;

/** expression arithmetique **/
	EXPRESSION_ARTH:  EXPRESSION_ARTH1 addition EXPRESSION_ARTH
					| EXPRESSION_ARTH1 soustraction EXPRESSION_ARTH
					| EXPRESSION_ARTH1;

EXPRESSION_ARTH1: TERM multiplication EXPRESSION_ARTH1
		|TERM division EXPRESSION_ARTH1
		|TERM;


TERM:     idf { check_declare($1);  }
		| idf crochetOuvrant  idf crochetFermant { check_declare($1);  }
		| idf crochetOuvrant  entier crochetFermant { check_declare($1);  }
		| VALEURS ;

/** expression comparaison **/

EXPRESSION_LOGQ:  COMPARAISON OPLOG COMPARAISON
				| COMPARAISON OPLOG EXPRESSION_LOGQ
				| parentheseOuvrante EXPRESSION_LOGQ parentheseFermante
				| parentheseOuvrante EXPRESSION_LOGQ parentheseFermante OPLOG parentheseOuvrante EXPRESSION_LOGQ parentheseFermante
				| COMPARAISON  
				;


COMPARAISON : TERM OPCOMP TERM
        	| parentheseOuvrante COMPARAISON parentheseFermante
      ;
OPLOG :   OU 
		| ET
		; 

OPCOMP:   superieur 
		| inferieur 
		| egale 
		| different 
		| superieurEg 
		| inferieurEg ;

VALEURS: entier | reel | chaine ;

/** expression logique **/


%%

int yyerror (char* msg) 
{
	printf("Erreur syntaxique à la ligne %d colonne %d : %s\n",yylineno, c , msg);
	return 1;
}


int main(int argc, char **argv) {
	if( argc > 1){
		++argv, --argc; /* skip over program name */
		yyin = fopen( argv[0], "r" ); 
		initialise();
		if(yyin == NULL) {
			printf(" \t Error While Opening the file");
			return 0;
		}
		yyparse();
	    afficher();
		return 0;
	} else {
		printf("\t Write Your Proram directly to the console (: \n ");
		yyin = stdin;
		yyparse();
		afficher();
		return 0;
	}
}
