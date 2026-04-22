import SwiftUI

struct EventFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EventFormViewModel()

    let onSave: (Event) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(red: 0.93, green: 0.96, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Constants.spacing * 5) {
                        introCard
                        formCard
                    }
                    .padding(Constants.spacing * 5)
                }
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(viewModel.makeEvent())
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: Constants.spacing * 2.5) {
            Text("Design a new countdown")
                .font(.title2.weight(.bold))

            Text("Set a title, pick the date and time, then choose how the countdown should be rendered in the event card.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(Constants.spacing * 5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(.white.opacity(0.26), lineWidth: 1)
                )
        )
    }

    private var formCard: some View {
        VStack {
            fieldContainer(title: "Title") {
                TextField("Conference opening, anniversary, departure...", text: $viewModel.title)
                    .textInputAutocapitalization(.words)
                    .padding(Constants.spacing * 3.5)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            
            
            DatePicker("Event Date", selection: $viewModel.eventDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
            

            fieldContainer(title: "Time") {
                DatePicker("Event Time", selection: $viewModel.eventTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    
            }

            fieldContainer(title: "Display Mode") {
                Picker("Display Mode", selection: $viewModel.displayMode) {
                    ForEach(DisplayMode.allCases) { mode in
                        Label(mode.title, systemImage: mode.symbolName)
                            .tag(mode)
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .padding(Constants.spacing * 5)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .strokeBorder(.white.opacity(0.26), lineWidth: 1)
                )
        )
    }

    private func fieldContainer<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline.weight(.semibold))
            content()
        }
    }
}

struct EventFormView_Previews: PreviewProvider {
    static var previews: some View {
        EventFormView(onSave: { _ in })
    }
}
