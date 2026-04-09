import SwiftUI

struct PetStatsView: View {
    let events: [Event]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("stats.statistics".localized)
                .cruinn(.bold, size: 20)

            if events.isEmpty {
                Text("stats.noEvents".localized)
                    .cruinn(.regular, size: 14)
                    .foregroundStyle(.secondary)
            } else {
                activityStats
                nutritionStats
                groomingDates
                healthDates
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Activity (walks)

    private var activityEvents: [Event] {
        events.filter { $0.category == .activity }
    }

    @ViewBuilder
    private var activityStats: some View {
        if !activityEvents.isEmpty {
            StatCard(
                icon: "activity",
                title: "stats.walks".localized,
                rows: [
                    StatRow(label: "stats.total".localized, value: "\(activityEvents.count)"),
                    StatRow(label: "stats.avgTime".localized, value: averageTimeOfDay(activityEvents)),
                    lastDateRow(activityEvents)
                ]
            )
        }
    }

    // MARK: - Nutrition

    private var nutritionEvents: [Event] {
        events.filter { $0.category == .nutrition }
    }

    @ViewBuilder
    private var nutritionStats: some View {
        let withPortion = nutritionEvents.filter { $0.portionSize != nil }
        if !nutritionEvents.isEmpty {
            StatCard(
                icon: "nutrition",
                title: "stats.nutrition".localized,
                rows: [
                    StatRow(label: "stats.totalMeals".localized, value: "\(nutritionEvents.count)"),
                    withPortion.isEmpty ? nil : StatRow(
                        label: "stats.avgPortion".localized,
                        value: "\(Int(withPortion.compactMap(\.portionSize).reduce(0, +) / Double(withPortion.count))) g"
                    ),
                    lastDateRow(nutritionEvents)
                ].compactMap { $0 }
            )
        }
    }
    
    // MARK: - Bath

    private var bathEvents: [Event] {
        events.filter { $0.category == .bath }
    }

    @ViewBuilder
    private var bathStats: some View {
        let withPortion = bathEvents.filter { $0.portionSize != nil }
        if !bathEvents.isEmpty {
            StatCard(
                icon: "bath",
                title: "stats.bath".localized,
                rows: [
                    StatRow(label: "stats.total".localized, value: "\(bathEvents.count)"),
                    withPortion.isEmpty ? nil : StatRow(
                        label: "stats.avgPortion".localized,
                        value: "\(Int(withPortion.compactMap(\.portionSize).reduce(0, +) / Double(withPortion.count))) g"
                    ),
                    lastDateRow(nutritionEvents)
                ].compactMap { $0 }
            )
        }
    }

    // MARK: - Grooming

    private var groomingEvents: [Event] {
        events.filter { $0.category == .grooming }
    }

    @ViewBuilder
    private var groomingDates: some View {
        if !groomingEvents.isEmpty {
            let sorted = groomingEvents.sorted { $0.date > $1.date }
            StatCard(
                icon: "grooming",
                title: "stats.grooming".localized,
                rows: [
                    StatRow(label: "stats.total".localized, value: "\(groomingEvents.count)"),
                    StatRow(label: "stats.last".localized, value: sorted.first?.date.formatted(date: .abbreviated, time: .omitted) ?? "-"),
                    sorted.count > 1 ? StatRow(label: "stats.avgInterval".localized, value: averageInterval(sorted)) : nil
                ].compactMap { $0 }
            )
        }
    }

    // MARK: - Health

    private var healthEvents: [Event] {
        events.filter { $0.category == .health }
    }

    @ViewBuilder
    private var healthDates: some View {
        if !healthEvents.isEmpty {
            let sorted = healthEvents.sorted { $0.date > $1.date }
            StatCard(
                icon: "health",
                title: "stats.healthVaccinations".localized,
                rows: [
                    StatRow(label: "stats.total".localized, value: "\(healthEvents.count)"),
                    StatRow(label: "stats.last".localized, value: sorted.first?.date.formatted(date: .abbreviated, time: .omitted) ?? "-"),
                    StatRow(label: "stats.recent".localized, value: sorted.prefix(3).map(\.title).joined(separator: ", "))
                ]
            )
        }
    }

    // MARK: - Helpers

    private func lastDateRow(_ events: [Event]) -> StatRow {
        let last = events.sorted { $0.date > $1.date }.first
        return StatRow(label: "stats.last".localized, value: last?.date.formatted(date: .abbreviated, time: .shortened) ?? "-")
    }

    private func averageTimeOfDay(_ events: [Event]) -> String {
        guard !events.isEmpty else { return "-" }
        let calendar = Calendar.current
        var totalMinutes = 0
        for event in events {
            let comps = calendar.dateComponents([.hour, .minute], from: event.date)
            totalMinutes += (comps.hour ?? 0) * 60 + (comps.minute ?? 0)
        }
        let avgMinutes = totalMinutes / events.count
        let hours = avgMinutes / 60
        let minutes = avgMinutes % 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    private func averageInterval(_ sorted: [Event]) -> String {
        guard sorted.count > 1 else { return "-" }
        var totalDays: Double = 0
        for i in 0..<sorted.count - 1 {
            let diff = sorted[i].date.timeIntervalSince(sorted[i + 1].date)
            totalDays += diff / 86400
        }
        let avg = Int(totalDays / Double(sorted.count - 1))
        return "\(avg) days"
    }
}

// MARK: - Subviews

struct StatRow: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

struct StatCard: View {
    let icon: String
    let title: String
    let rows: [StatRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundStyle(Color.petzenTeal)
                Text(title)
                    .cruinn(.bold, size: 16)
            }

            ForEach(rows) { row in
                HStack {
                    Text(row.label)
                        .cruinn(.regular, size: 13)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(row.value)
                        .cruinn(.medium, size: 13)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
