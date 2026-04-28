import Foundation
import SwiftData

@Model
final class Event {
    @Attribute(.unique) var id: UUID
    var title: String
    var eventDate: Date
    @Attribute(originalName: "displayMode") var displayModeRawValue: String
    var gradientPresetRawValue: String?
    var backgroundImageFileName: String?

    init(
        id: UUID = UUID(),
        title: String,
        eventDate: Date,
        displayMode: DisplayMode,
        gradientPresetRawValue: String = EventGradientPreset.blue.rawValue,
        backgroundImageFileName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.eventDate = eventDate
        self.displayModeRawValue = displayMode.storageValue
        self.gradientPresetRawValue = gradientPresetRawValue
        self.backgroundImageFileName = backgroundImageFileName
    }

    var displayMode: DisplayMode {
        get { DisplayMode(storageValue: displayModeRawValue) ?? .all }
        set { displayModeRawValue = newValue.storageValue }
    }

    var gradientPreset: EventGradientPreset {
        get { EventGradientPreset.fromStored(rawValue: gradientPresetRawValue) }
        set { gradientPresetRawValue = newValue.rawValue }
    }
}
