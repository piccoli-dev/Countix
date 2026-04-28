import Foundation

enum CountdownUnit: String, Codable, CaseIterable, Identifiable {
    case years
    case months
    case days
    case hours
    case minutes
    case seconds

    var id: String { rawValue }

    var title: String {
        switch self {
        case .years:
            return L10n.tr("Years")
        case .months:
            return L10n.tr("Months")
        case .days:
            return L10n.tr("Days")
        case .hours:
            return L10n.tr("Hours")
        case .minutes:
            return L10n.tr("Minutes")
        case .seconds:
            return L10n.tr("Seconds")
        }
    }

    var symbolName: String {
        switch self {
        case .years:
            return "calendar.badge.clock"
        case .months:
            return "calendar"
        case .days:
            return "sun.max"
        case .hours:
            return "clock"
        case .minutes:
            return "timer"
        case .seconds:
            return "bolt"
        }
    }
}

struct DisplayMode: OptionSet, Hashable, Codable {
    var rawValue: Int

    static let years = DisplayMode(rawValue: 1 << 0)
    static let months = DisplayMode(rawValue: 1 << 1)
    static let days = DisplayMode(rawValue: 1 << 2)
    static let hours = DisplayMode(rawValue: 1 << 3)
    static let minutes = DisplayMode(rawValue: 1 << 4)
    static let seconds = DisplayMode(rawValue: 1 << 5)

    static let all: DisplayMode = [.years, .months, .days, .hours, .minutes, .seconds]
    static let full: DisplayMode = .all
    static let monthsOnly: DisplayMode = [.months]
    static let daysOnly: DisplayMode = [.days]
    static let minutesOnly: DisplayMode = [.minutes]
    static let secondsOnly: DisplayMode = [.seconds]

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intRawValue = try? container.decode(Int.self) {
            let decoded = DisplayMode(rawValue: intRawValue)
            self = decoded.isEmpty ? .all : decoded
            return
        }

        if let stringRawValue = try? container.decode(String.self) {
            self = DisplayMode(legacyRawValue: stringRawValue) ?? .all
            return
        }

        self = .all
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    init?(legacyRawValue: String) {
        switch legacyRawValue {
        case "full":
            self = .all
        case "monthsOnly":
            self = [.months]
        case "daysOnly":
            self = [.days]
        case "minutesOnly":
            self = [.minutes]
        case "secondsOnly":
            self = [.seconds]
        default:
            let units = legacyRawValue
                .split(separator: ",")
                .compactMap { DisplayMode.unit(from: String($0)) }
            guard !units.isEmpty else {
                return nil
            }
            self = DisplayMode(units: units)
        }
    }

    init?(storageValue: String) {
        if let intValue = Int(storageValue) {
            self = DisplayMode(rawValue: intValue)
            if isEmpty {
                self = .all
            }
            return
        }
        self.init(legacyRawValue: storageValue)
    }

    init(units: [CountdownUnit]) {
        self = units.reduce(into: DisplayMode()) { partial, unit in
            partial.insert(Self.flag(for: unit))
        }
        if isEmpty {
            self = .all
        }
    }

    var units: [CountdownUnit] {
        CountdownUnit.allCases.filter { contains(Self.flag(for: $0)) }
    }

    var storageValue: String {
        String(rawValue)
    }

    var title: String {
        let selectedUnits = units
        if selectedUnits.count == CountdownUnit.allCases.count {
            return L10n.tr("Full Countdown")
        }
        return selectedUnits.map(\.title).joined(separator: ", ")
    }

    var shortLabel: String {
        units.map(\.title).joined(separator: " • ")
    }

    var symbolName: String {
        if contains(.seconds) {
            return "bolt"
        }
        if contains(.minutes) || contains(.hours) {
            return "timer"
        }
        if contains(.days) {
            return "sun.max"
        }
        return "calendar"
    }

    var refreshInterval: TimeInterval {
        if contains(.seconds) {
            return 1
        }
        if contains(.minutes) || contains(.hours) {
            return 60
        }
        return 3600
    }

    func containsFlag(for unit: CountdownUnit) -> Bool {
        contains(Self.flag(for: unit))
    }

    mutating func insertFlag(for unit: CountdownUnit) {
        insert(Self.flag(for: unit))
    }

    mutating func removeFlag(for unit: CountdownUnit) {
        remove(Self.flag(for: unit))
    }

    private static func flag(for unit: CountdownUnit) -> DisplayMode {
        switch unit {
        case .years:
            return .years
        case .months:
            return .months
        case .days:
            return .days
        case .hours:
            return .hours
        case .minutes:
            return .minutes
        case .seconds:
            return .seconds
        }
    }

    private static func unit(from raw: String) -> CountdownUnit? {
        switch raw {
        case CountdownUnit.years.rawValue:
            return .years
        case CountdownUnit.months.rawValue:
            return .months
        case CountdownUnit.days.rawValue:
            return .days
        case CountdownUnit.hours.rawValue:
            return .hours
        case CountdownUnit.minutes.rawValue:
            return .minutes
        case CountdownUnit.seconds.rawValue:
            return .seconds
        default:
            return nil
        }
    }
}
