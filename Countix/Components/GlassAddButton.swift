import SwiftUI

struct GlassAddButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Constants.spacing * 3) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.22))
                        .frame(width: 38, height: 38)

                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }

                Text("Add New Event")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, Constants.spacing * 4.5)
            .padding(.vertical, Constants.spacing * 3.5)
            .background {
                ZStack {
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)

                    Capsule(style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.22, green: 0.46, blue: 0.95).opacity(0.72),
                                    Color(red: 0.16, green: 0.70, blue: 0.89).opacity(0.58),
                                    Color.white.opacity(0.10)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Capsule(style: .continuous)
                        .strokeBorder(.white.opacity(0.28), lineWidth: 1)
                }
                .shadow(color: Color.black.opacity(0.18), radius: 24, y: 14)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add New Event")
    }
}

struct GlassAddButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.20, blue: 0.36),
                    Color(red: 0.26, green: 0.45, blue: 0.68)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            GlassAddButton { }
                .padding()
        }
    }
}
