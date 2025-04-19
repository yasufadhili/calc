
#include <stdio.h>
#include <string.h>
#include "symtable.h"


#define MAX_SYMBOLS 100

typedef struct {
    char *name;
    double value;
} Symbol;

static Symbol symbol_table[MAX_SYMBOLS];
static int symbol_count = 0;


void init_symbol_table(void) {
    symbol_count = 0;
    
    
    set_symbol_value("pi", 3.14159265358979323846);
    set_symbol_value("e", 2.71828182845904523536);
}

double get_symbol_value(const char *name) {
    int i;
    for (i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    fprintf(stderr, "Warning: undefined variable '%s' (treating as 0)\n", name);
    return 0.0;  /* Default value for undefined symbols */
}

/* Set a symbol's value in the table (add it if it doesn't exist) */
void set_symbol_value(const char *name, double value) {
    int i;
    
    /* Check if symbol already exists */
    for (i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    
    /* Symbol doesn't exist yet, add it if there's room */
    if (symbol_count < MAX_SYMBOLS) {
        symbol_table[symbol_count].name = strdup(name);
        symbol_table[symbol_count].value = value;
        symbol_count++;
    } else {
        fprintf(stderr, "Error: symbol table full, can't add '%s'\n", name);
    }
}

void print_symbol_table(void) {
    int i;
    printf("Symbol Table Contents:\n");
    printf("---------------------\n");
    
    if (symbol_count == 0) {
        printf("(empty)\n");
        return;
    }
    
    for (i = 0; i < symbol_count; i++) {
        printf("%-15s = %.10g\n", symbol_table[i].name, symbol_table[i].value);
    }
    printf("---------------------\n");
}