import SwiftUI
import UIKit

struct EventCardView: View {
    let event: Event

    var body: some View {
        TimelineView(.periodic(from: .now, by: event.displayMode.refreshInterval)) { context in
            let countdown = CountdownFormatter.countdownText(to: event.eventDate, mode: event.displayMode, now: context.date)
            let isPassed = event.eventDate < context.date
            CountdownCardContentView(
                title: event.title,
                dateTimeText: "\(DateFormatting.eventDate.string(from: event.eventDate)) • \(DateFormatting.eventTime.string(from: event.eventDate))",
                modeText: event.displayMode.title,
                modeSymbol: event.displayMode.symbolName,
                countdownText: countdown,
                statusText: isPassed ? L10n.tr("Passed") : L10n.tr("Upcoming"),
                isPassed: isPassed,
                primaryTextColor: .white,
                secondaryTextColor: .white,
                modeTextColor: .white,
                badgePassedBackground: Constants.colors.badgePassedBackground,
                badgeUpcomingBackground: Constants.colors.badgeUpcomingBackground,
                badgeTextColor: isPassed ? .secondary : Color.accentColor
            )
            .padding()
            .background(CountdownCardBackgroundLayer(
                fileName: event.backgroundImageFileName,
                colors: event.gradientPreset.colors,
                resolveImage: EventBackgroundImageStore.image(for:)
            ))
            .clipped()
        }
    }
}

private enum EventBackgroundImageStore {
    private static let cache = NSCache<NSString, UIImage>()

    static func image(for fileName: String?) -> UIImage? {
        guard let fileName else {
            return nil
        }

        if let cached = cache.object(forKey: fileName as NSString) {
            return cached
        }

        guard let loaded = AppGroup.loadEventBackgroundImage(fileName: fileName) ?? UIImage(named: fileName) else {
            return nil
        }

        cache.setObject(loaded, forKey: fileName as NSString)
        return loaded
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView(
            event: Event(
                title: "Product Launch",
                eventDate: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 12, to: .now)!,
                displayMode: .full,
                backgroundImageFileName: "japan"
            )
        )
    }
}
