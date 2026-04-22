import Foundation

struct SharedEventSnapshot: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let eventDate: Date
    let displayModeRawValue: String
    let gradientPresetRawValue: String
    let backgroundImageFileName: String?

    init(
        id: UUID,
        title: String,
        eventDate: Date,
        displayModeRawValue: String,
        gradientPresetRawValue: String,
        backgroundImageFileName: String?
    ) {
        self.id = id
        self.title = title
        self.eventDate = eventDate
        self.displayModeRawValue = displayModeRawValue
        self.gradientPresetRawValue = gradientPresetRawValue
        self.backgroundImageFileName = backgroundImageFileName
    }

    init(event: Event) {
        self.id = event.id
        self.title = event.title
        self.eventDate = event.eventDate
        self.displayModeRawValue = event.displayMode.rawValue
        self.gradientPresetRawValue = event.gradientPreset.rawValue
        self.backgroundImageFileName = event.backgroundImageFileName
    }
}
