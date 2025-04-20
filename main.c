
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.h"
#include "symtable.h"


void print_welcome() {
    printf("Calc\n");
    printf("==============================\n");
    printf("'vars'to show defined variables, ");
    printf("'quit' to exit the calculator\n");
    printf("==============================\n");
}


void clear_screen() {
    /* ANSI escape sequence to clear screen and move cursor to home position */
    printf("\033[2J\033[H");
}

int main(int argc, char **argv) {
    
    init_symbol_table();
    
    print_welcome();
    
    /* Parse input and evaluate expressions */
    if (argc > 1) {
        /* If a file is specified, read from it */
        if ((yyin = fopen(argv[1], "r")) == NULL) {
            fprintf(stderr, "Error: Could not open file '%s'\n", argv[1]);
            return 1;
        }
    } else {
        /* Otherwise read from stdin */
        yyin = stdin;
    }
    
    /* Start parsing */
    while (1) {
        /* yyparse() will return 0 on successful parsing, non-zero on error */
        if (yyparse() != 0) {
            /* Reset the parser state for the next expression */
            /* This is handled by the 'error NEWLINE' rule in the grammar */
        }
        
        /* Print prompt for interactive mode */
        if (yyin == stdin) {
            printf(">> ");
        }
    }
    
    return 0;
}