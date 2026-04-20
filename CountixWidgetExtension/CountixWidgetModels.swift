import Foundation

struct WidgetEventSnapshot: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let eventDate: Date
    let displayModeRawValue: String

    var displayMode: WidgetDisplayMode {
        WidgetDisplayMode(rawValue: displayModeRawValue) ?? .full
    }
}

enum WidgetDisplayMode: String, Codable {
    case full
    case monthsOnly
    case daysOnly
    case minutesOnly
    case secondsOnly

    var shortLabel: String {
        switch self {
        case .full:
            return "Full"
        case .monthsOnly:
            return "Months"
        case .daysOnly:
            return "Days"
        case .minutesOnly:
            return "Minutes"
        case .secondsOnly:
            return "Seconds"
        }
    }
}
