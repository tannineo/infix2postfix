%option noyywrap
%option nodefault
/* 声明IFILE状态 */
/* %x是只能匹配自己状态下的模式  */
/* %s是同其他匹配一起匹配自己状态下的模式 */
/* 初始默认存在 INITIAL 状态 */
%x IFILE

%{
  struct bufstack {
    struct bufstack *prev; /* 上一个文件信息 */
    YY_BUFFER_STATE bs; /* 保存的缓冲区 */
    int lineno; /* 保存的行号 */
    char *filename; /* 文件名 */
    FILE *f; /* 当前文件 */
  } *curbs = 0;

  char *curfilename;

  int newfile(char* fn);
  int popfile(void);
%}

%%/* 从 #include < 或者 #include \" 开始IFILE状态的匹配 */
^"#"[ \t]*include[ \t]*\[\"<] { BEGIN IFILE; }

<IFILE>[^ \t\n\"]+ {
  int c;
  while((c = input()) && c != '\n');
  yylineno++;
  if(!newfile(yytext)) yyterminate(); /* no such file */
  BEGIN INITIAL;
}

<IFILE>.|\n {
  fprintf(stderr, "%4d bad include line\n", yylineno);
  yyterminate();
}

<<EOF>> { if(!popfile()) yyterminate(); }

^. { fprintf(yyout, "%4d %s", yylineno, yytext); }
^\n { fprintf(yyout, "%4d %s", yylineno++, yytext); }
\n { ECHO; ++yylineno; }
. { ECHO; }

%%
int main(int argc, char ** argv) {
  if(argc < 2) {
    fprintf(stderr, "need filename.\n");
    return 1;
  }

  if(newfile(argv[1])) yylex();
}

int newfile(char *fn) {
  FILE *f = fopen(fn, "r");
  struct bufstack *bs = malloc(sizeof(struct bufstack));

  if(!f) { perror(fn); return 0; }
  if(!bs) { perror("malloc"); exit(1); }

  /* 记住当前状态 */
  if(curbs) curbs->lineno = yylineno;
  bs->prev = curbs;

  /* 建立文件信息 */
  bs->bs = yy_create_buffer(f, YY_BUF_SIZE);
  bs->f = f;
  bs->filename = fn;
  yy_switch_to_buffer(bs->bs);
  curbs = bs;
  yylineno = 1;
  curfilename = fn;
  return 1;
}

int popfile() {
  struct bufstack *bs = curbs;
  struct bufstack *prevbs;

  if(!bs) return 0;

  /* 删除文件信息 */
  fclose(bs->f);
  yy_delete_buffer(bs->bs);

  /* 切换回上一个文件 */
  prevbs = bs->prev;
  free(bs);

  if(!prevbs) return 0;

  yy_switch_to_buffer(prevbs->bs);
  curbs = prevbs;
  yylineno = curbs->lineno;
  curfilename = curbs->filename;
  return 1;
}
