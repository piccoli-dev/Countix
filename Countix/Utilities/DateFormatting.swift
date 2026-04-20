import Foundation

enum DateFormatting {
    static let monthTitle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }()

    static let weekdaySymbol: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        return formatter
    }()

    static let dayNumber: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

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
