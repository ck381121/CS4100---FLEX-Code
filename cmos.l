%{
/*
 File: cmos.l
 Purpose: Tokenize example files in order to run cmos.cpp 

 Build instructions:
 flex cmos.l
 make
 g++ -o lexer lex.yy.c
 ./PlagarismDetector.sh examples
 make all 

 Results in PlagiarismReport.txt file 

 
*/



#include <iostream>
#include <fstream>
#include <string>
using namespace std;    

#define VARIABLE 1
#define FUNCTION 2
#define OPERATOR 3
#define CONDITIONS 4
#define IGNORE 5

#define TKUNMATCHED 255

int linecount = 1;
int variable_count = 1;
int function_count = 1;
%}

D [0-9]
L [a-zA-Z_]
ALL L|" "

TYPE int|float|long|char|double|bool|signed|unsigned|short

/* ignoring whitespace and comments */
WS          [ \t\n]+

COMMENT ^.*\/\/.*

MULTICOMMENT \/\*([^*]|\*+[^*/])*\*+\/


VARIABLE    {TYPE}[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*(\([^\)]*\))?[ \t]*(\[[0-9]+\])?[ \t]*(=[^;]+)?[ \t]*;

FUNCTION    [a-zA-Z_][a-zA-Z_0-9]*"("
OPERATOR   [-+=*/%><!&|^]=?|&&|\|\||[?~:;,\.];
IGNORE      . 

%%
{WS}            { /* Ignore whitespace */ }
{COMMENT}       { /* Ignore comments */ }
{MULTICOMMENT}  { /* Ignore multi line comment*/ }

"if"		{return CONDITIONS;}
"else"		{return CONDITIONS;}
"while"		{return CONDITIONS;}
"for"		{return CONDITIONS;}
"return"	{return CONDITIONS;}
";"			{return CONDITIONS;}
","			{return CONDITIONS;}
"("			{return CONDITIONS;}
")"			{return CONDITIONS;}
"{"			{return CONDITIONS;}
"}"			{return CONDITIONS;}

{VARIABLE}      { return VARIABLE; }
{FUNCTION}      { return FUNCTION; }
{OPERATOR}      { return OPERATOR; }
{IGNORE}        { /* Ignore everything else */ }

%%

int yywrap(){
    return true;
}

int main() {
   std::ofstream outputFile("token.txt", std::ios::app);

    int function_count = 0;
    int variable_count = 0;

    int token = yylex();
    while(token){
        switch (token) {
            case OPERATOR:
                outputFile << yytext << " ";
                break;
            case FUNCTION:
                outputFile << "Function:" << ++function_count << " ";
                break;
            case VARIABLE:
                outputFile << "<Variable:" << ++variable_count << " ";
                break;
            case CONDITIONS:
                outputFile << yytext << " ";
                break;
        }   
        token = yylex();
    }
    outputFile << "\n"; // Insert newline character
    outputFile.close();
    return 0;
}