import SwiftUI

struct CreateProfileView: View {
    @EnvironmentObject var store: PortfolioStore
    @EnvironmentObject var session: SessionManager

    @State private var name = ""
    @State private var tagline = ""
    @State private var instagram = ""
    @State private var email = ""
    @State private var bio = ""
    @State private var errorText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // ✅ Logo first (center)
                    Image(systemName: "camera.aperture")
                        .font(.system(size: 54, weight: .semibold))
                        .padding(.top, 14)

                    // ✅ Center aligned bold title only
                    Text("Create Profile")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    VStack(spacing: 12) {
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(.roundedBorder)

                        TextField("Tagline (e.g., Photographer • Videographer)", text: $tagline)
                            .textFieldStyle(.roundedBorder)

                        TextField("Instagram (optional)", text: $instagram)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textFieldStyle(.roundedBorder)

                        TextField("Email (optional)", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textFieldStyle(.roundedBorder)

                        // Bio with placeholder inside the box
                        ZStack(alignment: .topLeading) {
                            if bio.isEmpty {
                                Text("Write a short bio about your work...")
                                    .foregroundColor(.gray.opacity(0.55))
                                    .padding(.top, 10)
                                    .padding(.leading, 6)
                            }
                            TextEditor(text: $bio)
                                .frame(height: 120)
                                .padding(4)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.25))
                        )

                        if !errorText.isEmpty {
                            Text(errorText)
                                .foregroundStyle(.red)
                                .font(.footnote)
                        }

                        Button {
                            let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
                            if n.isEmpty {
                                errorText = "Name is required."
                                return
                            }

                            store.profile = UserProfile(
                                displayName: n,
                                tagline: tagline.isEmpty ? "Photographer" : tagline,
                                bio: bio.isEmpty ? "Portfolio owner." : bio,
                                instagram: instagram,
                                email: email
                            )
                            store.save()
                            session.markProfileCompleted()
                        } label: {
                            Text("Continue to Home")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.top, 6)
                    }
                    .padding(.top, 6)

                }
                .padding()
            }
        }
        .onAppear {
            // ✅ Always empty for new profile creation
            name = ""
            tagline = ""
            instagram = ""
            email = ""
            bio = ""
            errorText = ""
        }
    }
}
