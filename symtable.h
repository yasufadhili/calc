
#ifndef SYMTABLE_H
#define SYMTABLE_H

/* Initialize the symbol table */
void init_symbol_table(void);

/* Get a symbol's value from the table */
double get_symbol_value(const char *name);

/* Set a symbol's value in the table (add it if it doesn't exist) */
void set_symbol_value(const char *name, double value);

/* Print all defined symbols and their values */
void print_symbol_table(void);

#endif /* SYMTABLE_H */