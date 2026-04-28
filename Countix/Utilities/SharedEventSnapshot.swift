import Foundation

struct SharedEventSnapshot: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let eventDate: Date
    let displayModeRawValue: Int
    let gradientPresetRawValue: String
    let backgroundImageFileName: String?

    init(
        id: UUID,
        title: String,
        eventDate: Date,
        displayModeRawValue: Int,
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        eventDate = try container.decode(Date.self, forKey: .eventDate)
        gradientPresetRawValue = try container.decode(String.self, forKey: .gradientPresetRawValue)
        backgroundImageFileName = try container.decodeIfPresent(String.self, forKey: .backgroundImageFileName)
        if let intValue = try? container.decode(Int.self, forKey: .displayModeRawValue) {
            displayModeRawValue = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .displayModeRawValue) {
            displayModeRawValue = DisplayMode(legacyRawValue: stringValue)?.rawValue ?? DisplayMode.all.rawValue
        } else {
            displayModeRawValue = DisplayMode.all.rawValue
        }
    }
}
