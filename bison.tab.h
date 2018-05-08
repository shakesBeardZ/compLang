
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     MAIN = 258,
     CODE = 259,
     VERIF = 260,
     AUTRE = 261,
     TANTQUE = 262,
     NATURAL = 263,
     FLOAT = 264,
     STRING = 265,
     pointVirgule = 266,
     virgule = 267,
     deuxPoints = 268,
     addition = 269,
     soustraction = 270,
     division = 271,
     multiplication = 272,
     affectation = 273,
     egale = 274,
     different = 275,
     superieur = 276,
     inferieur = 277,
     superieurEg = 278,
     inferieurEg = 279,
     OU = 280,
     ET = 281,
     negation = 282,
     accoladeOuvrante = 283,
     accoladeFermante = 284,
     crochetOuvrant = 285,
     crochetFermant = 286,
     parentheseOuvrante = 287,
     parentheseFermante = 288,
     idf = 289,
     chaine = 290,
     entier = 291,
     reel = 292
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 147 "bison.y"

char *chaine;
int entier;
float reel;



/* Line 1676 of yacc.c  */
#line 97 "bison.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


