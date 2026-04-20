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
    private static let calendar = Calendar.autoupdatingCurrent

    static func countdownText(to targetDate: Date, mode: WidgetDisplayMode, now: Date = .now) -> String {
        guard targetDate >= now else {
            return "Event passed"
        }

        switch mode {
        case .full:
            return fullCountdown(to: targetDate, now: now)
        case .monthsOnly:
            let months = totalMonths(from: now, to: targetDate)
            return unit(months, singular: "month", plural: "months")
        case .daysOnly:
            let days = max(0, Int(targetDate.timeIntervalSince(now) / 86_400))
            return unit(days, singular: "day", plural: "days")
        case .minutesOnly:
            let minutes = max(0, Int(targetDate.timeIntervalSince(now) / 60))
            return unit(minutes, singular: "minute", plural: "minutes")
        case .secondsOnly:
            let seconds = max(0, Int(targetDate.timeIntervalSince(now)))
            return unit(seconds, singular: "second", plural: "seconds")
        }
    }

    static func relativeStatus(for targetDate: Date, now: Date = .now) -> String {
        targetDate >= now ? "Upcoming" : "Passed"
    }

    static func refreshInterval(for mode: WidgetDisplayMode) -> TimeInterval {
        switch mode {
        case .full, .secondsOnly:
            return 60
        case .minutesOnly:
            return 60
        case .daysOnly, .monthsOnly:
            return 3600
        }
    }

    private static func fullCountdown(to targetDate: Date, now: Date) -> String {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now, to: targetDate)
        let years = max(0, components.year ?? 0)
        let months = max(0, components.month ?? 0)
        let days = max(0, components.day ?? 0)
        let minutes = max(0, ((components.hour ?? 0) * 60) + (components.minute ?? 0))

        let parts = [
            years > 0 ? unit(years, singular: "year", plural: "years") : nil,
            months > 0 ? unit(months, singular: "month", plural: "months") : nil,
            days > 0 ? unit(days, singular: "day", plural: "days") : nil,
            unit(minutes, singular: "minute", plural: "minutes")
        ]

        return parts.compactMap { $0 }.joined(separator: ", ")
    }

    private static func totalMonths(from startDate: Date, to endDate: Date) -> Int {
        let start = calendar.dateComponents([.year, .month], from: startDate)
        let end = calendar.dateComponents([.year, .month], from: endDate)
        return max(0, ((end.year ?? 0) - (start.year ?? 0)) * 12 + ((end.month ?? 0) - (start.month ?? 0)))
    }

    private static func unit(_ value: Int, singular: String, plural: String) -> String {
        "\(value) \(value == 1 ? singular : plural)"
    }
}
