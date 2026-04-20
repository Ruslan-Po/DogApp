import Foundation
import UserNotifications

struct NotificationService {
     static var notificationsEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "notificationsEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
        }
    }
    
    static func requestNotification() async throws {
        let granted = try await UNUserNotificationCenter.current().requestAuthorization( options: [.alert, .sound, .badge])
        if granted {
            print("Notification allowed")
        }
        else {
            print("Notification denied")
        }
    }
    
    static func scheduleNotification(reminder: Reminder) async throws {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.sound = .default

        let petName = reminder.pet?.name ?? ""
        let bodyTemplate = NSLocalizedString("reminder.notification.body", comment: "")
        content.body = String(format: bodyTemplate, petName)

        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.scheduleDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
    
    static func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        notificationsEnabled = false
    }
    
    static func scheduleAllNotifications(reminders: [Reminder]) async throws {
        cancelNotification()
        for reminder in reminders {
            try await scheduleNotification(reminder: reminder)
        }
        notificationsEnabled = true
    }
}

