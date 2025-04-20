CC = gcc
CFLAGS = -Wall -g -O2
LDLIBS = -lm

LEX = flex
YACC = bison
YFLAGS = -d -v

TARGET = calc

# Directories
BUILD_DIR = build
BIN_DIR = bin

# Source files
PARSER_Y = parser.y
LEXER_L = lexer.l
SYMTABLE_C = symtable.c
MAIN_C = main.c

# Generated files
PARSER_C = $(BUILD_DIR)/parser.tab.c
PARSER_H = $(BUILD_DIR)/parser.tab.h
LEXER_C = $(BUILD_DIR)/lex.yy.c

# Object files
OBJS = $(BUILD_DIR)/parser.tab.o $(BUILD_DIR)/lex.yy.o $(BUILD_DIR)/symtable.o $(BUILD_DIR)/main.o

all: prep_dirs $(BIN_DIR)/$(TARGET)

prep_dirs:
	@mkdir -p $(BUILD_DIR) $(BIN_DIR)

# Rule to generate C file from Bison grammar
$(PARSER_C) $(PARSER_H): $(PARSER_Y)
	$(YACC) $(YFLAGS) -o $(PARSER_C) $<

# Rule to generate C file from Flex definition
$(LEXER_C): $(LEXER_L) $(PARSER_H)
	$(LEX) -o $@ $<

# Rule to compile the calculator program
$(BIN_DIR)/$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -I. -o $@ $^ $(LDLIBS)

# Compile each source file to object file
$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -I. -c $< -o $@
$(BUILD_DIR)/parser.tab.o: $(PARSER_C)
	$(CC) $(CFLAGS) -I. -c $< -o $@
$(BUILD_DIR)/lex.yy.o: $(LEXER_C)
	$(CC) $(CFLAGS) -I. -c $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

# Run the calculator
run: $(BIN_DIR)/$(TARGET)
	./$(BIN_DIR)/$(TARGET)

# Show object dependencies
depend:
	@echo "Dependencies:"
	@echo "$(PARSER_C): $(PARSER_Y)"
	@echo "$(LEXER_C): $(LEXER_L) $(PARSER_H)"
	@echo "$(OBJS): calc.h symtable.h $(PARSER_H)"

.PHONY: all clean run depend