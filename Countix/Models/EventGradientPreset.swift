import SwiftUI

enum EventGradientPreset: String, CaseIterable, Codable, Identifiable {
    case blue
    case orange
    case green
    case yellow
    case purple
    case primary
    case secondary
    case red
    case lightBlue
    case pink

    var id: String { rawValue }

    var title: String {
        switch self {
        case .blue: return L10n.tr("Blue")
        case .orange: return L10n.tr("Orange")
        case .green: return L10n.tr("Green")
        case .yellow: return L10n.tr("Yellow")
        case .purple: return L10n.tr("Purple")
        case .primary: return L10n.tr("Primary")
        case .secondary: return L10n.tr("Secondary")
        case .red: return L10n.tr("Red")
        case .lightBlue: return L10n.tr("Light Blue")
        case .pink: return L10n.tr("Pink")
        }
    }

    var colors: [Color] {
        switch self {
        case .blue:
            return [
                Color(red: 0.14, green: 0.23, blue: 0.41),
                Color(red: 0.18, green: 0.46, blue: 0.72),
                Color(red: 0.48, green: 0.74, blue: 0.86)
            ]
        case .orange:
            return [
                Color(red: 0.39, green: 0.17, blue: 0.05),
                Color(red: 0.75, green: 0.34, blue: 0.08),
                Color(red: 0.97, green: 0.62, blue: 0.22)
            ]
        case .green:
            return [
                Color(red: 0.07, green: 0.24, blue: 0.12),
                Color(red: 0.15, green: 0.53, blue: 0.24),
                Color(red: 0.52, green: 0.84, blue: 0.40)
            ]
        case .yellow:
            return [
                Color(red: 0.40, green: 0.31, blue: 0.02),
                Color(red: 0.73, green: 0.57, blue: 0.06),
                Color(red: 0.94, green: 0.81, blue: 0.24)
            ]
        case .purple:
            return [
                Color(red: 0.18, green: 0.12, blue: 0.39),
                Color(red: 0.36, green: 0.21, blue: 0.68),
                Color(red: 0.66, green: 0.48, blue: 0.89)
            ]
        case .primary:
            return [
                Color.primary.opacity(0.95),
                Color.primary.opacity(0.75),
                Color.primary.opacity(0.55)
            ]
        case .secondary:
            return [
                Color.secondary.opacity(0.95),
                Color.secondary.opacity(0.75),
                Color.secondary.opacity(0.55)
            ]
        case .red:
            return [
                Color(red: 0.39, green: 0.05, blue: 0.10),
                Color(red: 0.72, green: 0.12, blue: 0.18),
                Color(red: 0.90, green: 0.33, blue: 0.34)
            ]
        case .lightBlue:
            return [
                Color(red: 0.08, green: 0.36, blue: 0.47),
                Color(red: 0.20, green: 0.62, blue: 0.73),
                Color(red: 0.62, green: 0.89, blue: 0.95)
            ]
        case .pink:
            return [
                Color(red: 0.48, green: 0.10, blue: 0.31),
                Color(red: 0.77, green: 0.22, blue: 0.49),
                Color(red: 0.95, green: 0.60, blue: 0.76)
            ]
        }
    }

    static func fromStored(rawValue: String?) -> EventGradientPreset {
        guard let rawValue else { return .blue }
        if rawValue == "black" { return .primary }
        if rawValue == "white" { return .secondary }
        return EventGradientPreset(rawValue: rawValue) ?? .blue
    }
}
