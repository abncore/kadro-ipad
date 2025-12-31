import SwiftUI
import Combine

final class SessionManager: ObservableObject {

    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("hasCompletedProfile") var hasCompletedProfile: Bool = false

    @AppStorage("loginUsername") private var savedUsername: String = ""
    @AppStorage("loginPassword") private var savedPassword: String = ""

    var hasAccount: Bool {
        !savedUsername.isEmpty && !savedPassword.isEmpty
    }

    func login(username: String, password: String) -> Bool {
        let ok = (username == savedUsername && password == savedPassword)
        if ok { isLoggedIn = true }
        return ok
    }

    func signup(username: String, password: String) -> Bool {
        guard !username.isEmpty, !password.isEmpty else { return false }
        savedUsername = username
        savedPassword = password
        isLoggedIn = true
        hasCompletedProfile = false   // ✅ forces Create Profile after signup
        return true
    }

    func markProfileCompleted() {
        hasCompletedProfile = true
    }

    func logout() {
        isLoggedIn = false
        // keep profile completion saved (optional)
    }

    // Optional: reset everything for testing
    func resetAll() {
        savedUsername = ""
        savedPassword = ""
        isLoggedIn = false
        hasCompletedProfile = false
    }
}
