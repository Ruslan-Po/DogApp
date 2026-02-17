import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var pets: [Pet]
    
    var body: some View {
        if pets.isEmpty {
           AddPetView(isOnboarding: true)
        }else {
            Coordinator()
        }
    }
}
