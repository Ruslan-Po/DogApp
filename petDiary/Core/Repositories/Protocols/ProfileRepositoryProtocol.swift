import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() throws -> Profile
    func saveProfile(_ profile: Profile)
    func deleteProfile(_ profile: Profile)
    func updateProfile(_ profile: Profile, newProfile: Profile)
    
}
