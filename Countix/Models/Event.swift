import Foundation
import SwiftData

@Model
final class Event {
    @Attribute(.unique) var id: UUID
    var title: String
    var eventDate: Date
    var displayMode: DisplayMode

    init(id: UUID = UUID(), title: String, eventDate: Date, displayMode: DisplayMode) {
        self.id = id
        self.title = title
        self.eventDate = eventDate
        self.displayMode = displayMode
    }
}
