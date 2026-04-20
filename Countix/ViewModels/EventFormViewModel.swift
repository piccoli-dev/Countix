import Combine
import Foundation

@MainActor
final class EventFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var eventDate = Date()
    @Published var eventTime = Date()
    @Published var displayMode: DisplayMode = .full

    var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var combinedEventDate: Date {
        let calendar = Calendar.autoupdatingCurrent
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: eventDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: eventTime)

        var merged = DateComponents()
        merged.year = dayComponents.year
        merged.month = dayComponents.month
        merged.day = dayComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute

        return calendar.date(from: merged) ?? eventDate
    }

    func makeEvent() -> Event {
        Event(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            eventDate: combinedEventDate,
            displayMode: displayMode
        )
    }
}
