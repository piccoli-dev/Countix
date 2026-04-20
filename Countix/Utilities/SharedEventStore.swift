import Foundation
import WidgetKit

enum SharedEventStore {
    static func save(events: [Event]) {
        let payload = events
            .map(SharedEventSnapshot.init)
            .sorted { $0.eventDate < $1.eventDate }

        guard let defaults = UserDefaults(suiteName: AppGroup.identifier) else {
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(payload) else {
            return
        }

        defaults.set(data, forKey: AppGroup.eventsKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
