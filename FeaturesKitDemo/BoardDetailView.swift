import SwiftUI
import FeaturesKit

struct BoardDetailView: View {
    let board: Board
    @AppStorage("baseURL") private var baseURL = "https://your-domain.com"
    @AppStorage("showLimitDisplay") private var showLimitDisplay = false

    var body: some View {
        FeaturesKit(board.apiKey, baseURL: baseURL, showLimitDisplay: showLimitDisplay)
    }
}
