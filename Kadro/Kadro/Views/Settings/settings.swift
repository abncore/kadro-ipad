import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SettingsMainRow(
                        title: "Profile",
                        subtitle: "Name, bio, contact",
                        systemImage: "person.crop.circle"
                    ) { ProfileSettingsView() }

                    SettingsMainRow(
                        title: "Security",
                        subtitle: "Login, lock, client access",
                        systemImage: "lock.shield"
                    ) { SecuritySettingsView() }

                    SettingsMainRow(
                        title: "Portfolio",
                        subtitle: "Best works, sorting, display",
                        systemImage: "photo.on.rectangle.angled"
                    ) { PortfolioSettingsView() }

                    SettingsMainRow(
                        title: "Data",
                        subtitle: "Backup, reset, storage",
                        systemImage: "externaldrive"
                    ) { DataSettingsView() }

                    SettingsMainRow(
                        title: "Appearance",
                        subtitle: "Theme, layout options",
                        systemImage: "paintbrush"
                    ) { AppearanceSettingsView() }

                    SettingsMainRow(
                        title: "App",
                        subtitle: "Version, help, info",
                        systemImage: "gearshape"
                    ) { AppInfoSettingsView() }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
        }
    }
}

private struct SettingsMainRow<Destination: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 34, height: 34)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 6)
        }
    }
}
