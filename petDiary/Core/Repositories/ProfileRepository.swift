import Foundation


final class ProfileRepository: ProfileRepositoryProtocol {
    let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func getProfile() throws -> Profile {
        let profiles = try dataManager.getProfile()
        if let profile = profiles.first {
            return profile
        }
        throw DataManagerError.profileNotFound
    }
    
    func saveProfile(_ profile: Profile)  {
        dataManager.saveProfile(profile)
    }
    
    func deleteProfile(_ profile: Profile) {
        dataManager.deleteProfile(profile)
    }
    
    func updateProfile(_ profile: Profile, newProfile: Profile) {
        dataManager.updateProfile(profile,newProfile)
    }
}
