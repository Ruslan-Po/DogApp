import Foundation
import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    
    private let getReminders: GetRemindersUseCaseProtocol
    
    init (getReminders: GetRemindersUseCaseProtocol) {
        self.getReminders = getReminders
    }
    
    @Published var notificationsEnabled: Bool = NotificationService.notificationsEnabled

    
    func toggleNotifications() async throws {
        if notificationsEnabled {
            try await NotificationService.scheduleAllNotifications(reminders: getReminders.execute())
        } else {
            NotificationService.cancelNotification()
        }
    }
    
    
}
