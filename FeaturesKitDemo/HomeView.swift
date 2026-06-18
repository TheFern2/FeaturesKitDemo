import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Board.dateAdded) private var boards: [Board]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddBoard = false

    var body: some View {
        NavigationStack {
            Group {
                if boards.isEmpty {
                    ContentUnavailableView(
                        "No Boards",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Tap + to add a FeaturesKit board.")
                    )
                } else {
                    List {
                        ForEach(boards) { board in
                            NavigationLink {
                                BoardDetailView(board: board)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(board.name)
                                        .font(.headline)
                                    Text(maskedKey(board.apiKey))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .monospaced()
                                }
                            }
                        }
                        .onDelete(perform: deleteBoards)
                    }
                }
            }
            .navigationTitle("Boards")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddBoard = true
                    } label: {
                        Label("Add Board", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBoard) {
                AddBoardView()
            }
        }
    }

    private func deleteBoards(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(boards[index])
        }
    }

    private func maskedKey(_ key: String) -> String {
        if key.count <= 8 {
            return String(repeating: "*", count: key.count)
        }
        let prefix = key.prefix(4)
        let suffix = key.suffix(4)
        return "\(prefix)...\(suffix)"
    }
}
