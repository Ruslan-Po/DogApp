import SwiftUI


struct Coordinator: View {
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var pages : [TabItem] = [
        TabItem(image: "petHome", title: "home", tag: .home),
        TabItem(image: "pets", title: "pets", tag: .pets),
        TabItem(image: "petCalendar", title: "calendar",tag: .calendar),
        TabItem(image: "petProfile", title: "profile",tag: .profile)
    ]
    
    @State var coordinatorTags: CoordinatorTags = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $coordinatorTags) {
                NavigationStack{
                    HomeBuilder.build()
                }.tag(CoordinatorTags.home)
                NavigationStack{
                    PetViewBuilder.build()
                }.tag(CoordinatorTags.pets)
                NavigationStack {
                    CalendarBuilder.build()
                } .tag(CoordinatorTags.calendar)
                ProfileView()
                    .tag(CoordinatorTags.profile)
            }
            
            HStack (spacing: 40){
                ForEach(pages) { page in
                    TabItemView(item: page, selector: $coordinatorTags)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .background(Color.brandBackground)
            
        }
    }
}
