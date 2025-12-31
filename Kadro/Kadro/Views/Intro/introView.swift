import SwiftUI

struct IntroView: View {
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray.opacity(0.6)],
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()

            GeometryReader { geo in
                let maxCardWidth: CGFloat = 520
                let sidePad = max(20, min(28, geo.size.width * 0.06))
                let cardPad = max(14, min(18, geo.size.width * 0.04))

                VStack(spacing: 18) {
                    Spacer()

                    Image(systemName: "camera.aperture")
                        .font(.system(size: 70, weight: .semibold))
                        .foregroundStyle(.white)

                    Text("Kadro")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.white)

                    Text("A clean, editable iPad portfolio for client meetings.\nAdd albums, import photos, and present offline.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, sidePad)

                    // ✅ Responsive minimal feature card
                    VStack(alignment: .leading, spacing: 10) {
                        FeatureRow(icon: "square.grid.2x2", text: "Create categories & albums")
                        FeatureRow(icon: "photo.on.rectangle", text: "Import photos from Photos / Files")
                        FeatureRow(icon: "lock.fill", text: "Client Mode to hide private albums")
                    }
                    .padding(cardPad)
                    .frame(maxWidth: min(maxCardWidth, geo.size.width - (sidePad * 2)), alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(.white.opacity(0.10), lineWidth: 1)
                            )
                    )

                    Spacer()

                    Button(action: onContinue) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.horizontal, sidePad)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.92))
                .frame(width: 20)

            Text(text)
                .foregroundStyle(.white.opacity(0.92))
                .font(.system(size: 15, weight: .regular))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }
}
