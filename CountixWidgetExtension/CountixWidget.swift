import SwiftUI
import UIKit
import WidgetKit

struct CountixWidgetEntry: TimelineEntry {
    let date: Date
    let event: WidgetEventSnapshot?
    let previewGradientPreset: WidgetPreviewGradientPreset?

    init(
        date: Date,
        event: WidgetEventSnapshot?,
        previewGradientPreset: WidgetPreviewGradientPreset? = nil
    ) {
        self.date = date
        self.event = event
        self.previewGradientPreset = previewGradientPreset
    }
}

struct CountixWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountixWidgetEntry {
        CountixWidgetEntry(
            date: .now,
            event: WidgetEventSnapshot(
                id: UUID(),
                title: "Summer Break",
                eventDate: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 6, to: .now) ?? .now,
                displayModeRawValue: WidgetDisplayMode.daysOnly.rawValue,
                gradientPresetRawValue: WidgetPreviewGradientPreset.blue.rawValue,
                backgroundImageFileName: nil
            )
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CountixWidgetEntry) -> Void) {
        completion(CountixWidgetEntry(date: .now, event: WidgetSharedEventStore.loadUpcomingEvent()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CountixWidgetEntry>) -> Void) {
        let event = WidgetSharedEventStore.loadUpcomingEvent()
        let entry = CountixWidgetEntry(date: .now, event: event)
        let nextUpdate = Date().addingTimeInterval(
            WidgetCountdownFormatter.refreshInterval(for: event?.displayMode ?? .full)
        )

        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }
}

struct CountixWidgetEntryView: View {
    var entry: CountixWidgetProvider.Entry

    var body: some View {
        ZStack {
            if let event = entry.event {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title)
                                .font(.headline.weight(.semibold))
                                .lineLimit(2)

                            Text("\(WidgetDateFormatting.eventDate.string(from: event.eventDate)) • \(WidgetDateFormatting.eventTime.string(from: event.eventDate))")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.78))
                                .lineLimit(1)
                        }

                        Spacer()

                        Text(event.displayMode.shortLabel)
                            .font(.caption2.weight(.bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(.white.opacity(0.16), in: Capsule())
                    }

                    Spacer(minLength: 0)

                    Text(WidgetCountdownFormatter.countdownText(to: event.eventDate, mode: event.displayMode, now: entry.date))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)

                    Text(WidgetCountdownFormatter.relativeStatus(for: event.eventDate, now: entry.date))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.72))
                }
                .foregroundStyle(.white)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("No Event Selected")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)

                    Text("Open Countix and create an event to show a countdown on your Home Screen.")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.82))
                }
                .padding(18)
            }
        }
        .containerBackground(for: .widget) {
            
            let backgroundImageFileName = entry.event?.backgroundImageFileName
            let colors = (entry.previewGradientPreset ?? entry.event?.gradientPreset ?? .blue).colors
            
            if let backgroundImageFileName = backgroundImageFileName,
                let image = WidgetBackgroundImageStore.image(for: backgroundImageFileName) ?? WidgetPreviewImageStore.image(named: backgroundImageFileName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
            LinearGradient(
                colors: backgroundImageFileName != nil ? [colors[0], .clear] : colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        }
    }
}

enum WidgetPreviewGradientPreset: String, CaseIterable {
    case blue
    case orange
    case green
    case yellow
    case purple
    case black
    case white
    case red
    case lightBlue
    case pink

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
        case .black:
            return [
                Color(red: 0.03, green: 0.03, blue: 0.04),
                Color(red: 0.12, green: 0.12, blue: 0.14),
                Color(red: 0.28, green: 0.28, blue: 0.31)
            ]
        case .white:
            return [
                Color(red: 0.62, green: 0.64, blue: 0.67),
                Color(red: 0.77, green: 0.79, blue: 0.82),
                Color(red: 0.90, green: 0.91, blue: 0.93)
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
}

private enum WidgetPreviewImageStore {
    private static let cache = NSCache<NSString, UIImage>()
    private static let isRunningPreview =
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" ||
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PLAYGROUNDS"] == "1"
    private static let maxPreviewImageDimension: CGFloat = 900

    static func image(named name: String?) -> UIImage? {
        guard isRunningPreview, let name, !name.isEmpty else {
            return nil
        }

        if let assetImage = UIImage(named: name) {
            return normalizedImageForPreview(assetImage)
        }

        if let cached = cache.object(forKey: name as NSString) {
            return cached
        }

        let size = CGSize(width: 900, height: 900)
        let renderer = UIGraphicsImageRenderer(size: size)
        let hash = UInt(bitPattern: name.hashValue)
        let hue1 = CGFloat(hash % 1000) / 1000
        let hue2 = CGFloat((hash / 7) % 1000) / 1000
        let hue3 = CGFloat((hash / 13) % 1000) / 1000

        let image = renderer.image { context in
            let cg = context.cgContext
            let colors = [
                UIColor(hue: hue1, saturation: 0.62, brightness: 0.78, alpha: 1).cgColor,
                UIColor(hue: hue2, saturation: 0.52, brightness: 0.88, alpha: 1).cgColor,
                UIColor(hue: hue3, saturation: 0.40, brightness: 0.94, alpha: 1).cgColor
            ] as CFArray
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors,
                locations: [0, 0.55, 1]
            )!
            cg.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )

            cg.setFillColor(UIColor.white.withAlphaComponent(0.15).cgColor)
            cg.fillEllipse(in: CGRect(x: 490, y: 90, width: 260, height: 260))
            cg.setFillColor(UIColor.white.withAlphaComponent(0.12).cgColor)
            cg.fillEllipse(in: CGRect(x: 560, y: 410, width: 300, height: 300))
            cg.setFillColor(UIColor.white.withAlphaComponent(0.1).cgColor)
            cg.fillEllipse(in: CGRect(x: 460, y: 650, width: 180, height: 180))
        }

        cache.setObject(image, forKey: name as NSString)
        return image
    }

    private static func normalizedImageForPreview(_ image: UIImage) -> UIImage {
        let inputSize = image.size
        let maxSide = max(inputSize.width, inputSize.height)
        guard maxSide > maxPreviewImageDimension else {
            return image
        }

        let scale = maxPreviewImageDimension / maxSide
        let targetSize = CGSize(
            width: max(1, floor(inputSize.width * scale)),
            height: max(1, floor(inputSize.height * scale))
        )
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

private enum WidgetBackgroundImageStore {
    private static let cache = NSCache<NSString, UIImage>()

    static func image(for fileName: String?) -> UIImage? {
        guard let fileName else {
            return nil
        }

        if let cached = cache.object(forKey: fileName as NSString) {
            return cached
        }

        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.piccolidev.Countix") else {
            return nil
        }

        let fileURL = containerURL
            .appendingPathComponent("event-backgrounds", isDirectory: true)
            .appendingPathComponent(fileName)

        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }

        cache.setObject(image, forKey: fileName as NSString)
        return image
    }
}

struct CountixWidget: Widget {
    let kind = "CountixWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountixWidgetProvider()) { entry in
            CountixWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Event Countdown")
        .description("Show the next Countix event on the Home Screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview("Small", as: .systemSmall) {
    CountixWidget()
} timeline: {
    CountixWidgetEntry(
        date: .now,
        event: WidgetEventSnapshot(
            id: UUID(),
            title: "Summer Break",
            eventDate: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 6, to: .now)!,
            displayModeRawValue: WidgetDisplayMode.daysOnly.rawValue,
            gradientPresetRawValue: WidgetPreviewGradientPreset.pink.rawValue,
            backgroundImageFileName: nil
        ),
        previewGradientPreset: .pink
    )
}

#Preview("Medium", as: .systemMedium) {
    CountixWidget()
} timeline: {
    CountixWidgetEntry(
        date: .now,
        event: WidgetEventSnapshot(
            id: UUID(),
            title: "Flight to Tokyo",
            eventDate: Calendar.autoupdatingCurrent.date(byAdding: .hour, value: 18, to: .now)!,
            displayModeRawValue: WidgetDisplayMode.full.rawValue,
            gradientPresetRawValue: WidgetPreviewGradientPreset.pink.rawValue,
            backgroundImageFileName: nil
        ),
        previewGradientPreset: .pink
    )
}
