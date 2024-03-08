%{
//*****************************************************************************************
// File: cmos.l
// Purpose: Tokenize one student code submission
// build instructions
// flex cmos.l
// make
// g++ -o lexer lex.yy.c
// ./PlagarismDetector examples
// ****************************************************************************************
#include <iostream>
#include <fstream>
#include <string>
using namespace std;    

#define VARIABLE 1
#define FUNCTION 2
#define OPERATOR 3
#define BASIC 4
#define EXTRA 5
#define IGNORE 6

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

"if"		{return BASIC;}
"else"		{return BASIC;}
"while"		{return BASIC;}
"for"		{return BASIC;}
"return"	{return BASIC;}
";"			{return BASIC;}
","			{return BASIC;}
"("			{return BASIC;}
")"			{return BASIC;}
"{"			{return BASIC;}
"}"			{return BASIC;}

{VARIABLE}      { return VARIABLE; }
{FUNCTION}      { return FUNCTION; }
{OPERATOR}      { return OPERATOR; }
{IGNORE}        { /* Ignore everything else */ }

%%

int yywrap(){
    return true;
}

int main() {
    int token = 0;
    token = yylex();
	ofstream outputFile("tokens.txt", ios::app);
    while(token){
        switch (token) {
            case OPERATOR:
                outputFile << yytext << " ";
                break;
            case FUNCTION:
                outputFile << "Function:" << function_count << " ";
                function_count++;
                break;
            case VARIABLE:
                outputFile << "<Variable:" << variable_count << " ";
                variable_count++;
                break;
            case BASIC:
                outputFile << yytext << " ";
                break;

        }   
        token = yylex();
    }
    outputFile << "\n"; // Insert newline character
	outputFile.close();
    return 0;
}