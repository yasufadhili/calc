
#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <stdio.h>

extern int yyparse(void);
extern int yylex(void);
extern void yyerror(const char *s);
extern FILE *yyin;


extern int line_num;
extern int col_num;


extern void reset_position(void);

#endif /* CALCULATOR_H */