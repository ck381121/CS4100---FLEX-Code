#Makefile For Project 1
# ck381121@ohio.edu

#Flags
CXX = g++
FLEX = flex
CFLAGS = -Wall -Wextra -Werror 

# Source files
LEXER_SRC = lex.yy.c
CMOS_SRC = cmos.cpp

#Output Files
PLAG = PlagiarismReport.txt
TOKEN = token.txt

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
all: 
	$(CXX) $(CMOS_SRC)
	./a.out 

# Clean rule
clean:
	rm -f $(LEXER_SRC) $(LEXER) $(CMOS) $(PLAG) $(TOKEN)