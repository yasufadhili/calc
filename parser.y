
%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "calculator.h"
#include "symtable.h"


int line_num = 1;
int col_num = 1;

void yyerror(const char *s);
%}


%define parse.error verbose
%locations


%union {
    double num;        /* For numeric values */
    char *str;         /* For identifiers or strings */
}


%token <num> NUMBER
%token <str> IDENTIFIER
%token PLUS MINUS TIMES DIVIDE MODULO
%token POWER LPAREN RPAREN
%token EQUALS
%token NEWLINE
%token QUIT VARS


%left PLUS MINUS
%left TIMES DIVIDE MODULO
%right UMINUS
%right POWER


%type <num> expr
%type <num> assignment

/* Starting grammar rule */
%start calculation

%%

calculation:
    | calculation line
    ;

line:
    NEWLINE
    | expr NEWLINE                  { printf("= %.10g\n", $1); }
    | assignment NEWLINE            { printf("= %.10g\n", $1); }
    | QUIT NEWLINE                  { printf("Goodbye!\n"); exit(0); }
    | VARS NEWLINE                  { print_symbol_table(); }
    | error NEWLINE                 { yyerrok; }
    ;

assignment:
    IDENTIFIER EQUALS expr          {
                                        set_symbol_value($1, $3);
                                        free($1);
                                        $$ = $3;
                                    }
    ;

expr:
    NUMBER                          { $$ = $1; }
    | IDENTIFIER                    {
                                        $$ = get_symbol_value($1);
                                        free($1);
                                    }
    | expr PLUS expr                { $$ = $1 + $3; }
    | expr MINUS expr               { $$ = $1 - $3; }
    | expr TIMES expr               { $$ = $1 * $3; }
    | expr DIVIDE expr              {
                                        if ($3 == 0) {
                                            yyerror("division by zero");
                                            $$ = 0;
                                        } else {
                                            $$ = $1 / $3;
                                        }
                                    }
    | expr MODULO expr              {
                                        if ($3 == 0) {
                                            yyerror("modulo by zero");
                                            $$ = 0;
                                        } else {
                                            $$ = fmod($1, $3);
                                        }
                                    }
    | expr POWER expr               { $$ = pow($1, $3); }
    | MINUS expr %prec UMINUS       { $$ = -$2; }
    | LPAREN expr RPAREN            { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d, column %d: %s\n", line_num, col_num, s);
}