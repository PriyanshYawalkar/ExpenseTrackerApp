//
//  ContentView.swift
//  ExpenseTrackerApp
//
//  Created by Priyansh yawalkar on 25/02/24.
//

import SwiftUI

struct ContentView: View {
    ///view properties
    @State private var currentTab: String = "Expenses"
    var body: some View {
        TabView(selection: $currentTab) {
            ExpensesView(currentTab: $currentTab)
                .tag("Expenses")
                .tabItem{
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            
            CategoriesView()
                .tag("Categories")
                .tabItem{
                    Image(systemName: "list.clipboard.fill")
                    Text("Categories")
                }
        }
    }
}

#Preview {
    ContentView()
}
