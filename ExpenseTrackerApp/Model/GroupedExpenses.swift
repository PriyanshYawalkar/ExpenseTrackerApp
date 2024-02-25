//
//  GroupedExpenses.swift
//  ExpenseTrackerApp
//
//  Created by Priyansh yawalkar on 25/02/24.
//

import SwiftUI

struct GroupedExpenses: Identifiable {
    var id: UUID = .init()
    var date: Date
    var expenses: [Expense]
    
    /// Group Title
    var groupTitle: String {
        let calender = Calendar.current
        
        if calender.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInToday(date) {
            return "Yesterday"
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
