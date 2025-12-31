import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: PortfolioStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {

                    profileCard
                        .padding(.top, 10)

                    bestWorksSection

                    contactCard

                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Your Portfolio")
        }
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.profile.displayName.isEmpty ? "Your Name" : store.profile.displayName)
                .font(.title.bold())

            if !store.profile.tagline.isEmpty {
                Text(store.profile.tagline)
                    .foregroundStyle(.secondary)
            }

            if !store.profile.bio.isEmpty {
                Text(store.profile.bio)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true) // ✅ responsive text
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) // ✅ responsive layout
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var bestWorksSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Best Works ⭐")
                .font(.title2.bold())

            let featured = store.featuredAlbums()

            if featured.isEmpty {
                Text("No Best Works yet. Go to Manage → mark an album as Featured.")
                    .foregroundStyle(.secondary.opacity(0.7))
                    .font(.callout)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(featured) { album in
                            NavigationLink {
                                AlbumDetailView(album: album)
                            } label: {
                                AlbumCard(album: album)
                                    .frame(width: 280)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var contactCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Contact")
                .font(.title3.bold())

            if !store.profile.instagram.isEmpty {
                HStack {
                    Image(systemName: "camera")
                    Text(store.profile.instagram)
                }
                .foregroundStyle(.secondary)
            }

            if !store.profile.email.isEmpty {
                HStack {
                    Image(systemName: "envelope")
                    Text(store.profile.email)
                }
                .foregroundStyle(.secondary)
            }

            if store.profile.instagram.isEmpty && store.profile.email.isEmpty {
                Text("Add Instagram / Email in Settings.")
                    .foregroundStyle(.secondary.opacity(0.7))
                    .font(.callout)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
