import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            Color.brandBackgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: Хедер с навигацией по месяцам
                monthNavigationHeader
                
                // MARK: Сетка календаря со свайп-жестом
                calendarSection
                
                Divider()
                
                // MARK: Детали выбранного дня (разворачивается снизу)
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
            // Кнопка "Назад"
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
            
            // Название месяца
            Text(viewModel.monthName)
                .font(.headline)
                .fontWeight(.semibold)
                .animation(nil, value: viewModel.currentDate) // текст не анимируем
            
            Spacer()
            
            // Кнопка "Вперёд"
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
            // Transition зависит от направления навигации
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
                    Text("Выберите день")
                        .font(.subheadline)
                        .foregroundColor(.secondary.opacity(0.5))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // оба варианта занимают одинаковое место
        .background(Color.brandBackground) // единый фон снаружи
    }
    
    // MARK: - Свайп-жест
    
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded { value in
                // Определяем направление по горизонтальной составляющей
                let horizontalAmount = value.translation.width
                let verticalAmount = abs(value.translation.height)
                
                // Игнорируем если жест больше вертикальный (скролл)
                guard abs(horizontalAmount) > verticalAmount else { return }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    if horizontalAmount < 0 {
                        // Свайп влево → следующий месяц
                        viewModel.goToNextMonth()
                    } else {
                        // Свайп вправо → предыдущий месяц
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
