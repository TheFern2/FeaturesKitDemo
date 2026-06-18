import SwiftUI

struct SettingsView: View {
    @AppStorage("baseURL") private var baseURL = "https://your-domain.com"

    var body: some View {
        Form {
            Section("FeaturesKit Server") {
                TextField("Base URL", text: $baseURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                    .monospaced()
            }
            Section {
                Text("This URL is shared across all boards. Only the API key differs per board.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
