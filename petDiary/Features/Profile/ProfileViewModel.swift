import Foundation
import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    
    private let getReminders: GetRemindersUseCaseProtocol
    private let getUser: GetProfileUseCaseProtocol
    private let saveUser: SaveProfileUseCaseProtocol
    private let deleteUser: RemoveProfileUseCaseProtocol
    private let updateProfile: UpdateProfileUseCaseProtocol
    
    init(getReminders: GetRemindersUseCaseProtocol,
         getUser: GetProfileUseCaseProtocol,
         saveUser: SaveProfileUseCaseProtocol,
         deleteUser: RemoveProfileUseCaseProtocol,
         updateProfile: UpdateProfileUseCaseProtocol,
         notificationsEnabled: Bool) {
        self.getReminders = getReminders
        self.getUser = getUser
        self.saveUser = saveUser
        self.deleteUser = deleteUser
        self.updateProfile = updateProfile
        self.notificationsEnabled = notificationsEnabled
    }
    @Published var notificationsEnabled: Bool = NotificationService.notificationsEnabled
    @Published var autoConvertReminders: Bool = false

    
    func toggleNotifications() async throws {
        if notificationsEnabled {
            try await NotificationService.scheduleAllNotifications(reminders: getReminders.execute())
        } else {
            NotificationService.cancelNotification()
        }
    }
    
     func getUserData() throws -> Profile {
        try self.getUser.execute()
    }
    
    func saveUserData(_ user: Profile) throws {
        self.saveUser.execute(user)
    }
    
    func deleteUserData(_ user: Profile)  throws {
        self.deleteUser.execute(user)
    }
    
    func updateUserData(_ user: Profile, _ newUser: Profile) throws {
        self.updateProfile.execute(user,newUser)
    }
    


    func loadProfile() {
        let profile = getOrCreateProfile()
        self.autoConvertReminders = profile.autoConvertReminders
    }

    func updateAutoConvert(_ value: Bool) {
        let profile = getOrCreateProfile()
        profile.autoConvertReminders = value
    }

    private func getOrCreateProfile() -> Profile {
        if let profile = try? getUser.execute() {
            return profile
        }
        let profile = Profile(id: UUID(), autoConvertReminders: false)
        saveUser.execute(profile)
        return profile
    }
}

