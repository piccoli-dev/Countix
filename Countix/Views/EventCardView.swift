import SwiftUI

struct EventCardView: View {
    let event: Event

    var body: some View {
        TimelineView(.periodic(from: .now, by: event.displayMode.refreshInterval)) { context in
            let countdown = CountdownFormatter.countdownText(to: event.eventDate, mode: event.displayMode, now: context.date)
            let isPassed = event.eventDate < context.date

            VStack(alignment: .leading, spacing: Constants.spacing * 4.5) {
                HStack(alignment: .top, spacing: Constants.spacing * 4) {
                    VStack(alignment: .leading, spacing: Constants.spacing * 1.5) {
                        Text(event.title)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(DateFormatting.eventDate.string(from: event.eventDate))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(DateFormatting.eventTime.string(from: event.eventDate))
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    statusBadge(isPassed: isPassed)
                }

                VStack(alignment: .leading, spacing: Constants.spacing * 2) {
                    Label(event.displayMode.title, systemImage: event.displayMode.symbolName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)

                    Text(countdown)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(isPassed ? .secondary : .primary)
                        .contentTransition(.numericText())
                }
            }
            .padding(Constants.spacing * 5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(.white.opacity(0.28), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 14, y: 10)
    }

    private func statusBadge(isPassed: Bool) -> some View {
        Text(isPassed ? "Passed" : "Upcoming")
            .font(.caption.weight(.bold))
            .padding(.horizontal, Constants.spacing * 3)
            .padding(.vertical, Constants.spacing * 2)
            .background(
                Capsule()
                    .fill(isPassed ? Color.secondary.opacity(0.16) : Color.accentColor.opacity(0.14))
            )
            .foregroundStyle(isPassed ? AnyShapeStyle(.secondary) : AnyShapeStyle(Color.accentColor))
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView(
            event: Event(
                title: "Product Launch",
                eventDate: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 12, to: .now)!,
                displayMode: .full
            )
        )
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
