import Foundation

protocol RemoveProfileUseCaseProtocol {
    func execute(_ profile: Profile)
}


final class RemoveProfileUseCase: RemoveProfileUseCaseProtocol {
    let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ profile: Profile) {
        repository.deleteProfile(profile)
    }
}
