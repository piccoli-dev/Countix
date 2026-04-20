import SwiftUI
import WidgetKit

struct CountixWidgetEntry: TimelineEntry {
    let date: Date
    let event: WidgetEventSnapshot?
}

struct CountixWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountixWidgetEntry {
        CountixWidgetEntry(
            date: .now,
            event: WidgetEventSnapshot(
                id: UUID(),
                title: "Summer Break",
                eventDate: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 6, to: .now) ?? .now,
                displayModeRawValue: WidgetDisplayMode.daysOnly.rawValue
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
            LinearGradient(
                colors: [
                    Color(red: 0.14, green: 0.23, blue: 0.41),
                    Color(red: 0.18, green: 0.46, blue: 0.72),
                    Color(red: 0.48, green: 0.74, blue: 0.86)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
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
            displayModeRawValue: WidgetDisplayMode.daysOnly.rawValue
        )
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
            displayModeRawValue: WidgetDisplayMode.full.rawValue
        )
    )
}
