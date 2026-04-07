import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {

                monthNavigationHeader
                
                calendarSection
                
                Divider()
                
                dayDetailSection
                    .frame(maxHeight: .infinity)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - Хедер месяца
    
    private var monthNavigationHeader: some View {
        HStack {
  
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.goToPreviousMonth()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.brandPrimary)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            

            Text(viewModel.monthName)
                .font(.headline)
                .fontWeight(.semibold)
                .animation(nil, value: viewModel.currentDate) // текст не анимируем
            
            Spacer()
            

            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.goToNextMonth()
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.brandPrimary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
    
    // MARK: - Секция сетки со свайп-жестом
    
    private var calendarSection: some View {
        CalendarGridView(viewModel: viewModel)
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
            
            .transition(monthTransition)
            .gesture(swipeGesture)
    }
    
   
    
    // MARK: - Секция деталей дня
    @ViewBuilder
    private var dayDetailSection: some View {
        Group {
            if let selectedDate = viewModel.selectedDate {
                DayDetailView(viewModel: viewModel, date: selectedDate)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 28))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("Choose a day")
                        .font(.subheadline)
                        .foregroundColor(.secondary.opacity(0.5))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brandBackgroundLight)
    }
    
    // MARK: - Свайп-жест
    
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded { value in
                
                let horizontalAmount = value.translation.width
                let verticalAmount = abs(value.translation.height)
                
               
                guard abs(horizontalAmount) > verticalAmount else { return }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    if horizontalAmount < 0 {
                      
                        viewModel.goToNextMonth()
                    } else {
                   
                        viewModel.goToPreviousMonth()
                    }
                }
            }
    }
    
    // MARK: - Transition для смены месяца
    
    private var monthTransition: AnyTransition {
        switch viewModel.navigationDirection {
        case .forward:
            // Следующий месяц "въезжает" справа, старый "уезжает" влево
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        case .backward:
            // Предыдущий месяц "въезжает" слева, старый "уезжает" вправо
            return .asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            )
        }
    }
}
