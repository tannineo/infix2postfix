calc: header.h calc.y lex.l calchelper.c
	bison -d calc.y
	flex -o calc.lex.c lex.l
	gcc -o $@ calc.tab.c calc.lex.c calchelper.c

clean:
	rm calc.tab.c calc.tab.h calc.lex.c calc.c
	rm calc
