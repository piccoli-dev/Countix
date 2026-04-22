import Foundation
import SwiftData

@Model
final class Event {
    @Attribute(.unique) var id: UUID
    var title: String
    var eventDate: Date
    var displayMode: DisplayMode
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
        self.displayMode = displayMode
        self.gradientPresetRawValue = gradientPresetRawValue
        self.backgroundImageFileName = backgroundImageFileName
    }

    var gradientPreset: EventGradientPreset {
        get { EventGradientPreset(rawValue: gradientPresetRawValue ?? "") ?? .blue }
        set { gradientPresetRawValue = newValue.rawValue }
    }
}
