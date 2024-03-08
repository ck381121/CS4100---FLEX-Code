#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <unordered_map>
#include <string>
#include <cmath>

using namespace std;

// Fingerprint struct
struct Fingerprint {
  string hashValue;
  int position;
};

// Function to generate fingerprints from tokenized submissions
vector<Fingerprint> generateFingerprints(const string& submission) {
  vector<Fingerprint> fingerprints;
  // Define your sliding window size
  int windowSize = 5;
  // Hash function 
  auto hashFunction = [](const string& str) {
    int hash = 0;
    for (char c : str) {
      hash = (hash * 31 + c) % 1000000007; // Adjust modulus as needed
    }
    return to_string(hash);
    };

  for (int i = 0; i <= submission.length() - windowSize; ++i) {
    string window = submission.substr(i, windowSize);
    string hashValue = hashFunction(window);
    fingerprints.push_back({ hashValue, i });
  }
  return fingerprints;
}

// Function to compare fingerprints and detect similarities
double detectSimilarities(const vector<Fingerprint>& fingerprints1, const vector<Fingerprint>& fingerprints2, ofstream& outputFile) {
  // Define your similarity threshold
  double similarityThreshold = 0.8;
  // Calculate the number of matching fingerprints required for similarity
  int matchingThreshold = ceil(similarityThreshold * min(fingerprints1.size(), fingerprints2.size()));

  unordered_map<string, int> fingerprintCounts;

  // Count the occurrences of each fingerprint in the first set
  for (const auto& fingerprint : fingerprints1) {
    fingerprintCounts[fingerprint.hashValue]++;
  }

  int matchingFingerprints = 0;

  // Check for matching fingerprints in the second set
  for (const auto& fingerprint : fingerprints2) {
    if (fingerprintCounts[fingerprint.hashValue] > 0) {
      matchingFingerprints++;
    }
  }

  // Calculate similarity score
  double similarityScore = (double)matchingFingerprints / min(fingerprints1.size(), fingerprints2.size());

  // Output similarity result to file
  if (matchingFingerprints >= matchingThreshold) {
    outputFile << "Similarity Found: " << similarityScore << endl;
  }
  else {
    outputFile << "No Similarity" << endl;
  }

  return similarityScore;
}

// Function to load tokenized file into vector of strings
vector<string> loadTokens(const string& filename) {
  ifstream file(filename);
  vector<string> submissions;
  if (file.is_open()) {
    string line;
    while (getline(file, line)) {
      submissions.push_back(line);
    }
    file.close();
  }
  else {
    cout << "Unable to open file: " << filename << endl;
  }
  return submissions;
}

int main() {
  // Load tokenized submissions
  vector<string> submissions = loadTokens("token.txt");

  // Concatenate the lines of each submission into a single string
  vector<string> concatenatedSubmissions;
  for (const auto& submission : submissions) {
    concatenatedSubmissions.push_back(submission);
  }

  // Generate fingerprints for each submission
  vector<vector<Fingerprint>> fingerprints;
  for (const auto& submission : concatenatedSubmissions) {
    fingerprints.push_back(generateFingerprints(submission));
  }

  // Open output file for writing
  ofstream outputFile("PlagiarismReport.txt");
  if (!outputFile.is_open()) {
    cerr << "Error: Unable to open output file." << endl;
    return 1;
  }
  
  double highestSimilarity = 0.0;
  pair<int, int> highestPair;
  double secondHighestSimilarity = 0.0;
  pair<int, int> secondHighestPair;

  // Compare fingerprints between submissions and write similarities to file
  for (size_t i = 0; i < fingerprints.size(); ++i) {
    for (size_t j = i + 1; j < fingerprints.size(); ++j) {
      outputFile << "Comparing submission " << i + 1 << " and submission " << j + 1 << ":\n";
      double similarity = detectSimilarities(fingerprints[i], fingerprints[j], outputFile);
      if (similarity > highestSimilarity) {
        secondHighestSimilarity = highestSimilarity;
        secondHighestPair = highestPair;
        highestSimilarity = similarity;
        highestPair = { i + 1, j + 1 };
      } else if (similarity > secondHighestSimilarity) {
        secondHighestSimilarity = similarity;
        secondHighestPair = { i + 1, j + 1 };
      }
    }
  }

  // Output the top two most similar scores and the corresponding submission pairs
  outputFile << "\nTop two most similar scores:\n";
  outputFile << "1. Submissions " << highestPair.first << " and " << highestPair.second << ": " << highestSimilarity << "\n";
  outputFile << "2. Submissions " << secondHighestPair.first << " and " << secondHighestPair.second << ": " << secondHighestSimilarity << "\n";


  // Close output file
  outputFile.close();

  return 0;
}