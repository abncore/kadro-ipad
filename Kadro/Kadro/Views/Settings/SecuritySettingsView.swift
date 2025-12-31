import SwiftUI

struct SecuritySettingsView: View {
    @EnvironmentObject var session: SessionManager

    @AppStorage("clientModeEnabled") private var clientModeEnabled: Bool = false
    @AppStorage("clientPasscode") private var clientPasscode: String = "1234"
    @AppStorage("autoLockMinutes") private var autoLockMinutes: Int = 2

    @State private var newPasscode: String = ""

    var body: some View {
        Form {
            Section("Login") {
                Toggle("Stay logged in", isOn: $session.isLoggedIn)
                    .disabled(true) // logged-in state controlled by session

                Button("Logout", role: .destructive) {
                    session.logout()
                }
            }

            Section("Client Lock") {
                Toggle("Enable Client Mode", isOn: $clientModeEnabled)

                SecureField("New passcode", text: $newPasscode)
                Button("Update passcode") {
                    let p = newPasscode.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !p.isEmpty else { return }
                    clientPasscode = p
                    newPasscode = ""
                }

                Stepper("Auto-lock after \(autoLockMinutes) min", value: $autoLockMinutes, in: 1...10)
                Text("Auto-lock is a future upgrade (optional).")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Security")
    }
}
