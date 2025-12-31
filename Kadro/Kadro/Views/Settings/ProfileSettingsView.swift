import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var store: PortfolioStore

    @State private var name = ""
    @State private var tagline = ""
    @State private var bio = ""
    @State private var instagram = ""
    @State private var email = ""

    var body: some View {
        Form {
            Section("Identity") {
                TextField("Name", text: $name)
                TextField("Tagline", text: $tagline)
            }

            Section("Contact") {
                TextField("Instagram", text: $instagram)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Bio") {
                TextEditor(text: $bio)
                    .frame(height: 120)
                    .overlay(alignment: .topLeading) {
                        if bio.isEmpty {
                            Text("Write a short bio about your work…")
                                .foregroundColor(.gray.opacity(0.55))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                    }
            }

            Section {
                Button("Save Profile ✅") {
                    store.profile = UserProfile(
                        displayName: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        tagline: tagline,
                        bio: bio,
                        instagram: instagram,
                        email: email
                    )
                    store.save()
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            name = store.profile.displayName
            tagline = store.profile.tagline
            bio = store.profile.bio
            instagram = store.profile.instagram
            email = store.profile.email
        }
    }
}
