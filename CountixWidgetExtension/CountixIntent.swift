import AppIntents
import WidgetKit

struct EventEntity: AppEntity {
    let id: UUID
    let title: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Event"
    static var defaultQuery = EventQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

struct EventQuery: EntityQuery {
    func entities(for identifiers: [EventEntity.ID]) async throws -> [EventEntity] {
        WidgetSharedEventStore.loadEvents()
            .filter { identifiers.contains($0.id) }
            .map { EventEntity(id: $0.id, title: $0.title) }
    }

    func suggestedEntities() async throws -> [EventEntity] {
        WidgetSharedEventStore.loadEvents()
            .map { EventEntity(id: $0.id, title: $0.title) }
    }

    func defaultResult() async throws -> EventEntity? {
        try? await suggestedEntities().first
    }
}

struct CountixIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Event"
    static var description = IntentDescription("Select an event to display in the widget.")

    @Parameter(title: "Event")
    var selectedEvent: EventEntity?
}
