import Foundation
import SwiftData


struct ProfileBuilder {
    static  func build() -> ProfileView {
        let context = ModelContainer.appContainer.mainContext
        let dataManager = DataManager(context: context)
        let repository = ReminderRepository(dataManager: dataManager)
        let getRemindersUseCase = GetRemindersUseCase(repository: repository)
        let UserRepository = ProfileRepository(dataManager: dataManager)
        let getProfileUseCase = GetProfileUseCase(repository: UserRepository)
        let saveProfileUseCase = SaveProfileUseCase(repository: UserRepository)
        let removeProfileUseCase = RemoveProfileUseCase(repository: UserRepository)
        let updateProfileUseCase = UpdateProfileUseCase(repository: UserRepository)
        
        let viewModel = ProfileViewModel(getReminders: getRemindersUseCase,
                                         getUser: getProfileUseCase,
                                         saveUser: saveProfileUseCase,
                                         deleteUser: removeProfileUseCase,
                                         updateProfile: updateProfileUseCase,
                                         notificationsEnabled: false)
    
        let view = ProfileView(viewModel: viewModel)
        return view
    }
}

