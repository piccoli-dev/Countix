import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Event.eventDate, order: .forward) private var events: [Event]
    @StateObject private var viewModel = HomeViewModel()

    var filteredEvents: [Event] {
        viewModel.filteredEvents(from: events)
    }

    private var syncToken: String {
        events
            .sorted { $0.eventDate < $1.eventDate }
            .map { "\($0.id.uuidString)|\($0.title)|\($0.eventDate.timeIntervalSince1970)|\($0.displayMode.rawValue)" }
            .joined(separator: "::")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        header
                        CalendarStripView(
                            selectedDate: $viewModel.selectedDate,
                            events: events,
                            onPreviousMonth: { viewModel.changeMonth(by: -1) },
                            onNextMonth: { viewModel.changeMonth(by: 1) },
                            onToday: viewModel.jumpToToday
                        )
                        eventsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()

                    GlassAddButton {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.88)) {
                            viewModel.isPresentingForm = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 10)
            }
            .navigationBarHidden(true)
        }
        .task {
            SharedEventStore.save(events: events)
        }
        .onChange(of: syncToken) { _, _ in
            SharedEventStore.save(events: events)
        }
        .sheet(isPresented: $viewModel.isPresentingForm) {
            EventFormView { newEvent in
                modelContext.insert(newEvent)
                try? modelContext.save()
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.97, blue: 1.0),
                Color(red: 0.89, green: 0.93, blue: 0.99),
                Color(.systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: 240, height: 240)
                .blur(radius: 20)
                .offset(x: 80, y: -70)
        }
        .overlay(alignment: .topLeading) {
            Circle()
                .fill(Color.cyan.opacity(0.16))
                .frame(width: 180, height: 180)
                .blur(radius: 20)
                .offset(x: -70, y: -50)
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.title)
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text(viewModel.subtitle)
                .font(.body)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Label("\(events.count) total", systemImage: "clock.badge")
                Label("\(filteredEvents.count) today", systemImage: "calendar")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.secondary)
        }
    }

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Events")
                    .font(.title2.weight(.semibold))

                Spacer()

                Text(DateFormatting.eventDate.string(from: viewModel.selectedDate))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            if filteredEvents.isEmpty {
                EmptyStateView(selectedDate: viewModel.selectedDate)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(filteredEvents) { event in
                        EventCardView(event: event)
                    }
                }
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.9), value: filteredEvents.map(\.id))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .modelContainer(PreviewSampleData.container)
    }
}
