all: lang

flex: lexical.l 
	flex calc.l

bison: bison.y
	bison -d bison.y
	
lang: lexical.l bison.y
	bison -d bison.y
	flex lexical.l
	gcc bison.tab.c lex.yy.c -lfl -ly -o bin/comlang
	rm bison.tab.* lex.yy.c -rf 

clean: 
	rm bison.tab.* lex.yy.c bin/* *.exe -rf 
test: 
	bin\comlang.exe code\test.txt