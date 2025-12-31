import SwiftUI

struct ManageView: View {
    @EnvironmentObject var store: PortfolioStore

    @State private var newCategoryName = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // MARK: - Create Category
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Create Category")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        TextField("Category name (e.g., Cars)", text: $newCategoryName)
                            .textFieldStyle(.roundedBorder)

                        Button {
                            let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !name.isEmpty else { return }
                            store.addCategory(name: name)
                            newCategoryName = ""
                        } label: {
                            HStack {
                                Text("Add Category")
                                    .font(.system(size: 16, weight: .semibold))
                                Spacer()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // MARK: - Create Album
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Create Album")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if store.categories.isEmpty {
                            Text("Create a category first to add albums.")
                                .foregroundStyle(.secondary.opacity(0.7))
                                .font(.callout)
                        } else {
                            NavigationLink {
                                AddAlbumView()
                            } label: {
                                HStack {
                                    Text("Add New Album")
                                        .font(.system(size: 16, weight: .semibold))
                                    Spacer()
                                }
                                .padding()
                                .background(Color.black.opacity(0.9))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // MARK: - Categories List
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Categories")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if store.categories.isEmpty {
                            Text("No categories created yet.")
                                .foregroundStyle(.secondary.opacity(0.7))
                        } else {
                            ForEach(store.categories) { category in
                                HStack {
                                    Text(category.name)
                                    Spacer()
                                    Button(role: .destructive) {
                                        store.deleteCategory(category)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                                .padding(.vertical, 6)
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // MARK: - Albums List
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Albums")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if store.albums.isEmpty {
                            Text("No albums created yet.")
                                .foregroundStyle(.secondary.opacity(0.7))
                        } else {
                            ForEach(store.albums) { album in
                                NavigationLink {
                                    EditAlbumView(album: album)
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(album.title)
                                            .font(.headline)

                                        if !album.description.isEmpty {
                                            Text(album.description)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 6)
                                }
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            .navigationTitle("Manage")
        }
    }
}
