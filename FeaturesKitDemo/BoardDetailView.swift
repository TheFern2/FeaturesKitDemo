import SwiftUI
import FeaturesKit

struct BoardDetailView: View {
    let board: Board
    @AppStorage("baseURL") private var baseURL = "https://your-domain.com"

    var body: some View {
        FeaturesKit(board.apiKey, baseURL: baseURL)
    }
}
