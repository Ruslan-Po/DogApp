import Foundation

protocol SaveProfileUseCaseProtocol {
    func execute (_ profile: Profile)
}


final class SaveProfileUseCase: SaveProfileUseCaseProtocol {
    let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ profile: Profile) {
        repository.saveProfile(profile)
    }
}
