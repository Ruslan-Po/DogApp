import Foundation

enum CalendarHelper {
    
    private static var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }
    
    static func daysInMonth(for date: Date) -> [Date?] {
        
        guard let firstDayInMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
            else { return []}
        
        guard let rage = calendar.range(of: .day, in: .month, for: date)
            else { return []}
        
        let numberOfDays = rage.count
        
        let weekDayOfFirst = calendar.component(.month, from: firstDayInMonth)
        let offsetFromMonday = (weekDayOfFirst - 2 + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: offsetFromMonday)
        
        for dayIndex in 0..<numberOfDays {
            if let day = calendar.date(byAdding: .day, value: dayIndex , to: firstDayInMonth) {
                days.append(day)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }

    static func nextMonth(from date: Date) -> Date {
        calendar.date(byAdding: .month, value: 1, to: date) ?? date
    }
    

    static func previousMonth(from date: Date) -> Date {
        calendar.date(byAdding: .month, value: -1, to: date) ?? date
    }
    
    static func monthString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
    
    static var weekdaySymbol:[String] {
        var symbols = calendar.shortWeekdaySymbols
        let sunday = symbols.removeFirst()
        symbols.append(sunday)
        return symbols.map {$0.uppercased()}
    }
 
    
    static func isToday(_ date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

