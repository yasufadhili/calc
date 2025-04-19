
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.h"
#include "parser.tab.h"  /* Generated from parser.y by Bison */

/* Helper to track column position */
void update_position() {
    int i;
    for (i = 0; i < yyleng; i++) {
        if (yytext[i] == '\n') {
            line_num++;
            col_num = 1;
        } else {
            col_num++;
        }
    }
}

/* Reset position for new input */
void reset_position() {
    line_num = 1;
    col_num = 1;
}
%}


%option noyywrap
%option case-insensitive


DIGIT       [0-9]
ALPHA       [a-zA-Z_]
ALNUM       [a-zA-Z0-9_]
WHITESPACE  [ \t\r]

%%

{DIGIT}+                { 
                          yylval.num = atof(yytext); 
                          update_position();
                          return NUMBER;
                        }

{DIGIT}+\.{DIGIT}*      |
\.{DIGIT}+              {
                          yylval.num = atof(yytext);
                          update_position();
                          return NUMBER;
                        }

{ALPHA}{ALNUM}*         { 
                          /* Check for special commands */
                          if (strcasecmp(yytext, "quit") == 0 || 
                              strcasecmp(yytext, "exit") == 0) {
                            update_position();
                            return QUIT;
                          } 
                          else if (strcasecmp(yytext, "vars") == 0 ||
                                  strcasecmp(yytext, "variables") == 0) {
                            update_position();
                            return VARS;
                          }
                          
                          /* Otherwise it's an identifier */
                          yylval.str = strdup(yytext); 
                          update_position();
                          return IDENTIFIER;
                        }

"+"                     { update_position(); return PLUS; }
"-"                     { update_position(); return MINUS; }
"*"                     { update_position(); return TIMES; }
"/"                     { update_position(); return DIVIDE; }
"%"                     { update_position(); return MODULO; }
"^"                     { update_position(); return POWER; }
"="                     { update_position(); return EQUALS; }
"("                     { update_position(); return LPAREN; }
")"                     { update_position(); return RPAREN; }
\n                      { update_position(); return NEWLINE; }

{WHITESPACE}+           { update_position(); /* Skip whitespace */ }

.                       { 
                          fprintf(stderr, "Unrecognised character: %s at line %d, column %d\n", 
                                 yytext, line_num, col_num);
                          update_position();
                        }

%%