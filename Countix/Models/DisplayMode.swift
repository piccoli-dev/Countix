import Foundation

enum DisplayMode: String, Codable, CaseIterable, Identifiable {
    case full
    case monthsOnly
    case daysOnly
    case minutesOnly
    case secondsOnly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .full:
            return "Full Countdown"
        case .monthsOnly:
            return "Months Only"
        case .daysOnly:
            return "Days Only"
        case .minutesOnly:
            return "Minutes Only"
        case .secondsOnly:
            return "Seconds Only"
        }
    }

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

    var symbolName: String {
        switch self {
        case .full:
            return "sparkles.rectangle.stack"
        case .monthsOnly:
            return "calendar"
        case .daysOnly:
            return "sun.max"
        case .minutesOnly:
            return "timer"
        case .secondsOnly:
            return "bolt"
        }
    }

    var refreshInterval: TimeInterval {
        switch self {
        case .full, .secondsOnly:
            return 1
        case .minutesOnly:
            return 60
        case .monthsOnly, .daysOnly:
            return 3600
        }
    }
}
