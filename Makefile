#Makefile For Project 1
# ck381121@ohio.edu

#Flags
CXX = g++
FLEX = flex
CFLAGS = -Wall -Wextra -Werror 

# Source files
LEXER_SRC = lex.yy.cc
CMOS_SRC = cmos.cpp

# Executable names
LEXER = lexer
CMOS = cmos

# L
$(LEXER_SRC): cmos.l
	$(FLEX) $<

# Build rule for lexer
$(LEXER): $(LEXER_SRC)
	$(CC) $(CFLAGS) -o $@ $<

# Rule to run PlagiarismDetector.sh
run_plagiarism_detector: $(LEXER_EXE)
	./PlagarismDetector.sh examples

# Build rule for CMOS
$(CMOS): $(CMOS_SRC)
	$(CC) $(CFLAGS) -o $@ $<

# Target to build lexer and run plagiarism detector
all: $(LEXER) run_plagiarism_detector $(CMOS)

# Clean rule
clean:
	rm -f $(LEXER_SRC) $(LEXER) $(CMOS)