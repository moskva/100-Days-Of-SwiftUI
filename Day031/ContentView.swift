//
//  ContentView.swift
//  WordScramble
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var scores = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Please enter the word", text: $newWord, onCommit: addWords)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text("\($0)")
                }
                
            VStack(spacing: 20) {
                Text("Your Scores")
                    .font(.title)
                Text("\(scores)")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
            }
            .padding(.top,20)
            .padding(.bottom, 50)
                
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(trailing:
                HStack {
                    Image(systemName: "play.circle")
                    Button("Start New Game") {
                    self.startGame()
                    }
                }.foregroundColor(.purple))
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func startGame() {
        usedWords = []
        scores = 0
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                let allWords = startWords.components(separatedBy: "\n")
                    rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Couldn't load the files")
        
    }
    
    func addWords() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Oops!", message: "You can't use the same word twice.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Oops!", message: "You are creative, but not this time.")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Oops!", message: "Think about it again!")
            return
        }
        
        scores += 1
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if word.count < 3 {
            return false
        } else if word == rootWord {
            return false
        } else {
            return misspelledRange.location == NSNotFound
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
