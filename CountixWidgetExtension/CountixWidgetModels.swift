import Foundation

struct WidgetEventSnapshot: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let eventDate: Date
    let displayModeRawValue: Int
    let gradientPresetRawValue: String?
    let backgroundImageFileName: String?

    init(
        id: UUID,
        title: String,
        eventDate: Date,
        displayModeRawValue: Int,
        gradientPresetRawValue: String?,
        backgroundImageFileName: String?
    ) {
        self.id = id
        self.title = title
        self.eventDate = eventDate
        self.displayModeRawValue = displayModeRawValue
        self.gradientPresetRawValue = gradientPresetRawValue
        self.backgroundImageFileName = backgroundImageFileName
    }

    var displayMode: WidgetDisplayMode {
        WidgetDisplayMode(rawValue: displayModeRawValue)
    }

    var gradientPreset: WidgetPreviewGradientPreset {
        WidgetPreviewGradientPreset.fromStored(rawValue: gradientPresetRawValue)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        eventDate = try container.decode(Date.self, forKey: .eventDate)
        gradientPresetRawValue = try container.decodeIfPresent(String.self, forKey: .gradientPresetRawValue)
        backgroundImageFileName = try container.decodeIfPresent(String.self, forKey: .backgroundImageFileName)
        if let intValue = try? container.decode(Int.self, forKey: .displayModeRawValue) {
            displayModeRawValue = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .displayModeRawValue) {
            displayModeRawValue = WidgetDisplayMode(legacyRawValue: stringValue)?.rawValue ?? WidgetDisplayMode.all.rawValue
        } else {
            displayModeRawValue = WidgetDisplayMode.all.rawValue
        }
    }
}

enum WidgetCountdownUnit: String, Codable, CaseIterable {
    case years
    case months
    case days
    case hours
    case minutes
    case seconds
}

struct WidgetDisplayMode: Hashable, Codable {
    let rawValue: Int

    static let years = WidgetDisplayMode(rawValue: 1 << 0)
    static let months = WidgetDisplayMode(rawValue: 1 << 1)
    static let days = WidgetDisplayMode(rawValue: 1 << 2)
    static let hours = WidgetDisplayMode(rawValue: 1 << 3)
    static let minutes = WidgetDisplayMode(rawValue: 1 << 4)
    static let seconds = WidgetDisplayMode(rawValue: 1 << 5)
    static let all = WidgetDisplayMode(rawValue: (1 << 6) - 1)
    static let full = all
    static let monthsOnly = from([.months])
    static let daysOnly = from([.days])
    static let minutesOnly = from([.minutes])
    static let secondsOnly = from([.seconds])

    init(rawValue: Int) {
        self.rawValue = rawValue == 0 ? Self.all.rawValue : rawValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intRawValue = try? container.decode(Int.self) {
            self = WidgetDisplayMode(rawValue: intRawValue)
            return
        }
        if let stringRawValue = try? container.decode(String.self) {
            self = WidgetDisplayMode(legacyRawValue: stringRawValue) ?? .all
            return
        }
        self = .all
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    var shortLabel: String {
        units.map {
            switch $0 {
            case .years: return NSLocalizedString("Years", comment: "")
            case .months: return NSLocalizedString("Months", comment: "")
            case .days: return NSLocalizedString("Days", comment: "")
            case .hours: return NSLocalizedString("Hours", comment: "")
            case .minutes: return NSLocalizedString("Minutes", comment: "")
            case .seconds: return NSLocalizedString("Seconds", comment: "")
            }
        }.joined(separator: " • ")
    }

    var units: [WidgetCountdownUnit] {
        WidgetCountdownUnit.allCases.filter { contains($0) }
    }

    func contains(_ unit: WidgetCountdownUnit) -> Bool {
        (rawValue & Self.bit(for: unit)) != 0
    }

    init?(legacyRawValue: String) {
        switch legacyRawValue {
        case "full":
            self = .all
        case "monthsOnly":
            self = Self.from([.months])
        case "daysOnly":
            self = Self.from([.days])
        case "minutesOnly":
            self = Self.from([.minutes])
        case "secondsOnly":
            self = Self.from([.seconds])
        default:
            let parsedUnits = legacyRawValue.split(separator: ",").compactMap { WidgetCountdownUnit(rawValue: String($0)) }
            guard !parsedUnits.isEmpty else {
                return nil
            }
            self = Self.from(parsedUnits)
        }
    }

    private static func from(_ units: [WidgetCountdownUnit]) -> WidgetDisplayMode {
        let value = units.reduce(0) { $0 | bit(for: $1) }
        return WidgetDisplayMode(rawValue: value)
    }

    private static func bit(for unit: WidgetCountdownUnit) -> Int {
        switch unit {
        case .years:
            return 1 << 0
        case .months:
            return 1 << 1
        case .days:
            return 1 << 2
        case .hours:
            return 1 << 3
        case .minutes:
            return 1 << 4
        case .seconds:
            return 1 << 5
        }
    }
}
