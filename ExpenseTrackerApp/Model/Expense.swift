//
//  Expense.swift
//  ExpenseTrackerApp
//
//  Created by Priyansh yawalkar on 25/02/24.
//

import SwiftUI
import SwiftData

@Model
class Expense {
    /// Expense properties
    var title: String
    var SubTitle: String
    var amount: Double
    var date: Date
    /// Expense Category
    var category: Category?
    
    init(title: String, SubTitle: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.SubTitle = SubTitle
        self.amount = amount
        self.date = date
        self.category = category
    }
    
    /// Currency String
    
    @Transient
    var currencyString: String {
        let formatter = NumberFormatter()
        
        return formatter.string(for: amount) ?? ""
    }
}
