//
//  ContentView.swift
//  GussTheFlag - Day 34 Challenge
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            .shadow(color: .white, radius: 5)
    }
}

extension View {
    func flagImage() -> some View {
        self.modifier(FlagImage())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    
    @State private var flagRotation = [0.0, 0.0, 0.0]
    @State private var flagOpacity = false
    
    @State private var gradienColor: [Color] = [.pink, .purple]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: gradienColor), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                    
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            self.flagTapped(number)
                            
                        }) {
                            Image(self.countries[number])
                                .renderingMode(.original)
                                .flagImage()
                        }
                        .rotation3DEffect(.degrees(self.flagRotation[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(self.flagOpacity ? (number == self.correctAnswer ? 1.0 : 0.5) : 1.0)
                    }
                    
                    Spacer()
                    HStack(spacing: 30) {
                        Text("Your Scores: ")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("\(score)")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    
                    Button(action: {
                        self.resetScore()
                    }) {
                        Text("Restart")
                    }
                    .frame(width: 150, height: 50)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        ).stroke(Color.white)
                    )
                    .padding(.bottom, 80)
                }
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                        self.askQuestion()
                    })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct 👏"
            scoreMessage = "Well done!"
            withAnimation {
                flagOpacity = true
                flagRotation[number] = 360.0
            }
        } else {
            score -= 1
            scoreTitle = "Wrong 🤷‍♂️ "
            scoreMessage = "That's flag of \(countries[number])"
            
            gradienColor = [.gray, .black]
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        flagRotation = [0.0, 0.0, 0.0]
        flagOpacity = false
        
        gradienColor = [.pink, .purple]
    }
    
    func resetScore() {
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
