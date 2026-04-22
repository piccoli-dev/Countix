import PhotosUI
import SwiftUI
import UIKit

struct EventFormView: View {
    private enum FormStep {
        case details
        case preview
    }

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EventFormViewModel
    @State private var formStep: FormStep = .details
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingDeleteAlert = false

    let existingEvent: Event?
    let onSave: (EventDraft) -> Void
    let onDelete: (() -> Void)?

    init(
        existingEvent: Event? = nil,
        onSave: @escaping (EventDraft) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        self.existingEvent = existingEvent
        self.onSave = onSave
        self.onDelete = onDelete
        _viewModel = StateObject(wrappedValue: EventFormViewModel(event: existingEvent))
    }

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
                        if formStep == .details {
                            introCard
                            formCard
                        } else {
                            previewStep
                        }
                    }
                    .padding(Constants.spacing * 5)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if formStep == .details {
                        Button("Cancel") {
                            dismiss()
                        }
                    } else {
                        Button("Back") {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                formStep = .details
                            }
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(trailingActionTitle) {
                        if formStep == .details {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                formStep = .preview
                            }
                        } else {
                            onSave(viewModel.makeDraft())
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                guard let newItem,
                      let data = try? await newItem.loadTransferable(type: Data.self) else {
                    return
                }

                await MainActor.run {
                    viewModel.backgroundImageData = data
                }
            }
        }
        .alert("Delete Event?", isPresented: $isShowingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete?()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This event will be permanently removed.")
        }
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: Constants.spacing * 2.5) {
            Text(existingEvent == nil ? "Design a new countdown" : "Refine your countdown")
                .font(.title2.weight(.bold))

            Text("Set title, date, time and display mode. Then set colors and optional image in preview before saving.")
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
        VStack(alignment: .leading, spacing: 16) {
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

    private var previewStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Widget Preview")
                .font(.title3.weight(.bold))

            Text("Choose colors and optional image, then save.")
                .font(.body)
                .foregroundStyle(.secondary)

            previewStyleCard
            widgetPreviewCard

            if existingEvent != nil, onDelete != nil {
                Button(role: .destructive) {
                    isShowingDeleteAlert = true
                } label: {
                    Label("Delete Event", systemImage: "trash")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .strokeBorder(.white.opacity(0.26), lineWidth: 1)
                )
        )
    }

    private var previewStyleCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            fieldContainer(title: "Color Options") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(EventGradientPreset.allCases) { preset in
                            gradientPresetButton(for: preset)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }

            fieldContainer(title: "Background Image (Optional)") {
                VStack(alignment: .leading, spacing: 12) {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Choose Image", systemImage: "photo.on.rectangle")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(.thinMaterial, in: Capsule())
                    }

                    if let imageData = viewModel.backgroundImageData,
                       let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 148)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                        Button(role: .destructive) {
                            viewModel.backgroundImageData = nil
                            selectedPhotoItem = nil
                        } label: {
                            Label("Remove Image", systemImage: "trash")
                                .font(.subheadline.weight(.semibold))
                        }
                    } else {
                        Text("No image selected")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func gradientPresetButton(for preset: EventGradientPreset) -> some View {
        let isSelected = viewModel.gradientPreset == preset

        return Button {
            viewModel.gradientPreset = preset
        } label: {
            HStack(spacing: 8) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: preset.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 20, height: 20)

                Text(preset.title)
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.12) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        isSelected ? Color.accentColor : Color.secondary.opacity(0.25),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var widgetPreviewCard: some View {
        let draft = viewModel.makeDraft()

        return ZStack {
            LinearGradient(
                colors: draft.gradientPreset.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            widgetRightImageOverlay(imageData: draft.backgroundImageData)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(draft.title)
                            .font(.headline.weight(.semibold))
                            .lineLimit(2)

                        Text("\(DateFormatting.eventDate.string(from: draft.eventDate)) • \(DateFormatting.eventTime.string(from: draft.eventDate))")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.78))
                            .lineLimit(1)
                    }

                    Spacer()

                    Text(draft.displayMode.shortLabel)
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.16), in: Capsule())
                }

                Spacer(minLength: 0)

                Text(CountdownFormatter.countdownText(to: draft.eventDate, mode: draft.displayMode, now: .now))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(.white)
            .padding(16)
        }
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func widgetRightImageOverlay(imageData: Data?) -> some View {
        Group {
            if let imageData,
               let image = UIImage(data: imageData) {
                HStack(spacing: 0) {
                    Spacer(minLength: 0)

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                colors: [Color.clear, Color.black.opacity(0.45)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .mask(
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        LinearGradient(
                            colors: [Color.clear, Color.white],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 190)
                    }
                )
                .opacity(0.92)
            }
        }
    }

    private func fieldContainer<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline.weight(.semibold))
            content()
        }
    }

    private var navigationTitle: String {
        if formStep == .preview {
            return "Preview"
        }
        return existingEvent == nil ? "New Event" : "Edit Event"
    }

    private var trailingActionTitle: String {
        if formStep == .details {
            return "Preview"
        }
        return existingEvent == nil ? "Save" : "Update"
    }
}

struct EventFormView_Previews: PreviewProvider {
    static var previews: some View {
        EventFormView(onSave: { _ in })
    }
}
