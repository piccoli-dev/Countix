import Foundation

enum CountdownFormatter {
    static func countdownText(to targetDate: Date, mode: DisplayMode, now: Date = .now) -> String {
        guard targetDate >= now else {
            return L10n.tr("Event passed")
        }

        let selectedUnits = mode.isEmpty ? DisplayMode.all.units : mode.units
        var remainingSeconds = max(0, Int(targetDate.timeIntervalSince(now)))
        var parts: [String] = []

        for unit in selectedUnits {
            let unitSeconds = seconds(for: unit)
            guard unitSeconds > 0 else {
                continue
            }

            let value: Int
            if unit == selectedUnits.last {
                value = remainingSeconds
            } else {
                value = remainingSeconds / unitSeconds
                remainingSeconds %= unitSeconds
            }

            parts.append(formattedUnit(value, unit: unit))
        }

        return parts.joined(separator: ", ")
    }

    static func relativeStatus(for targetDate: Date, now: Date = .now) -> String {
        targetDate >= now ? L10n.tr("Upcoming") : L10n.tr("Passed")
    }

    private static func seconds(for unit: CountdownUnit) -> Int {
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

    private static func formattedUnit(_ value: Int, unit: CountdownUnit) -> String {
        switch unit {
        case .years:
            return L10n.tr(value == 1 ? "%d year" : "%d years", value)
        case .months:
            return L10n.tr(value == 1 ? "%d month" : "%d months", value)
        case .days:
            return L10n.tr(value == 1 ? "%d day" : "%d days", value)
        case .hours:
            return L10n.tr(value == 1 ? "%d hour" : "%d hours", value)
        case .minutes:
            return L10n.tr(value == 1 ? "%d minute" : "%d minutes", value)
        case .seconds:
            return L10n.tr(value == 1 ? "%d second" : "%d seconds", value)
        }
    }
}
