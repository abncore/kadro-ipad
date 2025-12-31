import SwiftUI

@main
struct KadroApp: App {
    @StateObject private var store = PortfolioStore()
    @StateObject private var session = SessionManager()

    var body: some Scene {
        WindowGroup {
            RootGateView()
                .environmentObject(store)
                .environmentObject(session)
        }
    }
}
