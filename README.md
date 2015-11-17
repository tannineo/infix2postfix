# infix2postfix
a homework of Compilers, change infix expressions into postfix ones.  
这是一个编译原理的作业。  

## Lexical Analysis & Regular Expression(using flex)
词法分析与正则表达式（使用flex）  
```
VAR   : var
ID    : [A-Za-z][A-Za-z0-9]*
NUM   : [0-9]+
MULOP : [*/]
ADDOP : [+-]
```
Notice:  
1. The defination of 'NUM' allows zeros as the start, and no decimal numbers.  
2. NUM and ID will be limited in 8 characters, if exceed, errors will occur.  
注意：  
1. NUM定义上允许先导0, 且不支持小数。  
2. NUM和ID被限制为8位字符，若超出则报出错误。  

## Syntax Analysis & BNF Expression(using bison)
语法分析与BNF表达式（使用bison，gnu的yacc）  
```
program:
  compound
;

compound:
  %empty
  | declaration assignstatement compound
;

declaration:
  %empty
  | VAR identifier_list ';'
;

identifier_list:
  %empty
  | ID ',' identifier_list
;

assignstatement:
  %empty
  | ID '=' expression ';'
;

expression:
  expression ADDOP expression
  | expression MULOP expression
  | expression '^' expression
  | '(' expression ')'
  | ID
  | NUM
;
```

## Compile Options
`-lfl` is needed when compiling `lex.yy.c`.

## Flex and Bison
Some examples from the book **flex & bison**.  
**flex与bison**一书的一些示例代码。  
