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

typedef struct TSelement { 
		char nom[8] ; 
		int nature; 
		int type; 
		int taille; 
		struct TSelement *suivant;
}TSelement; 

TSelement *TS[1000];
FILE* fichierTableSymboles = NULL;

/****************************************** Initialiser la table de symboles *****************************************************/
void initialise(){
	fichierTableSymboles = fopen("./../code/tableSymboles.txt","w");
	fputs(" ------------------------------------------------------------------------------- \n", fichierTableSymboles);
	fputs("| variable	| 	nature		| 	type		| 	taille	|\n", fichierTableSymboles);
	fputs(" ------------------------------------------------------------------------------- \n", fichierTableSymboles);
	fclose(fichierTableSymboles);
	int i; 	
	for(i=0;i<1000;i++) TS[i]=NULL; 
}
/********************************************************************************************************************************/

/************************* rechercher un element dans la table de symboles *****************************************************/
int rechercher(char *e){ 
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
	return 0;
}
/********************************************************************************************************************************/


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
	for(i = 0; i<1000; i++){
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

int hachage(char *idf){
	int i, somme = 0;
	for( i=0; idf[i] != '\0'; i++)
		somme += idf[i];
	somme %= 1000;
	return somme;
}

/********************************************************************************************************************************/

/************************************** Verifier si un element est inseré a cette indice ****************************************/

int existeElement(int indice){
	if(TS[indice] != NULL) return 0;
	return 1;
}

/********************************************************************************************************************************/

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

DECLARATION: 	idf deuxPoints TYPE pointVirgule DECLARATION {
					if(rechercher($1)){
						printf("double declaration \n");
						return 0;
					}else inserer($1,0,$3,1);
				}
				| idf crochetOuvrant  entier crochetFermant deuxPoints TYPE pointVirgule DECLARATION  {
					if(rechercher($1)){
						printf("double declaration \n");
						return 0;
					}else inserer($1,1,$6,atoi($3));
				}
				| 
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
EXPRESSION_ARTH: EXPRESSION_ARTH1 addition EXPRESSION_ARTH
				|EXPRESSION_ARTH1 soustraction EXPRESSION_ARTH
				|EXPRESSION_ARTH1;

EXPRESSION_ARTH1:TERM multiplication EXPRESSION_ARTH1
		|TERM division EXPRESSION_ARTH1
		|TERM;


TERM: idf | idf crochetOuvrant  idf crochetFermant | idf crochetOuvrant  entier crochetFermant |VALEURS ;

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

int yyerror(char *msg){
	printf(" syntaxic error %d", yylineno);
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
