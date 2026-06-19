import SwiftData
import Foundation

@Model
final class ServerURL {
    var name: String
    var url: String
    var dateAdded: Date

    init(name: String, url: String, dateAdded: Date = .now) {
        self.name = name
        self.url = url
        self.dateAdded = dateAdded
    }
}
