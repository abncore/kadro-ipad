import SwiftUI
import Combine
import Foundation
import UIKit

final class PortfolioStore: ObservableObject {

    // MARK: - Published Data
    @Published var categories: [Category] = []
    @Published var albums: [Album] = []
    @Published var photos: [PhotoItem] = []
    @Published var profile: UserProfile = UserProfile(
        displayName: "",
        tagline: "",
        bio: "",
        instagram: "",
        email: ""
    )

    // MARK: - App Settings
    @AppStorage("clientModeEnabled") var clientModeEnabled: Bool = false
    @AppStorage("clientPasscode") var clientPasscode: String = "1234"

    // MARK: - Persistence Locations
    private let dataURL: URL

    init() {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.dataURL = doc.appendingPathComponent("portfolio_data.json")
        load()
        // ✅ No seeding (no default categories/albums)
    }

    // MARK: - Categories
    func addCategory(name: String) {
        let cleaned = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        categories.append(Category(name: cleaned))
        save()
    }

    func renameCategory(_ category: Category, newName: String) {
        let cleaned = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        guard let idx = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories[idx].name = cleaned
        save()
    }

    func deleteCategory(_ category: Category) {
        // delete all albums in category + their photos
        let albumIds = albums.filter { $0.categoryId == category.id }.map { $0.id }
        for aid in albumIds {
            deleteAlbumById(aid)
        }

        categories.removeAll { $0.id == category.id }
        save()
    }

    // MARK: - Albums
    func addAlbum(categoryId: UUID,
                  title: String,
                  description: String,
                  location: String = "",
                  date: Date = Date(),
                  isHidden: Bool = false,
                  isFeatured: Bool = false) {

        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }

        let newAlbum = Album(
            categoryId: categoryId,
            title: t,
            description: description,
            date: date,
            location: location,
            coverPhotoId: nil,
            isHidden: isHidden,
            isFeatured: isFeatured
        )

        albums.append(newAlbum)
        save()
    }

    func updateAlbum(_ album: Album) {
        guard let idx = albums.firstIndex(where: { $0.id == album.id }) else { return }
        albums[idx] = album
        save()
    }

    func deleteAlbum(_ album: Album) {
        deleteAlbumById(album.id)
        save()
    }

    private func deleteAlbumById(_ albumId: UUID) {
        // Delete photo files belonging to album
        let toDelete = photos.filter { $0.albumId == albumId }
        for p in toDelete {
            deleteImageFile(filename: p.filename)
        }

        // Remove photo objects
        photos.removeAll { $0.albumId == albumId }

        // Remove album object
        albums.removeAll { $0.id == albumId }
    }

    // MARK: - Photos
    func addPhoto(albumId: UUID, imageData: Data) {
        let filename = "\(UUID().uuidString).jpg"
        saveImageFile(data: imageData, filename: filename)
        photos.append(PhotoItem(albumId: albumId, filename: filename))
        save()
    }

    func deletePhoto(_ photo: PhotoItem) {
        deleteImageFile(filename: photo.filename)
        photos.removeAll { $0.id == photo.id }

        // If this photo was set as cover, remove cover reference
        if let aIdx = albums.firstIndex(where: { $0.coverPhotoId == photo.id }) {
            albums[aIdx].coverPhotoId = nil
        }
        save()
    }

    func toggleFavorite(_ photo: PhotoItem) {
        guard let idx = photos.firstIndex(where: { $0.id == photo.id }) else { return }
        photos[idx].isFavorite.toggle()
        save()
    }

    func setAlbumCover(albumId: UUID, photoId: UUID) {
        guard let idx = albums.firstIndex(where: { $0.id == albumId }) else { return }
        albums[idx].coverPhotoId = photoId
        save()
    }

    // MARK: - Queries
    func albumsForCategory(_ categoryId: UUID) -> [Album] {
        let list = albums.filter { $0.categoryId == categoryId }
        if clientModeEnabled { return list.filter { !$0.isHidden } }
        return list
    }

    func photosForAlbum(_ albumId: UUID) -> [PhotoItem] {
        photos.filter { $0.albumId == albumId }
    }

    func featuredAlbums() -> [Album] {
        let list = albums.filter { $0.isFeatured }
        if clientModeEnabled { return list.filter { !$0.isHidden } }
        return list
    }

    // MARK: - Image Loading
    func loadUIImage(filename: String) -> UIImage? {
        let url = imagesFolder().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }

    // MARK: - File Helpers
    private func imagesFolder() -> URL {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = doc.appendingPathComponent("Images", isDirectory: true)

        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    private func saveImageFile(data: Data, filename: String) {
        let url = imagesFolder().appendingPathComponent(filename)
        do {
            try data.write(to: url)
        } catch {
            print("Save image error:", error)
        }
    }

    private func deleteImageFile(filename: String) {
        let url = imagesFolder().appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    // MARK: - Persistence (JSON)
    private struct Payload: Codable {
        var categories: [Category]
        var albums: [Album]
        var photos: [PhotoItem]
        var profile: UserProfile
    }

    func save() {
        let payload = Payload(
            categories: categories,
            albums: albums,
            photos: photos,
            profile: profile
        )
        do {
            let data = try JSONEncoder().encode(payload)
            try data.write(to: dataURL)
        } catch {
            print("Save error:", error)
        }
    }

    func load() {
        guard FileManager.default.fileExists(atPath: dataURL.path) else { return }
        do {
            let data = try Data(contentsOf: dataURL)
            let payload = try JSONDecoder().decode(Payload.self, from: data)
            categories = payload.categories
            albums = payload.albums
            photos = payload.photos
            profile = payload.profile
        } catch {
            print("Load error:", error)
        }
    }

    // MARK: - Optional (for testing)
    func resetAllData() {
        // delete image files
        for p in photos { deleteImageFile(filename: p.filename) }

        categories = []
        albums = []
        photos = []
        profile = UserProfile(displayName: "", tagline: "", bio: "", instagram: "", email: "")

        // remove JSON file
        try? FileManager.default.removeItem(at: dataURL)
        save()
    }
}
