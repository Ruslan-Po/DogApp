import SwiftUI
import SwiftData

struct OnboardingCoordinator: View {
    @Query private var pets: [Pet]
    @Query private var profiles: [Profile]

    @State private var profileCreated = false

    var body: some View {
        if !profiles.isEmpty || profileCreated {
            if pets.isEmpty {
                AddPetViewBuilder.build(onSave: { _ in })
            } else {
                Coordinator()
            }
        } else {
            CreateProfileView(
                viewModel: ProfileBuilder.buildViewModel(),
                onComplete: { profileCreated = true }
            )
        }
    }
}
