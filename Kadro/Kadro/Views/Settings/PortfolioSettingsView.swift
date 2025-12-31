import SwiftUI

struct PortfolioSettingsView: View {
    @AppStorage("showOnlyFeaturedOnHome") private var showOnlyFeaturedOnHome: Bool = true
    @AppStorage("hideHiddenAlbumsInPortfolio") private var hideHiddenAlbumsInPortfolio: Bool = true
    @AppStorage("albumSortMode") private var albumSortMode: Int = 0

    var body: some View {
        Form {
            Section("Home Screen") {
                Toggle("Show only Best Works on Home", isOn: $showOnlyFeaturedOnHome)
                Text("If ON, Home will display only Featured albums.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Portfolio Visibility") {
                Toggle("Hide hidden albums (Client Mode)", isOn: $hideHiddenAlbumsInPortfolio)
            }

            Section("Sorting") {
                Picker("Album sorting", selection: $albumSortMode) {
                    Text("Newest first").tag(0)
                    Text("Oldest first").tag(1)
                    Text("A–Z").tag(2)
                }
            }
        }
        .navigationTitle("Portfolio")
    }
}
