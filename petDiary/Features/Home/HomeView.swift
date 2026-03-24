import SwiftUI

struct HomeView: View {
    @StateObject  var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            VStack {
                Text("Reminders")
                List(viewModel.reminders) { reminder in
                                   NavigationLink {
                                       if let pet = reminder.pet {
                                           ReminderBuilder.buildEdit(for: reminder, pet: pet)
                                       }
                                   } label: {
                                       ReminderCardView(reminder: reminder)
                                   }
                               }
                Text("Events")
                List(viewModel.events) { event in
                    EventCardView(event: event)
                }
            }
           
        }.onAppear{viewModel.loadData()}
    }
}


