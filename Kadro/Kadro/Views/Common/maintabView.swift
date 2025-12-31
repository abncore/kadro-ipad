import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            PortfolioView()
                .tabItem { Label("Portfolio", systemImage: "square.grid.2x2") }

            ManageView()
                .tabItem { Label("Manage", systemImage: "plus.circle") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
