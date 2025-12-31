import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var store: PortfolioStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {

                    if store.categories.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("No Categories Yet")
                                .font(.title2.bold())

                            Text("Go to Manage and create a category (example: Cars, Weddings, Portraits).")
                                .foregroundStyle(.secondary.opacity(0.6))
                                .font(.callout)

                            Text("Then create an album under that category.")
                                .foregroundStyle(.secondary.opacity(0.6))
                                .font(.callout)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                        .padding(.top, 10)
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories")
                                .font(.title2.bold())
                                .padding(.horizontal)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 12)], spacing: 12) {
                                ForEach(store.categories) { cat in
                                    NavigationLink {
                                        CategoryDetailView(category: cat)
                                    } label: {
                                        CategoryCard(category: cat)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 8)
                    }

                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Portfolio")
        }
    }
}
