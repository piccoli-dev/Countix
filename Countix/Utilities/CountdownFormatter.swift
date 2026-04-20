import Foundation

enum CountdownFormatter {
    private static let calendar = Calendar.autoupdatingCurrent

    static func countdownText(to targetDate: Date, mode: DisplayMode, now: Date = .now) -> String {
        guard targetDate >= now else {
            return "Event passed"
        }

        switch mode {
        case .full:
            return fullCountdown(to: targetDate, now: now)
        case .monthsOnly:
            let months = totalMonths(from: now, to: targetDate)
            return formattedUnit(months, singular: "month", plural: "months")
        case .daysOnly:
            let days = max(0, Int(targetDate.timeIntervalSince(now) / 86_400))
            return formattedUnit(days, singular: "day", plural: "days")
        case .minutesOnly:
            let minutes = max(0, Int(targetDate.timeIntervalSince(now) / 60))
            return formattedUnit(minutes, singular: "minute", plural: "minutes")
        case .secondsOnly:
            let seconds = max(0, Int(targetDate.timeIntervalSince(now)))
            return formattedUnit(seconds, singular: "second", plural: "seconds")
        }
    }

    static func relativeStatus(for targetDate: Date, now: Date = .now) -> String {
        targetDate >= now ? "Upcoming" : "Passed"
    }

    private static func fullCountdown(to targetDate: Date, now: Date) -> String {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now, to: targetDate)
        let years = max(0, components.year ?? 0)
        let months = max(0, components.month ?? 0)
        let days = max(0, components.day ?? 0)
        let minutes = max(0, (components.hour ?? 0) * 60 + (components.minute ?? 0))
        let seconds = max(0, components.second ?? 0)

        let parts = [
            years > 0 ? formattedUnit(years, singular: "year", plural: "years") : nil,
            months > 0 ? formattedUnit(months, singular: "month", plural: "months") : nil,
            days > 0 ? formattedUnit(days, singular: "day", plural: "days") : nil,
            minutes > 0 ? formattedUnit(minutes, singular: "minute", plural: "minutes") : nil,
            formattedUnit(seconds, singular: "second", plural: "seconds")
        ]

        return parts.compactMap { $0 }.joined(separator: ", ")
    }

    private static func totalMonths(from startDate: Date, to endDate: Date) -> Int {
        let start = calendar.dateComponents([.year, .month], from: startDate)
        let end = calendar.dateComponents([.year, .month], from: endDate)

        let years = (end.year ?? 0) - (start.year ?? 0)
        let months = (end.month ?? 0) - (start.month ?? 0)

        return max(0, (years * 12) + months)
    }

    private static func formattedUnit(_ value: Int, singular: String, plural: String) -> String {
        "\(value) \(value == 1 ? singular : plural)"
    }
}
