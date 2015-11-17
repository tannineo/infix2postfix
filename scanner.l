%option noyywrap nodefault yylineno

%{
  #include "header.h"
  #include "grammar.tab.h"
%}

%%
  /* 变量声明 */
var { /*printf("found VAR!\n");*/ return VAR; }

  /* 变量名 */
[A-Za-z][A-Za-z0-9]* { yylval.str = newstr(yytext); return ID; }

  /* 数字常量 */
[0-9]+ { yylval.str = newnum(yytext); return NUM; }

  /* + - */
[+-] { yylval.str = newstr(yytext); return ADDOP; }

  /* * / */
[*/] { yylval.str = newstr(yytext); return MULOP; }

  /* 直接返回的符号 */
[(),;^=] { /*printf("found %s !\n", yytext);*/ return yytext[0]; }

  /* 将其他字符视为空格 */
.
\n

<<EOF>> { return END; }

%%
