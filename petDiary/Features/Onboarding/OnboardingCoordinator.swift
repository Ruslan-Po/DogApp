import SwiftUI
import SwiftData
 
struct OnboardingCoordinator: View {
    @Query private var pets: [Pet]
 
    var body: some View {
        if pets.isEmpty {
            
            AddPetViewBuilder.build(onSave: { _ in })
        } else {
            Coordinator()
        }
    }
}
 
