import SwiftUI

struct EmptyStateView: View {
    let selectedDate: Date

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text(verbatim: L10n.tr("No events for %@", DateFormatting.eventDate.string(from: selectedDate)))
                    .font(.title3.weight(.semibold))

                Text("Pick another day from the calendar or create a new event to start your countdown collection.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                )
        )
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(selectedDate: .now)
            .padding()
            .background(Color(.systemGroupedBackground))
    }
}
