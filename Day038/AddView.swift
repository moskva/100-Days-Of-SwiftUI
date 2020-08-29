//
//  AddView.swift
//  Project 7: iExpense - Challenge
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    
    static var types = ["Business", "Personal"]
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Type")) {
                    Picker("Type", selection: $type) {
                        ForEach(Self.types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Expense Details")) {
                    TextField("Description", text: $name)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("Add new expense", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                self.showingAlert = true
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("⚠️ Can't Be Saved"), message: Text("Amount must be an integer."), dismissButton: .default(Text("Got it")))
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
