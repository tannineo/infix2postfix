%{
#include "fb1-5.tab.h"
%}

%%
"+"       { return ADD; }
"-"       { return SUB; }
"*"       { return MUL; }
"/"       { return DIV; }
"|"       { return ABS; }
[0-9]+    { yylval = atoi(yytext); return NUMBER; }
\n        { return EOL; }
[ \t]     { /* ignore white space characters */ }
.         { printf("Mystery characters %c\n", *yytext); }

%%
