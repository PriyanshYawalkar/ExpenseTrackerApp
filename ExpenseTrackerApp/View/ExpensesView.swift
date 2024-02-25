//
//  ExpensesView.swift
//  ExpenseTrackerApp
//
//  Created by Priyansh yawalkar on 25/02/24.
//

import SwiftUI
import SwiftData

struct ExpensesView: view {
    /// Grouped Expenses Properties
    @Query(sort: [
        SortDescriptor(\Expenses.data, order: .reverse)
    ], animation: .snappy) private var allExpenses: [Expenses]
    @Environment(\.modelContext) private var context
    /// Grouped Expenses
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var addExpense: Bool = false
    var body: some view {
        NavigationStack {
            List {
                ForEach($groupedExpenses) { group in
                    Section(group.groupTitle) {
                        ForEach(group.expenses) { expense in
                            /// card view
                            ExpenseCardView(expanse: expense)
                                .swipeActions(edge: .trailing, allowsFullScreen: false) {
                                    /// Delete Button
                                    Button {
                                        context.delete(expense)
                                        withAnimation{
                                            group.expenses.removeAll(where: { $0.id == expense.id })
                                            /// Removing Group, if no expanse present
                                            if group.expenses.isEmpty {
                                                groupedExpenses.removeAll(where: { $0.id == group.id })
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)

                                }
                        }
                    }
                }
                
                
            }
            .navigationTitle("Expenses")
            .overlay {
                if allExpenses.isEmpty || groupedExpenses.isEmpty {
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            /// New category add button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addExpense.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .onChange(of: allExpenses, initial: true) { oldValue, newValue in
                if newValue.count > oldValue.count || groupedExpenses.isEmpty {
                    createGroupedExpenses(newValue)
                }
            }
        }
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
        }
    }
    /// Creating Grouped Expenses (Grouping by Data)
    func createGroupedExpenses(_ expenses: [Expense]) {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                let dataComponents = Calendar.current.dateComponents([.day, .month, .year], from:
                    expenses.date)
                
                return dataComponents
            }
            
            /// Sorting Dictinoary in Descending Order
            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            /// Adding to the grouped expenses array
            /// UI must be updated
            await MainActor.run {
                groupedExpenses = sortedDict.compactMap({ dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                    
                })
            }
        }
    }
}

#Preview {
    ExpensesView()
}
