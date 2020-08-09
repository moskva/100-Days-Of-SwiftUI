//
//  ContentView.swift
//  WeSplit
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var people = 2
    @State private var tip = 2
    
    let tipPercent = [10, 15, 20, 25, 0]
    
    var totalPerPeople: Double {
        let peopleCount = Double(people + 2)
        let tipSelection = Double(tipPercent[tip])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandAmount = orderAmount + tipValue
        let amountPerPeople = grandAmount / peopleCount
        
        return amountPerPeople
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Bill Amount", text: $checkAmount)
                    .keyboardType(.decimalPad)
                        
                    
                    Picker("How many of us", selection: $people) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("The tip we would like to leave")) {
                    Picker("Tip percentage", selection: $tip) {
                        ForEach(0 ..< tipPercent.count) {
                            Text("\(self.tipPercent[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Per person should pay")) {
                    Text("$\(totalPerPeople, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("Day 17 - We Split")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
