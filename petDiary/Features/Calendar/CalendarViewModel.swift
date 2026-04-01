import Foundation
import Combine
import SwiftUI

final class CalendarViewModel: ObservableObject {
    private let getEvents: GetEventsUseCaseProtocol
    private let getReminders: GetRemindersUseCaseProtocol
    private let removeReminder: RemoveReminderUseCaseProtocol
    private let removeEvent: RemoveEventUseCaseProtocol
    
    init(getEvents: GetEventsUseCaseProtocol,
         getReminders: GetRemindersUseCaseProtocol,
         removeReminders: RemoveReminderUseCaseProtocol,
        removeEvent: RemoveEventUseCaseProtocol) {
        self.getEvents = getEvents
        self.getReminders = getReminders
        self.removeEvent = removeEvent
        self.removeReminder = removeReminders
    }
    
    @Published var events: [Event] = []
    @Published var reminders: [Reminder] = []
    @Published var currentDate: Date = Date()
    @Published var selectedDate: Date? = nil
    @Published var navigationDirection : NavigationDirection = .forward
    
    
    var daysInCurrentMouth: [Date?] {
        CalendarHelper.daysInMonth(for: currentDate)
    }
    
    var monthName: String {
        CalendarHelper.monthString(for: currentDate)
    }
    
    
    func events(for date: Date) -> [Event] {
        events.filter {CalendarHelper.isSameDay ($0.date, date)}
    }
    
    func reminders(for date: Date) -> [Reminder] {
        reminders.filter {CalendarHelper.isSameDay ($0.scheduleDate, date)}
    }
    
    func hasEvents(for date: Date) -> Bool {
        events.contains(where: {CalendarHelper.isSameDay ($0.date, date)})
    }
    
    func hasReminders(for date: Date) -> Bool {
        reminders.contains(where: {CalendarHelper.isSameDay ($0.scheduleDate, date)})
    }
    
    func loadData() {
        do {
            events = try getEvents.execute()
            reminders = try getReminders.execute()
        } catch {
            print ("Loading data error")
        }
    }
    
    func removeEvent(_ event: Event) {
        removeEvent.execute(event)
        events.removeAll(where: { $0.id == event.id })
    }
    
    func removeReminder(_ reminder: Reminder) {
        guard reminder.pet != nil else { return }
        removeReminder.execute(reminder, from: reminders)
        withAnimation {
            if let seriesId = reminder.seriesId {
                reminders = reminders.filter {
                    !($0.seriesId == seriesId && $0.scheduleDate >= reminder.scheduleDate)
                }
            } else {
                reminders = reminders.filter { $0.id != reminder.id }
            }
        }
    }
    
    
    func goToNextMonth() {
        navigationDirection = .forward
        currentDate = CalendarHelper.nextMonth(from: currentDate)
        selectedDate = nil // Сбрасываем выбор при смене месяца
    }
    
    func goToPreviousMonth() {
        navigationDirection = .backward
        currentDate = CalendarHelper.previousMonth(from: currentDate)
        selectedDate = nil
    }
}


