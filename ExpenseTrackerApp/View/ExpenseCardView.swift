
import SwiftUI

struct ExpenseCardView: View {
    @Binding var expanse: Expense
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                
                Text(expense.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            ///Currency String
            
            Text(expense.currencyString)
                .font(.title3.bold())
        }
    }
}


