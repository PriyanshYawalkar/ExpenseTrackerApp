
import SwiftUI
import SwiftData


struct AddExpenseView: View {
    @Environment(.\dismiss) private var dismiss
    @Environment(.\modelContext) private var context
    
    /// view properties
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date Date = .init()
    @State private var var amount: CGFloat = 0\
    @State private var category: Category?
    @Query(animmation: .snappy) private var allCategories: [Category]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Magic Keyboard", text: $title)
                }
                
                Section("Description") {
                    TextField("Bought a keyboard at the apple store", text: $subTitle)
                }
                
                Section("Amount Spent") {
                    HStack(spacing: 4) {
                        Text("$")
                            .fontWeight(.semibold)
                        TextField("0.0", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                /// Category Picker
                if !allCategories.isEmpty {
                    HStack {
                        Text("Category")
                        
                        Spacer()
                        
                        Picker("" ,selection: $category) {
                            ForEach(allCategories) {
                                Text($0.categoryName) {
                                    .tag($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                        }
                    }
                }
                
                
            }
            .navigationTitle("Add Expenses")
            .toolbar {
                /// Cancle and Add button
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancle") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", action: addExpense)
                        .disabled(isAddButtonDisable)
                }
                
            }
        }
    }
    
    /// Disabling add button until all data is entered
    
    var isAddButtonDisable: Bool {
        return title.isEmpty || subTitle.isEmpty || amount == .zero
    }
    
    /// Adding expense to the swift Data
    func addExpense() {
        let expense = Expense(title: title, SubTitle: subTitle, amount: amount, date: date, category: category)
        context.insert(expense)
        /// Closing view, once the Data has been added
        
        dismiss()
    }
    
    /// Decimal formatter
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    AddExpenseView()
}
