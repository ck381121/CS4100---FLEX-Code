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



# Target to build lexer and run plagiarism detector
all: 
	$(FLEX) cmos.l
	$(CXX) -o $(LEXER) $(LEXER_SRC)
	./PlagarismDetector.sh Examples

	$(CXX) $(CMOS_SRC)
	./a.out 

# Clean rule
clean:
	rm -f $(LEXER_SRC) $(LEXER) $(CMOS) $(PLAG) $(TOKEN) a.out 