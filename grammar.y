%{
  #include <stdio.h>
  #include <math.h>

  int yylex (void);
  void yyerror(char const*);
%}

%union {
  char* str;
}

%token VAR END
%token <str> ID NUM MULOP ADDOP
%type <str> compound declaration identifier_list assignstatement expression

  /* 符号优先级与结合规则 从下到上 从高到低 */
%right '='
%left ADDOP
%left MULOP
%left '^'

%%
program: %empty
  | compound END { printf("end...\n"); exit(0); }
;

compound: %empty
  | declaration assignstatement compound {  }
;

  /* error 用来进行错误恢复 */
  /* 出错相当于直接跳过这条语句，即下个符号读 ; */
declaration: %empty
  | VAR identifier_list ';' { printf("def"); }
;

identifier_list:
  | ID ',' identifier_list { if(!lookup($1)) { addid($1); } else { printf("redefination!\n"); abort(); } }
;

assignstatement:
  | ID '=' expression ';' { $$ = strcomb($1, $3, "="); }
;

expression:
  expression ADDOP expression { $$ = strcomb($1, $3, $2); }
  | expression MULOP expression { $$ = strcomb($1, $3, $2); }
  | expression '^' expression { $$ = strcomb($1, $3, "^"); }
  | '(' expression ')' { $$ = $2; }
  /* 默认 $$ = $1 */
  | ID  { $$ = $1; /*check_ifexist();*/ }
  | NUM { $$ = $1; }
;
