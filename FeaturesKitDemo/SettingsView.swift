import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("baseURL") private var baseURL = "https://your-domain.com"
    @AppStorage("showLimitDisplay") private var showLimitDisplay = false
    @Query(sort: \ServerURL.dateAdded) private var savedURLs: [ServerURL]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddServer = false

    var body: some View {
        Form {
            Section("Active Server") {
                Text(baseURL)
                    .monospaced()
                    .foregroundStyle(.primary)
            }

            Section("Saved Servers") {
                if savedURLs.isEmpty {
                    Text("No saved servers. Tap + to add one.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(savedURLs) { server in
                        Button {
                            baseURL = server.url
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(server.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(server.url)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .monospaced()
                                }
                                Spacer()
                                if server.url == baseURL {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteServers)
                }
            }

            Section("FeaturesKit") {
                Toggle("Show Limit Display", isOn: $showLimitDisplay)
            }

            Section {
                Text("The active server URL is shared across all boards. Only the API key differs per board.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddServer = true
                } label: {
                    Label("Add Server", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddServer) {
            AddServerView()
        }
    }

    private func deleteServers(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(savedURLs[index])
        }
    }
}
