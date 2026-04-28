import SwiftUI

/// App-wide constants for branding and layout.
enum Constants {
    /// Brand color palette.
    enum colors {
        static let yellow = Color(hex: "#fcd46d")
        static let peach = Color(hex: "#fc957d")
        static let purple = Color(hex: "#5b42fc")

        static let screenBackgroundTop = Color(
            uiColor: UIColor { trait in
                trait.userInterfaceStyle == .dark
                    ? UIColor(red: 0.09, green: 0.10, blue: 0.13, alpha: 1)
                    : UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1)
            }
        )
        static let screenBackgroundMid = Color(
            uiColor: UIColor { trait in
                trait.userInterfaceStyle == .dark
                    ? UIColor(red: 0.12, green: 0.14, blue: 0.18, alpha: 1)
                    : UIColor(red: 0.89, green: 0.93, blue: 0.99, alpha: 1)
            }
        )
        static let formBackgroundSecondary = Color(
            uiColor: UIColor { trait in
                trait.userInterfaceStyle == .dark
                    ? UIColor(red: 0.13, green: 0.15, blue: 0.19, alpha: 1)
                    : UIColor(red: 0.93, green: 0.96, blue: 1.0, alpha: 1)
            }
        )

        static let accentBlue = Color(hex: "#3875F2")
        static let accentCyan = Color(hex: "#29B3E3")
        static let deepBlue = Color(hex: "#1F345C")

        static let white = Color.white
        static let black = Color.black
        static let clear = Color.clear

        static let primaryShadow = Color.black.opacity(0.08)
        static let borderWhite = Color.white.opacity(0.28)
        static let borderWhiteSoft = Color.white.opacity(0.26)

        static let badgePassedBackground = Color.secondary.opacity(0.16)
        static let badgeUpcomingBackground = Color.accentColor.opacity(0.14)
        static let presetSelectedBackground = Color.accentColor.opacity(0.12)
        static let presetUnselectedBorder = Color.secondary.opacity(0.25)
    }

    /// Base spacing unit (4).
    /// Use as a multiplier for consistent layout (e.g., Constants.spacing * 4).
    static let spacing: CGFloat = 4
}

extension Color {
    /// Initializes a Color from a hex string.
    /// - Parameter hex: A string in formats like "#RRGGBB" or "RRGGBB".
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
