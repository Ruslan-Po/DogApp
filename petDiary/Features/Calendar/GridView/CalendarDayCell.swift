import Foundation
import SwiftUI


struct DayCell: View {
    
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvent: Bool
    let hasReminder: Bool
    
    private let cellSize: CGFloat = 36
    private let indicationSize: CGFloat = 6
    
    private var dayNum: String {
        let calendar = Calendar.current
        return String(calendar.component(.day, from: date))
    }
    
    @ViewBuilder
    private var backgroundShape: some View {
        
        if isSelected {
            Circle().fill(.primary)
        } else if isToday {
            Circle().stroke(Color.brandPrimary, lineWidth: 1.5)
        } else {
            Color.clear
        }
    }

    private var textColor: Color {
        if isSelected {
            return .white
        } else if isToday {
            return .brandPrimary
        } else {
            return .primary
        }
    }
    
    @ViewBuilder
    private var indicatorRow: some View {
        HStack {
            if hasEvent {
                Circle().fill(Color.petzenTeal)
                    .frame(width: indicationSize, height: indicationSize)
            }
            if hasReminder {
                Circle().fill(Color.petzenYellow)
                    .frame(width: indicationSize, height: indicationSize)
            }
            if !hasEvent && !hasReminder {
                Circle().fill(Color.clear)
                    .frame(width: indicationSize, height: indicationSize)
            }
        }.frame(height: indicationSize)
    }
    
    
    var body: some View {
        VStack(spacing: 3) {
            Text(dayNum)
                .font(Font.caption.bold())
                .foregroundColor(textColor)
                .frame(width: cellSize, height: cellSize)
                .background(backgroundShape)
            indicatorRow
        }
    }
}
