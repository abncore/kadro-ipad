import SwiftUI

struct RootGateView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        if !session.isLoggedIn {
            LoginView()
        } else if !session.hasCompletedProfile {
            CreateProfileView()
        } else {
            MainTabView()
        }
    }
}
