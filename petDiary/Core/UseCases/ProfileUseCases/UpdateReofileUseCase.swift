import Foundation

protocol UpdateProfileUseCaseProtocol {
    func execute(_ profile: Profile, _ newProfile: Profile)
}

final class UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ profile: Profile, _ newProfile: Profile) {
        repository.updateProfile(profile, newProfile: newProfile)
    }
}
