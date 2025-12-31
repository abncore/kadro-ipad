import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionManager

    @State private var username = ""
    @State private var password = ""
    @State private var isSignup = false
    @State private var errorText = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer()

                Image(systemName: "camera.aperture")
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundStyle(.white)

                Text("KADRO")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)

                Text(isSignup ? "Create an account" : "Login to your portfolio")
                    .foregroundStyle(.white.opacity(0.7))

                VStack(spacing: 12) {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.white.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(.white.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 24)

                if !errorText.isEmpty {
                    Text(errorText)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }

                Button {
                    errorText = ""
                    let u = username.trimmingCharacters(in: .whitespacesAndNewlines)
                    let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

                    guard !u.isEmpty, !p.isEmpty else {
                        errorText = "Please enter username and password."
                        return
                    }

                    if isSignup {
                        let ok = session.signup(username: u, password: p)
                        if !ok { errorText = "Sign up failed. Try again." }
                        // ✅ RootGateView will automatically move to CreateProfileView
                    } else {
                        let ok = session.login(username: u, password: p)
                        if !ok { errorText = "Invalid login details." }
                        // ✅ RootGateView will automatically move to Home/CreateProfile
                    }
                } label: {
                    Text(isSignup ? "Sign Up" : "Login")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
                .padding(.top, 6)

                Button {
                    isSignup.toggle()
                    errorText = ""
                } label: {
                    Text(isSignup ? "Already have an account? Login" : "New here? Sign Up")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()
            }
        }
    }
}
