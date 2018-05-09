%{ 
    #include<stdio.h> 
	#include<string.h> 
	#include "bison.tab.h"
	extern YYSTYPE yylval;
	extern int l , c ;
%} 

%option yylineno

chiffre [0-9] 
lettre [a-z]
idf {lettre}+
entier 0|(\+)?[1-9][0-9]* 
reel {entier}\.[0-9]*[1-9]+
chaine \'(.)*\'
commentaire ^$(.)*\n


%% 
"MAIN" {	c+=4; 
		yylval = (YYSTYPE)strdup(yytext); 
		return MAIN;
}
"CODE" {	c+=4; 
		    yylval = (YYSTYPE)strdup(yytext); 
		return CODE;
}  
"VERIF" {	c+=5; 
		yylval = (YYSTYPE)strdup(yytext); 
		return VERIF;
} 
"AUTRE" {	c+=5; 
		yylval = (YYSTYPE)strdup(yytext); 
		return AUTRE;
} 
"TANTQUE" {	c+=7;
		yylval = (YYSTYPE)strdup(yytext); 
		return TANTQUE;
} 
"NATURAL" {	c+=7; 
		yylval = (YYSTYPE)strdup(yytext); 
		return NATURAL;
}  
"FLOAT" {	c+=5; 
		yylval = (YYSTYPE)strdup(yytext);
		return FLOAT;
} 
"STRING" {	c+=6;
		yylval = (YYSTYPE)strdup(yytext); 
		return STRING;
} 
";" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return pointVirgule;
} 
"," {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return virgule;
} 
":" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return deuxPoints;
} 
"{" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return accoladeOuvrante;
} 
"}" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return accoladeFermante;
} 
"[" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return crochetOuvrant;
} 
"]" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return crochetFermant;
} 
"(" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return parentheseOuvrante;
} 
")" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return parentheseFermante;
} 
"+" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return addition;
} 
"-" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return soustraction;
} 
"/" {		c++; 
		yylval = (YYSTYPE)strdup(yytext); 
		return division;
} 
"*" {		c++; 
		yylval = (YYSTYPE)strdup(yytext);
		return multiplication;
}
">" {	c++;
	yylval = (YYSTYPE)strdup(yytext); 
	return superieur;
} 
"<" {	c++;
	yylval = (YYSTYPE)strdup(yytext); 
	return inferieur;
} 
"=" { 	c++;
	yylval = (YYSTYPE)strdup(yytext); 
	return affectation;
} 
"==" { 	c+=2;
	yylval = (YYSTYPE)strdup(yytext); 
	return egale;
} 
"!=" { 	c+=2;
	yylval = (YYSTYPE)strdup(yytext);  	
	return different;
} 
">=" { 	c+=2;
	yylval = (YYSTYPE)strdup(yytext); 
	return superieurEg;
} 
"<=" { 	c+=2;
	yylval = (YYSTYPE)strdup(yytext); 
	return inferieurEg;
} 
"|" {	c++;
	yylval = (YYSTYPE)strdup(yytext); 
	return OU;
} 
"&" {	c++;
	yylval = (YYSTYPE)strdup(yytext); 
	return ET;
} 
"!" {	c++;
	yylval = (YYSTYPE)strdup(yytext); 
	return negation;
} 
" " {	c++;
} 
"\n" {	
	l++;
	c=1;
}	
{idf} {	if(yyleng > 8) {
		printf("%s %d %d", yytext, l, c);
		exit(0);
	}else{
		if (!rechercher((YYSTYPE)strdup(yytext))){
			inserer((YYSTYPE)strdup(yytext), 0 , -1 , 1, NULL);
		}
		yylval = (YYSTYPE)strdup(yytext);
		c += strlen(yytext);  
		return idf;	
	}
}
{entier} {	if(atoi(yytext) > 32767){
			printf("%s %d %d", yytext, l, c);
			exit(0);
		}else{
			c += strlen(yytext); 
			yylval = (YYSTYPE)strdup(yytext); 
			return entier;
		}
}
{reel} {	c += strlen(yytext); 
		yylval = (YYSTYPE)strdup(yytext); 
		return reel;
}
{chaine} {	c += strlen(yytext); 
		yylval = (YYSTYPE)strdup(yytext); 
		return chaine;
}
{commentaire} { l ++; c = 1; }

. {	c += strlen(yytext);	
	printf("%s %d %d",yytext, l, c);
	exit(0);
} 

%% 
int yywrap() 
{ 
return 1; 
}
