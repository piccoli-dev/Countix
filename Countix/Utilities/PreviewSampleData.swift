import Foundation
import SwiftData

enum PreviewSampleData {
    @MainActor
    static var container: ModelContainer {
        let schema = Schema([Event.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: configuration)

        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        let samples = [
            Event(title: "Summer Break", eventDate: calendar.date(byAdding: .day, value: 6, to: now)!, displayMode: .daysOnly),
            Event(title: "Flight to Tokyo", eventDate: calendar.date(byAdding: .hour, value: 18, to: now)!, displayMode: .full),
            Event(title: "Birthday Dinner", eventDate: calendar.date(byAdding: .day, value: 20, to: now)!, displayMode: .monthsOnly),
            Event(title: "Launch Reminder", eventDate: calendar.date(byAdding: .minute, value: 90, to: now)!, displayMode: .secondsOnly)
        ]

        for sample in samples {
            container.mainContext.insert(sample)
        }

        return container
    }
}
