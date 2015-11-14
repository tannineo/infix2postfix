/* 识别计算器的记号 */
%option noyywrap nodefault yylineno

  /* 浮点数指数部分 */
EXP ([Ee][-+]?[0-9]+)

%{
  #include "fb3-1.h"
  #include "fb3-2.tab.h"
%}

%%
"+"|"-"|"*"|"/"|"|"|"("|")" { return yytext[0]; }

[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }

\n { return EOL; }

  /* 注释 */
"//".*

  /* 空白字符忽略 */
[ \t]

. { yyerror("Mystery character %c\n", *yytext); }

%%
