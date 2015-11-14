fb3-1: fb3-1.h fb3-2.y fb3-3.l fb3-4.c
	bison -d fb3-2.y
	flex -o fb3-3.lex.c fb3-3.l
	gcc -o $@ fb3-2.tab.c fb3-3.lex.c fb3-4.c

clean:
	rm fb3-2.tab.c fb3-2.tab.h fb3-3.lex.c
	rm fb3-1
