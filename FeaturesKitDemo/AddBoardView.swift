import SwiftUI
import SwiftData

struct AddBoardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var apiKey = ""

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !apiKey.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Board Name") {
                    TextField("My App", text: $name)
                        .textInputAutocapitalization(.words)
                }
                Section("API Key") {
                    TextField("Board API key", text: $apiKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .monospaced()
                }
            }
            .navigationTitle("Add Board")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let board = Board(
                            name: name.trimmingCharacters(in: .whitespaces),
                            apiKey: apiKey.trimmingCharacters(in: .whitespaces)
                        )
                        modelContext.insert(board)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}
