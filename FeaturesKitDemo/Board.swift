import SwiftData
import Foundation

@Model
final class Board {
    var name: String
    var apiKey: String
    var dateAdded: Date

    init(name: String, apiKey: String, dateAdded: Date = .now) {
        self.name = name
        self.apiKey = apiKey
        self.dateAdded = dateAdded
    }
}
