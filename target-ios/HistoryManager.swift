import Foundation
import Combine

struct HistoryEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let code: String
    let name: String
    let date: Date
    let imageName: String

    init(code: String, name: String, imageName: String, date: Date = Date()) {
        self.id = UUID()
        self.code = code
        self.name = name
        self.imageName = imageName
        self.date = date
    }
}

class HistoryManager: ObservableObject {
    @Published private(set) var entries: [HistoryEntry] = []
    private let key = "history_entries"

    static let shared = HistoryManager()

    private init() {
        load()
    }

    func addEntry(code: String, name: String, imageName: String) {
        // Only add if the last entry is different
        if entries.first?.code != code {
            let entry = HistoryEntry(code: code, name: name, imageName: imageName)
            entries.insert(entry, at: 0)
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            entries = decoded
        }
    }

    func clear() {
        entries = []
        save()
    }
}

class WishlistManager: ObservableObject {
    @Published private(set) var codes: Set<String> = []
    private let key = "wishlist_codes"
    static let shared = WishlistManager()
    private init() {
        load()
    }
    func toggle(code: String) {
        if codes.contains(code) {
            codes.remove(code)
        } else {
            codes.insert(code)
        }
        save()
    }
    func isInWishlist(code: String) -> Bool {
        codes.contains(code)
    }
    private func save() {
        UserDefaults.standard.set(Array(codes), forKey: key)
    }
    private func load() {
        if let arr = UserDefaults.standard.array(forKey: key) as? [String] {
            codes = Set(arr)
        }
    }
}
