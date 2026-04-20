import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var isPresentingForm = false

    private let calendar = Calendar.autoupdatingCurrent

    var title: String { "Event Countdown" }
    var subtitle: String { "Your premium timeline for the moments that matter." }

    init() {
        selectedDate = calendar.startOfDay(for: .now)
    }

    func filteredEvents(from events: [Event]) -> [Event] {
        events
            .filter { calendar.isDate($0.eventDate, inSameDayAs: selectedDate) }
            .sorted { $0.eventDate < $1.eventDate }
    }

    func hasEvents(on date: Date, events: [Event]) -> Bool {
        events.contains { calendar.isDate($0.eventDate, inSameDayAs: date) }
    }

    func jumpToToday() {
        selectedDate = calendar.startOfDay(for: .now)
    }

    func changeMonth(by offset: Int) {
        if let newDate = calendar.date(byAdding: .month, value: offset, to: selectedDate) {
            selectedDate = calendar.startOfDay(for: newDate)
        }
    }
}
