//
//  CategoriesView.swift
//  ExpenseTrackerApp
//
//  Created by Priyansh yawalkar on 25/02/24.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context
    
    /// View Properties
    @State private var addCategory :Bool = false
    @State private var categoryName: String = ""
    /// Category Delete Request
    @State private var deleteRequest: Bool = false
    @State private var requestCategory: Category?
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCategories.sorted(by:
                    ($0.expenses?.count ?? 0) > ($0.expenses?.count ?? 0)
                )) { category in
                    DisclosureGroup {
                        if let expenses = category.expenses, !expenses.isEmpty {
                            ForEach(expenses) { expense in
                                ExpenseCardView(expanse: expense, displayTag: false)
                                
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No Expenses", systemImage: "tray.fill")
                            }
                        }
                    } label: {
                        Text(category.categoryName)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            deleteRequest.toggle()
                            requestCategory = category
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                    
                }
            }
            .navigationTitle("Categories")
            .overlay {
                if allCategories.isEmpty {
                    ContentUnavailableView {
                        Label("No Categories", systemImage: "tray.fill")
                    }
                }
            }
            
            /// New Category Add Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addCategory.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $addCategory) {
                categoryName = ""
            } content: {
                NavigationStack {
                    List {
                        Section("Title") {
                            TextField("General", text: $categoryName)
                        }
                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    /// Add & Cancle button
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                /// Adding new
                                let category = Category(categoryName: categoryName)
                                context.insert(category)
                                /// closing View
                                categoryName = ""
                                addCategory = false
                            }
                            .disabled(categoryName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            }
        }
        .alert("if you delete a category, all the associated expenses will be deleted too.", isPresented: $deleteRequest) {
            Button(role: .destructive) {
                /// Deleting Category
                if let requestCategory {
                    context.delete(requestCategory)
                    self.requestCategory = nil
                }
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                requestedCategory = nil
            } label: {
                Text("Cancel")
            }
        }
    }
}

#Preview {
    CategoriesView()
}
