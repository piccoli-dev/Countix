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
        let now = Date()
        return loadEvents().first { $0.eventDate >= now } ?? loadEvents().first
    }
}
