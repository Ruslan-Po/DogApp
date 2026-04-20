import SwiftUI
import SwiftData

struct LaunchScreenView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @State private var isActive: Bool = false
    var body: some View {
       if isActive {
           OnboardingCoordinator()
               .modelContainer(.appContainer)
               .environmentObject(languageManager)
               .id(languageManager.current)
       } else {
           ZStack {
               Color.brandBackground.edgesIgnoringSafeArea(.all)
               VStack {
                   Text("FURR")
                       .font(.custom("Modak", size: 50))
                       .foregroundStyle(Color.brandBackgroundLight)
               }
           }.onAppear() {
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                   withAnimation{
                       self.isActive = true}
               }
           }
       }
    }
}


