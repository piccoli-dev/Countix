import SwiftUI

struct CountdownCardContentView: View {
    private let baseSpacing: CGFloat = 4

    let title: String
    let dateTimeText: String
    let modeText: String
    let modeSymbol: String
    let countdownText: String
    let statusText: String
    let isPassed: Bool
    let primaryTextColor: Color
    let secondaryTextColor: Color
    let modeTextColor: Color
    let badgePassedBackground: Color
    let badgeUpcomingBackground: Color
    let badgeTextColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: baseSpacing * 4) {
                VStack(alignment: .leading, spacing: baseSpacing * 1.5) {
                    Text(title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(primaryTextColor)
                        .lineLimit(2)

                    Text(dateTimeText)
                        .font(.subheadline)
                        .foregroundStyle(secondaryTextColor)
                        .lineLimit(1)
                }

                Spacer()

                Text(statusText)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, baseSpacing * 3)
                    .padding(.vertical, baseSpacing * 2)
                    .background(
                        Capsule()
                            .fill(isPassed ? badgePassedBackground : badgeUpcomingBackground)
                    )
                    .foregroundStyle(badgeTextColor)
            }

            VStack(alignment: .leading, spacing: baseSpacing * 2) {
                Label(modeText, systemImage: modeSymbol)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(modeTextColor)

                Text(countdownText)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(isPassed ? secondaryTextColor : primaryTextColor)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
        }
    }
}
