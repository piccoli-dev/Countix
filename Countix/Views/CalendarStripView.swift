import SwiftUI

struct CalendarStripView: View {
    @Binding var selectedDate: Date
    let events: [Event]
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onToday: () -> Void

    private let calendar = Calendar.autoupdatingCurrent
    private let columns = Array(repeating: GridItem(.flexible(), spacing: Constants.spacing * 2), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing * 4.5) {
            header
            weekdayHeader
            monthGrid
        }
        .padding(Constants.spacing * 4.5)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .strokeBorder(.white.opacity(0.36), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 16, y: 10)
        )
    }
    
    private var header: some View {
        HStack(spacing: Constants.spacing) {
            
            Text(DateFormatting.monthTitle.string(from: selectedDate))
                .font(.title3.weight(.semibold))
            

            HStack(spacing: Constants.spacing * 2.5) {
                Spacer()
                Button(action: onPreviousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            LinearGradient(
                                colors: [Constants.colors.purple.opacity(0.9), Constants.colors.peach.opacity(0.85)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: Circle()
                        )
                }
                .buttonStyle(.plain)

                Button(L10n.tr("Today"), action: onToday)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, Constants.spacing * 3.5)
                    .padding(.vertical, Constants.spacing * 2.25)
                    .background(
                        LinearGradient(
                            colors: [Constants.colors.purple.opacity(0.9), Constants.colors.peach.opacity(0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: Capsule()
                    )

                Button(action: onNextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            LinearGradient(
                                colors: [Constants.colors.purple.opacity(0.9), Constants.colors.peach.opacity(0.85)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: Circle()
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: Constants.spacing * 2.5) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var monthGrid: some View {
        LazyVGrid(columns: columns, spacing: Constants.spacing * 2.5) {
            ForEach(monthCells) { cell in
                if let date = cell.date {
                    dayCell(for: date)
                } else {
                    Color.clear
                        .frame(height: 52)
                }
            }
        }
    }

    private func dayCell(for date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)
        let hasEvents = events.contains { calendar.isDate($0.eventDate, inSameDayAs: date) }

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                selectedDate = calendar.startOfDay(for: date)
            }
        } label: {
            VStack(spacing: Constants.spacing * 1.5) {
                Text(DateFormatting.dayNumber.string(from: date))
                    .font(.body.weight(.bold))
                    .foregroundStyle(isSelected ? .white : .primary)

                ZStack {
                    Circle()
                        .fill(hasEvents ? Constants.colors.purple : Color.clear)
                        .frame(width: 6, height: 6)

                    if isToday && !isSelected {
                        Circle()
                            .strokeBorder(Constants.colors.peach.opacity(0.75), lineWidth: 1.5)
                            .frame(width: 12, height: 12)
                    }
                }
                .frame(height: Constants.spacing * 3)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(isSelected ? AnyShapeStyle(selectedBackground) : AnyShapeStyle(.thinMaterial))

                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(borderColor(isSelected: isSelected, isToday: isToday), lineWidth: isSelected || isToday ? 1.2 : 0.8)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var selectedBackground: LinearGradient {
        LinearGradient(
            colors: [
                Constants.colors.purple,
                Constants.colors.peach
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func borderColor(isSelected: Bool, isToday: Bool) -> Color {
        if isSelected {
            return .white.opacity(0.34)
        }

        if isToday {
            return Constants.colors.peach.opacity(0.55)
        }

        return .white.opacity(0.22)
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let firstWeekdayIndex = max(0, calendar.firstWeekday - 1)
        let leading = Array(symbols[firstWeekdayIndex...])
        let trailing = Array(symbols[..<firstWeekdayIndex])
        return leading + trailing
    }

    private var monthCells: [CalendarDayCell] {
        let anchorDate = calendar.startOfDay(for: selectedDate)
        let monthInterval = calendar.dateInterval(of: .month, for: anchorDate)
        let firstDay = monthInterval?.start ?? anchorDate
        let dayRange = calendar.range(of: .day, in: .month, for: firstDay) ?? 1..<2
        let weekday = calendar.component(.weekday, from: firstDay)
        let leadingSlots = (weekday - calendar.firstWeekday + 7) % 7

        let leading = (0..<leadingSlots).map { _ in
            CalendarDayCell(date: nil)
        }

        let days = dayRange.compactMap { day -> CalendarDayCell? in
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) else {
                return nil
            }

            return CalendarDayCell(date: date)
        }

        return leading + days
    }
}

private struct CalendarDayCell: Identifiable {
    let id = UUID()
    let date: Date?
}

struct CalendarStripView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarStripView(
            selectedDate: .constant(.now),
            events: [
                Event(title: "Preview", eventDate: .now, displayMode: .full)
            ],
            onPreviousMonth: { },
            onNextMonth: { },
            onToday: { }
        )
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
