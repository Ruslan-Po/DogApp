import SwiftUI

struct HomeView: View {
    @StateObject  var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            VStack {
                Text("Home")
                List(viewModel.reminders) { reminder in
                             ReminderCardView(reminder: reminder)
                         }
            }
        }.onAppear{viewModel.loadData()}
    }
}


