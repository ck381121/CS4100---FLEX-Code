#!/bin/bash

rm token.txt

# Ensure a directory name is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 examples"
    exit 1
fi

# Define the directory containing the files to tokenize
FILES="./$1/*"
TOKENS_FILE="token.txt"

# Loop through each file in the directory
for f in $FILES; do
    # Write filename to tokens.txt
    echo -n "$(basename $f):" >> "$TOKENS_FILE"
    
    # Perform lexical analysis using the scanner and append output to tokens.txt
    ./lexer < "$f" >> "$TOKENS_FILE"
    
done

echo "Tokenization completed. Results stored in $TOKENS_FILE."