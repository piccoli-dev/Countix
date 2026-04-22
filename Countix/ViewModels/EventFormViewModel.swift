import Combine
import Foundation

struct EventDraft {
    let title: String
    let eventDate: Date
    let displayMode: DisplayMode
    let gradientPreset: EventGradientPreset
    let backgroundImageData: Data?
}

@MainActor
final class EventFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var eventDate = Date()
    @Published var eventTime = Date()
    @Published var displayMode: DisplayMode = .full
    @Published var gradientPreset: EventGradientPreset = .blue
    @Published var backgroundImageData: Data?

    init(event: Event? = nil) {
        guard let event else { return }
        title = event.title
        eventDate = event.eventDate
        eventTime = event.eventDate
        displayMode = event.displayMode
        gradientPreset = event.gradientPreset
        backgroundImageData = AppGroup.loadEventBackgroundImageData(fileName: event.backgroundImageFileName)
    }

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

    func makeDraft() -> EventDraft {
        EventDraft(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            eventDate: combinedEventDate,
            displayMode: displayMode,
            gradientPreset: gradientPreset,
            backgroundImageData: backgroundImageData
        )
    }

    func apply(to event: Event) {
        let draft = makeDraft()
        event.title = draft.title
        event.eventDate = draft.eventDate
        event.displayMode = draft.displayMode
        event.gradientPreset = draft.gradientPreset
    }
}
