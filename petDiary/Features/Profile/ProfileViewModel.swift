import Foundation
import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {

    private let getReminders: GetRemindersUseCaseProtocol
    private let getUser: GetProfileUseCaseProtocol
    private let saveUser: SaveProfileUseCaseProtocol
    private let deleteUser: RemoveProfileUseCaseProtocol
    private let updateProfile: UpdateProfileUseCaseProtocol

    @Published var name: String = ""
    @Published var telephone: String = ""
    @Published var address: String = ""
    @Published var notificationsEnabled: Bool = NotificationService.notificationsEnabled
    @Published var autoConvertReminders: Bool = false

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

    func toggleNotifications() async throws {
        if notificationsEnabled {
            try await NotificationService.scheduleAllNotifications(reminders: getReminders.execute())
        } else {
            NotificationService.cancelNotification()
        }
    }

    func loadProfile() {
        let profile = getOrCreateProfile()
        self.name = profile.name ?? ""
        self.telephone = profile.telephone ?? ""
        self.address = profile.address ?? ""
        self.autoConvertReminders = profile.autoConvertReminders
    }

    func saveField() {
        let profile = getOrCreateProfile()
        profile.name = name.isEmpty ? nil : name
        profile.telephone = telephone.isEmpty ? nil : telephone
        profile.address = address.isEmpty ? nil : address
    }

    func updateAutoConvert(_ value: Bool) {
        let profile = getOrCreateProfile()
        profile.autoConvertReminders = value
    }

    func getOrCreateProfile() -> Profile {
        if let profile = try? getUser.execute() {
            return profile
        }
        let profile = Profile(id: UUID(), autoConvertReminders: false)
        saveUser.execute(profile)
        return profile
    }
}
