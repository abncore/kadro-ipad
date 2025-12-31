import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("themeMode") private var themeMode: Int = 0
    @AppStorage("useLargeCards") private var useLargeCards: Bool = true
    @AppStorage("useCompactSpacing") private var useCompactSpacing: Bool = false

    var body: some View {
        Form {
            Section("Theme") {
                Picker("Appearance", selection: $themeMode) {
                    Text("System").tag(0)
                    Text("Light").tag(1)
                    Text("Dark").tag(2)
                }

                Text("Theme application can be wired in App file later.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Layout") {
                Toggle("Large cards", isOn: $useLargeCards)
                Toggle("Compact spacing", isOn: $useCompactSpacing)
            }
        }
        .navigationTitle("Appearance")
    }
}
