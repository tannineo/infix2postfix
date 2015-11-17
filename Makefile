compiler: header.h grammar.y scanner.l helper.c
	bison -d grammar.y
	flex -o scanner.lex.c scanner.l
	gcc -o $@ grammar.tab.c scanner.lex.c helper.c -lfl

clean:
	rm grammar.tab.c grammar.tab.h scanner.lex.c
	rm compiler
