#include <iostream>
#include <fstream>
#include <vector>
#include <deque>
#include <algorithm>
#include "lex.yy.c" // Include the generated Lex file

using namespace std; 

/*
Guarantee threshold and Noise Threshold
n_threshold <= g_threshold

*/
int g_threshold = 0; //guarantee threshold 
int n_threshold = 0; //noise threshold

const int k = 5; // size of k-gram (substring size)
const int w = 4; // window size

// Function to compute a hash value for a given string
unsigned long hashFunction(string str) {
    unsigned long hash = 5381;
    for (char c : str) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}

// Function to perform the Winnowing Algorithm
vector<unsigned long> winnowingAlgorithm(string text) {
    vector<unsigned long> fingerprints;

    // Compute the hash values for all k-grams
    vector<unsigned long> hashes;
    for (int i = 0; i <= text.size() - k; i++) {
        hashes.push_back(hashFunction(text.substr(i, k)));
    }

    // Apply the Winnowing Algorithm
    deque<pair<unsigned long, int>> window;
    for (int i = 0; i < hashes.size(); i++) {
        // Remove hashes outside the current window
        while (!window.empty() && window.front().second <= i - w) {
            window.pop_front();
        }

        // Remove hashes from the window that are greater than the current hash
        while (!window.empty() && window.back().first >= hashes[i]) {
            window.pop_back();
        }

        // Add the current hash to the window
        window.push_back({hashes[i], i});

        // If the current hash is the minimum hash in the window, add it to the fingerprints
        if (window.front().second == i - w + 1) {
            fingerprints.push_back(window.front().first);
        }
    }

    return fingerprints;
}

int main() {

    // Tokenize the input file
    yylex();
    // Read the file
    ifstream file("token.txt");
    string text((istreambuf_iterator<char>(file)), istreambuf_iterator<char>());

    // Perform the Winnowing Algorithm
    vector<unsigned long> fingerprints = winnowingAlgorithm(text);

    // Print the fingerprints
    for (unsigned long fingerprint : fingerprints) {
        cout << fingerprint << endl;
    }

    return 0;

}



