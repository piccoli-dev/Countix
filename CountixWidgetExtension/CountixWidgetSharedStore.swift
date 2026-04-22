import Foundation

enum WidgetSharedEventStore {
    static func loadEvents() -> [WidgetEventSnapshot] {
        guard let defaults = UserDefaults(suiteName: "group.com.piccolidev.Countix"),
              let data = defaults.data(forKey: "shared.events") else {
            return []
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return (try? decoder.decode([WidgetEventSnapshot].self, from: data))?
            .sorted { $0.eventDate < $1.eventDate } ?? []
    }

    static func loadUpcomingEvent() -> WidgetEventSnapshot? {
        loadEvent(with: nil)
    }

    static func loadEvent(with id: UUID?) -> WidgetEventSnapshot? {
        let events = loadEvents()

        if let id = id, let selectedEvent = events.first(where: { $0.id == id }) {
            return selectedEvent
        }

        let now = Date()
        return events.first { $0.eventDate >= now } ?? events.first
    }
}
