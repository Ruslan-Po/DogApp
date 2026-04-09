import Foundation
import SwiftUI

struct DayDetailView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let date: Date
    
    private var dayEvents: [Event] {
        viewModel.events(for: date)
    }
    
    private var dayReminders: [Reminder] {
        viewModel.reminders(for: date)
    }
    
    private var hasContent: Bool {
        !dayEvents.isEmpty || !dayReminders.isEmpty
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, EEEE"
        return formatter.string(from: date).capitalized
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            
            if hasContent {
                ScrollView {
                    VStack(spacing: 8) {
                        if !dayReminders.isEmpty {
                            sectionLabel("home.reminders".localized)
                            ForEach(dayReminders, id: \.id) { reminder in
                                ReminderRow(reminder: reminder) {
                                    viewModel.removeReminder(reminder)
                                }
                            }
                        }
                        
                        if !dayEvents.isEmpty {
                            sectionLabel("home.events".localized)
                            ForEach(dayEvents, id: \.id) { event in
                                EventRow(event: event) {
                                    viewModel.removeEvent(event)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            } else {
                emptyState
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text(formattedDate)
                .font(.headline)
                .foregroundColor(.textPrimary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 32))
                .foregroundColor(.textSecondary)
            Text("calendar.noEvents".localized)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 24)
    }
    
    private func sectionLabel(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
    
    // MARK: - ReminderRow
    
    private struct ReminderRow: View {
        let reminder: Reminder
        let onDelete: () -> Void
        
        var body: some View {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.petzenYellow)
                    .frame(width: 3)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(reminder.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                    Text(timeString(from: reminder.scheduleDate))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(reminder.category.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(12)
            .background(Color.brandBackgroundLight)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.brandBackground, lineWidth: 2)
            )
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("common.remove".localized, systemImage: "trash")
                }
            }
        }
        
        private func timeString(from date: Date) -> String {
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
            return f.string(from: date)
        }
    }
    
    // MARK: - EventRow
    
    private struct EventRow: View {
        let event: Event
        let onDelete: () -> Void
        
        var body: some View {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.brandInfo)
                    .frame(width: 3)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                    Text(timeString(from: event.date))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(event.category.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(12)
            .background(Color.brandBackgroundLight)
            //.cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.brandBackground, lineWidth: 2)
            )
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("common.remove".localized, systemImage: "trash")
                }
            }
        }
        
        private func timeString(from date: Date) -> String {
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
            return f.string(from: date)
        }
    }
}
