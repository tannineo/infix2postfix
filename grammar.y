%{
  #include <stdio.h>
  #include <math.h>

  int yylex (void);
  void yyerror(char const*);
%}

%define api.value.type {int}
%token VAR ID NUM LB RB POWER MULOP ADDOP AGN SPLIT SE
