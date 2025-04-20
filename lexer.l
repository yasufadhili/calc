
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

void report_invalid_hex(const char *text);

%}


%option noyywrap
%option case-insensitive


DIGIT       [0-9]
ALPHA       [a-zA-Z_]
ALNUM       [a-zA-Z0-9_]
WHITESPACE  [ \t\r]

%%


0[bB][01]+ {
    yylval.num = (double)strtol(yytext + 2, NULL, 2);
    update_position();
    return NUMBER;
}
0[bB][^01[:space:]]+ {
    fprintf(stderr, "Invalid binary literal: %s at line %d, column %d\n", yytext, line_num, col_num);
    update_position();
}
0[bB][[:space:]\n\r\t]+ {
    fprintf(stderr, "Invalid binary literal (no digits): %s at line %d, column %d\n", yytext, line_num, col_num);
    update_position();
}



0[oO][0-7]+ {
    yylval.num = (double)strtol(yytext + 2, NULL, 8);
    update_position();
    return NUMBER;
}
0[oO][^0-7[:space:]]+ {
    fprintf(stderr, "Invalid octal literal: %s at line %d, column %d\n", yytext, line_num, col_num);
    update_position();
}
0[oO][[:space:]\n\r\t]+ {
    fprintf(stderr, "Invalid octal literal (no digits): %s at line %d, column %d\n", yytext, line_num, col_num);
    update_position();
}



{DIGIT}+ {
    yylval.num = strtod(yytext, NULL);
    update_position();
    return NUMBER;
}
{DIGIT}+\.{DIGIT}* |
\.{DIGIT}+ {
    yylval.num = strtod(yytext, NULL);
    update_position();
    return NUMBER;
}



0[xX][0-9a-fA-F]+ {
    char *endptr;
    long val = strtol(yytext, &endptr, 16);
    if (*endptr != '\0') {
        report_invalid_hex(yytext);
    } else {
        yylval.num = (double)val;
        update_position();
        return NUMBER;
    }
}
0[xX][^0-9a-fA-F\n\r\t ]+ {
    report_invalid_hex(yytext);
    update_position();
}
0[xX]([ \t\r\n]*) {
    report_invalid_hex(yytext);
    update_position();
}


{ALPHA}{ALNUM}* {
    if (strcasecmp(yytext, "quit") == 0 || strcasecmp(yytext, "exit") == 0) {
        update_position();
        return QUIT;
    } else if (strcasecmp(yytext, "vars") == 0 || strcasecmp(yytext, "variables") == 0) {
        update_position();
        return VARS;
    }
    yylval.str = strdup(yytext);
    update_position();
    return IDENTIFIER;
}

"&"                     { update_position(); return AND; }
"|"                     { update_position(); return OR; }
"~"                     { update_position(); return NOT; }
"^"                     { update_position(); return XOR; }
"<<"                    { update_position(); return SHL; }
">>"                    { update_position(); return SHR; }

"+"                     { update_position(); return PLUS; }
"-"                     { update_position(); return MINUS; }
"*"                     { update_position(); return TIMES; }
"/"                     { update_position(); return DIVIDE; }
"%"                     { update_position(); return MODULO; }
"^^"                     { update_position(); return POWER; }
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


void report_invalid_hex(const char *text) {
    fprintf(stderr, "Invalid hex literal detected: %s\n", text);
}