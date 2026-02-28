import SwiftUI

struct HomeView: View {
    @StateObject  var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            VStack {
                Text("Home")
                List(viewModel.reminders) { reminder in
                                   NavigationLink {
                                       if let pet = viewModel.pet {
                                           ReminderBuilder.buildEdit(for: reminder, pet: pet)
                                       }
                                   } label: {
                                       ReminderCardView(reminder: reminder)
                                   }
                               }
            }
        }.onAppear{viewModel.loadData()}
    }
}


