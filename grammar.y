%{
  #include <stdio.h>
  #include <math.h>

  int yylex (void);
  void yyerror(char const*, ...);
  // 是否有错误的标志
  // 从出现错误开始后面的后缀表达式结果一概不输出
  int flag = 0;
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
program:
  | compound END { printf("Compiling End...\n"); exit(0); }
;

/* error 用来进行错误恢复 */
/* 出错相当于直接跳过这条语句，即下个符号读 ; */
compound:
  | declaration compound {}
  | assignstatement compound {}
  | error compound {}
;

declaration: VAR identifier_list ';' {}
;

identifier_list: ID {
    /*printf("%s OK\n", $1);*/
    if(!lookup($1)) {
      //printf("Adding %s to idtab...\n", $1);
      addid($1);
    } else {
      yyerror("Redefination!\n");
      exit(1);
    }
  }
  | ID ',' identifier_list {
    /*printf("%s OK\n", $1);*/
    if(!lookup($1)) {
      //printf("Adding %s to idtab...\n", $1);
      addid($1);
    } else {
      yyerror("Redefination!\n");
      exit(1);
    }
  }
;

assignstatement:
  | ID '=' expression ';' {
    if(!lookup($1)) {
      yyerror("%s No Defination!", $1);
      flag++;
    }
    $$ = strcomb($1, $3, "=");
    if(!flag)printf("%s\n", $$);
  }
;

expression:
  expression ADDOP expression { $$ = strcomb($1, $3, $2); }
  | expression MULOP expression { $$ = strcomb($1, $3, $2); }
  | expression '^' expression { $$ = strcomb($1, $3, "^"); }
  | '(' expression ')' { $$ = $2; }
  | ID  {
    if(!lookup($1)) {
      yyerror("%s No Defination!", $1);
      flag++;
    }
    $$ = $1;
  }
  | NUM { $$ = $1; }
;

%%
