import SwiftUI

struct DataSettingsView: View {
    @EnvironmentObject var store: PortfolioStore
    @EnvironmentObject var session: SessionManager

    @State private var showResetConfirm = false

    var body: some View {
        Form {
            Section("Storage") {
                Text("All data is stored offline on this iPad.")
                    .foregroundStyle(.secondary)

                Button("Reset portfolio data (delete albums/photos)", role: .destructive) {
                    showResetConfirm = true
                }
            }

            Section("Account") {
                Button("Reset account (remove login + profile)", role: .destructive) {
                    session.resetAll()
                    store.resetAllData()
                }
            }
        }
        .navigationTitle("Data")
        .confirmationDialog("Are you sure?", isPresented: $showResetConfirm) {
            Button("Delete all portfolio data", role: .destructive) {
                store.resetAllData()
            }
        } message: {
            Text("This will remove categories, albums and photos from this device.")
        }
    }
}
