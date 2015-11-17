#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "header.h"

// 转换 num 和 id 生成新的字符串地址
char* newnum(char* yyInText) {
  int zeros = 0;
  char* p;

  //计算前导0
  while( *(yyInText+zeros) == '0' ) zeros++;

  if( zeros && !(*(yyInText+zeros)) && *(yyInText+zeros-1) == '0' )
    zeros--; //全0

  if( !(p = strdup(yyInText)) ) {
    yyerror("newnum: out of space"); abort();
  }

  //printf("newnum: %s\n", p);
  return p;
}

// 附上检测机制的string malloc
char* newstr(char* yyInText) {
  char* p;
  if( !(p = strdup(yyInText)) ) {
    yyerror("newstr: out of space"); abort();
  }
  p = strdup(yyInText);
  //printf("newstr: %s\n", p);
  return p;
}


// 三项字符串的合并 -> str
char* strcomb(char* op1, char* op2, char* opt) {
  char* p;
  char* tmp;
  int i;
  int ttlLen;

  // 统计字符数
  ttlLen = strlen(op1) + strlen(op2) + 1 + 3;

  // 申请空间
  if( !(p = (char*)malloc(sizeof(char)*ttlLen)) ) {
    yyerror("strcomb out of space"); abort();
  }

  // 拼接字符串
  tmp = op1;
  while(*p++ = *tmp++);
  p--;
  *p++ = ' ';
  tmp = op2;
  while(*p++ = *tmp++);
  p--;
  *p++ = ' ';
  tmp = opt;
  while(*p++ = *tmp++);
  p-=ttlLen;

  //printf("strcomb: %s\n", p);
  return p;
}


// ID HASH
// 求HASH
static unsigned idhash(char* sym) {
  unsigned int hash = 0;
  unsigned c;
  while(c = *sym++) hash = hash*9 ^ c;
  return hash;
}
// HASH查找 if exist output
char* lookup(char* sym) {
  char** sp = &idtab[idhash(sym)%NHASH];
  int scount = NHASH; /* 查找次数 */


  while(--scount >= 0) {
    if(*sp && !strcmp(*sp, sym)) {
      //printf("same found\n");
      return *sp;
    }
    if(++sp >= idtab+NHASH) sp = idtab; /* 尝试下一个条目 */
  }
  //printf("HASH OK\n");
  return NULL;/* 所有条目都试过了 */
}
// HASH添加
char* addid(char* sym) {
  char** sp = &idtab[idhash(sym)%NHASH];
  int scount = NHASH; /* 查找次数 */

  while(--scount >= 0) {
    if(*sp && !strcmp(*sp, sym)) {
      //printf("same found\n");
      return NULL;
    }/* 重复变量声明 */

    if(!*sp) { /* 新条目 */
      *sp = strdup(sym);
      //printf("new id %s logged!\n", *sp);
      return *sp;  /* 返回位置 */
    }

    if(++sp >= idtab+NHASH) sp = idtab; /* 尝试下一个条目 */
  }

  fputs("addid: symbol table overflow\n", stderr);
  abort(); /* 所有条目都试过了，符号表已满 */
}

// 与词法分析器的接口 输出错误
void yyerror(char *s, ...) {
  va_list ap;
  va_start(ap, s);
  // yylineno 于自动生成的头文件中定义，返回当前位置的行号
  fprintf(stderr, "%d: error: ", yylineno);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}

int main(int argc, char** argv){
  if(argc < 2) {
    printf("need filename\n"); return 1;
  }
  if(argc > 2) {
    printf("only ONE file required\n"); return 1;
  }

  freopen(argv[1], "r", stdin);

  yyparse();

  return 0;
}
