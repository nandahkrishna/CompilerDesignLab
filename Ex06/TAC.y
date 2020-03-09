%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
int yylex(void);
#include "y.tab.h"
int cc = 1, tc = 1, sc = 0;
%}
%token TERM RELOP OP WHILE DO SWITCH CASE DEFAULT BREAK
%union
{
    int intval;
    float floatval;
    char *str;
}
%type<str> TERM RELOP OP
%%
line: /* empty */
    | TERM '=' TERM OP TERM ';' { printf("t%d := %s %s %s\n%s := t%d\n", tc, $3, $4, $5, $1, tc); tc++; } line
    | TERM '=' TERM RELOP TERM ';' { printf("t%d := %s %s %s\n%s := t%d\n", tc, $3, $4, $5, $1, tc); tc++; } line
    | TERM '=' TERM ';' { printf("%s := %s\n", $1, $3); } line
    | WHILE TERM RELOP TERM DO '{' { printf("LABEL%d: if not %s %s %s then goto FALSE%d\nTRUE%d: ", cc, $2, $3, $4, cc, cc); } line '}' { printf("FALSE%d: ", cc); cc++; } line
    | WHILE TERM OP TERM DO '{' { printf("LABEL%d: if not %s %s %s then goto FALSE%d\nTRUE%d: ", cc, $2, $3, $4, cc, cc); } line '}' { printf("FALSE%d: ", cc); cc++; } line
    | WHILE TERM DO '{' { printf("LABEL%d: if not %s then goto FALSE%d\nTRUE%d: ", cc, $2, cc, cc); } line '}' { printf("FALSE%d: ", cc); cc++; } line
    | SWITCH '(' TERM RELOP TERM ')' '{' { printf("t%d := %s %s %s\n", tc, $3, $4, $5); sc = tc; tc++; } cases '}' { printf("NEXT%d: ", cc); cc++; } line
    | SWITCH '(' TERM OP TERM ')' '{' { printf("t%d := %s %s %s\n", tc, $3, $4, $5); sc = tc; tc++; } cases '}' { printf("NEXT%d: ", cc); cc++; } line
    | SWITCH '(' TERM ')' '{' { printf("t%d := %s\n", tc, $3); sc = tc; tc++; } cases '}' { printf("NEXT%d: ", cc); cc++; } line
    | BREAK ';' line { printf("goto NEXT%d\n", cc); }
cases: /* empty */
     | CASE TERM ':' { printf("if t%d == %s do ", sc, $2); } line cases
     | DEFAULT ':' line { printf("goto NEXT%d\n", cc); } cases
%%
int yyerror(char* s)
{
  fprintf(stderr, "%s\n", s);
  return 0;
}
int yywrap()
{
  return 1;
}
int main()
{
  yyparse();
  return 0;
}
