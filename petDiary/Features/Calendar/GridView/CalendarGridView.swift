import Foundation
import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private var weekHeader: some View {
        LazyVGrid(columns: columns) {
            ForEach (CalendarHelper.weekdaySymbol, id: \.self) { symbol in
                Text(symbol)
                    .font(Font.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func selectDay (_ date: Date){
        if let selectedDate = viewModel.selectedDate,
           CalendarHelper.isSameDay(selectedDate,date) {
            viewModel.selectedDate = nil
        }
        else {
            viewModel.selectedDate = date
        }
    }
    
    var body: some View {
        VStack (spacing: 8) {
            weekHeader
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach (Array(viewModel.daysInCurrentMouth.enumerated()),id: \.offset) { _ , date in
                    if let date = date {
                        DayCell(date: date,
                                isSelected: viewModel.selectedDate.map{CalendarHelper.isSameDay($0, date)} ?? false,
                                isToday: CalendarHelper.isToday(date),
                                hasEvent: viewModel.hasEvents(for: date),
                                hasReminder: viewModel.hasReminders(for: date)
                        ).onTapGesture {
                            selectDay(date)
                        }
                    }else {
                        Color.clear.frame(height: 44)
                    }
                    
                }
            }.id(viewModel.currentDate)
        }
    }
}
