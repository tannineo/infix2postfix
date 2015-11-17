#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef _CARY_HEADER_
#define _CARY_HEADER_

// 与词法分析器的接口
extern int yylineno;
void yyerror(char *s, ...);

// 字符串操作
// 转换 num 和 id 生成新的字符串地址
char* newnum(char*);
// 附上检测机制的string malloc
char* newstr(char*);
// 多项字符串的合并 ... -> str
char* strcomb(char* op1, char* op2, char* opt);

// ID HASH
#define NHASH 9997
char* idtab[NHASH];
// 求HASH
static unsigned idhash(char* sym);
// HASH查找
char* lookup(char* sym);
// HASH添加
char* addid(char* sym);

// 错误链表和相关操作
// 全局变量 __ifMistake 标记是否出错 一开始没错
// int __ifMistake = 0;

// 错误链表结构体 及 首地址

// 新建错误 插入链表

// 打印错误链表
void print_error(void);

#endif
