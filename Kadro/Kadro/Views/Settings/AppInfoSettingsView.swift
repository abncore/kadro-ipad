import SwiftUI

struct AppInfoSettingsView: View {
    var body: some View {
        Form {
            Section("App") {
                HStack {
                    Text("App Name")
                    Spacer()
                    Text("Kadro")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Help") {
                Text("Tip: Add categories and albums from Manage.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("App")
    }
}
