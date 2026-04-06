import Foundation
import SwiftData

struct ProfileBuilder {
    static func build() -> ProfileView {
        let viewModel = buildViewModel()
        return ProfileView(viewModel: viewModel)
    }

    static func buildViewModel() -> ProfileViewModel {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = ReminderRepository(dataManager: dataManager)
        let getRemindersUseCase = GetRemindersUseCase(repository: repository)
        let profileRepository = ProfileRepository(dataManager: dataManager)
        let getProfileUseCase = GetProfileUseCase(repository: profileRepository)
        let saveProfileUseCase = SaveProfileUseCase(repository: profileRepository)
        let removeProfileUseCase = RemoveProfileUseCase(repository: profileRepository)
        let updateProfileUseCase = UpdateProfileUseCase(repository: profileRepository)

        return ProfileViewModel(getReminders: getRemindersUseCase,
                                getUser: getProfileUseCase,
                                saveUser: saveProfileUseCase,
                                deleteUser: removeProfileUseCase,
                                updateProfile: updateProfileUseCase,
                                notificationsEnabled: false)
    }
}
