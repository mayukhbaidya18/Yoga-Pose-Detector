import SwiftUI

struct HorizontalCalendarView: View {
    @ObservedObject var viewModel: PoseDetectionViewModel

    private let calendar = Calendar.current

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(generateDateRange(), id: \.self) { date in
                        dateCell(for: date)
                            .id(date) // ✅ tag each view
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 100)
            .onAppear {
                let today = calendar.startOfDay(for: Date())
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    proxy.scrollTo(today, anchor: .center) // ✅ scroll to today
                }
            }
        }

    }

    // MARK: - Calendar Date Cell
    func dateCell(for date: Date) -> some View {
        let dayName = formattedDayName(date)
        let dayNumber = formattedDayNumber(date)

        //let isToday = calendar.isDateInToday(date)
        let didYoga = viewModel.yogaDates.contains(calendar.startOfDay(for: date))

        let backgroundColor: Color = didYoga ? .green : .white
        let textColor: Color = didYoga ? .white : .black

        return VStack(spacing: 4) {
            Text(dayName)
                .font(.caption)
            Text(dayNumber)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(width: 60, height: 80)
        .background(backgroundColor)
        .foregroundColor(textColor)
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    // MARK: - Helpers
    func generateDateRange() -> [Date] {
        let today = calendar.startOfDay(for: Date())
        let start = calendar.date(byAdding: .day, value: -15, to: today)!
        return (0..<30).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    func formattedDayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    func formattedDayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
