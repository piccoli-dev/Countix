import Foundation

enum WidgetDateFormatting {
    static let eventDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let eventTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

enum WidgetCountdownFormatter {
    static func countdownText(to targetDate: Date, mode: WidgetDisplayMode, now: Date = .now) -> String {
        guard targetDate >= now else {
            return NSLocalizedString("Event passed", comment: "")
        }

        let selectedUnits = mode.units
        var remainingSeconds = max(0, Int(targetDate.timeIntervalSince(now)))
        var parts: [String] = []

        for selectedUnit in selectedUnits {
            let unitSeconds = seconds(for: selectedUnit)
            let value: Int
            if selectedUnit == selectedUnits.last {
                value = remainingSeconds
            } else {
                value = remainingSeconds / unitSeconds
                remainingSeconds %= unitSeconds
            }
            parts.append(formattedUnit(value, for: selectedUnit))
        }

        return parts.joined(separator: ", ")
    }

    static func relativeStatus(for targetDate: Date, now: Date = .now) -> String {
        targetDate >= now ? NSLocalizedString("Upcoming", comment: "") : NSLocalizedString("Passed", comment: "")
    }

    static func refreshInterval(for mode: WidgetDisplayMode) -> TimeInterval {
        if mode.contains(.seconds) {
            return 1
        }
        if mode.contains(.minutes) || mode.contains(.hours) {
            return 60
        }
        return 3600
    }

    private static func seconds(for unit: WidgetCountdownUnit) -> Int {
        switch unit {
        case .years:
            return 365 * 24 * 60 * 60
        case .months:
            return 30 * 24 * 60 * 60
        case .days:
            return 24 * 60 * 60
        case .hours:
            return 60 * 60
        case .minutes:
            return 60
        case .seconds:
            return 1
        }
    }

    private static func formattedUnit(_ value: Int, for unit: WidgetCountdownUnit) -> String {
        switch unit {
        case .years:
            return String(format: NSLocalizedString(value == 1 ? "%d year" : "%d years", comment: ""), locale: Locale.current, value)
        case .months:
            return String(format: NSLocalizedString(value == 1 ? "%d month" : "%d months", comment: ""), locale: Locale.current, value)
        case .days:
            return String(format: NSLocalizedString(value == 1 ? "%d day" : "%d days", comment: ""), locale: Locale.current, value)
        case .hours:
            return String(format: NSLocalizedString(value == 1 ? "%d hour" : "%d hours", comment: ""), locale: Locale.current, value)
        case .minutes:
            return String(format: NSLocalizedString(value == 1 ? "%d minute" : "%d minutes", comment: ""), locale: Locale.current, value)
        case .seconds:
            return String(format: NSLocalizedString(value == 1 ? "%d second" : "%d seconds", comment: ""), locale: Locale.current, value)
        }
    }
}
