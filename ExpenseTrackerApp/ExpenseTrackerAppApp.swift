//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Priyansh yawalkar on 25/02/24.
//

import SwiftUI

@main
struct ExpenseTrackerAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        /// Setting up the container
        .modelContainer(for: [Expense.self, Category.self])
    }
}
