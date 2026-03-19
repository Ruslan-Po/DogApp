import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            VStack {
                Text("Calendar")
            }
        }
    }
}


