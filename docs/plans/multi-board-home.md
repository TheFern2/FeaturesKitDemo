# Multi-Board FeaturesKit Demo App

Allow users to manage multiple FeaturesKit boards from a home screen. Each board has a unique API key. A shared base URL is configured in settings.

## Phase 0: Documentation Discovery

### Allowed APIs

**FeaturesKit public init** (FeaturesKit.swift:6-14):
```swift
public init(
    _ apiKey: String,
    baseURL: String = "https://your-domain.com",
    userId: String? = nil,
    showSubmitButton: Bool = true
)
```
- Returns a `View` containing a `NavigationStack > RequestListView`
- Each instance is independent (own `@State FeaturesViewModel`)

**SwiftData** (iOS 17+, already available):
- `@Model` macro for persistence classes
- `ModelContainer` configured on the app's WindowGroup via `.modelContainer(for:)`
- `@Query` property wrapper to fetch models in views
- `@Environment(\.modelContext)` for insert/delete

**@AppStorage** (SwiftUI built-in):
- `@AppStorage("key") var value: String = "default"` for UserDefaults-backed state

### Anti-patterns to avoid
- Do NOT wrap FeaturesKit view in another NavigationStack (it creates its own internally). Use `fullScreenCover` to present boards.
- Do NOT use `@Observable` for the Board model; SwiftData `@Model` handles observation.
- Do NOT store the base URL in SwiftData; use `@AppStorage` since it's a single shared setting.

## Phase 1: Board Model and App Setup

### What to implement

1. **Create `Board.swift`** -- SwiftData model for persisted boards:
   ```swift
   import SwiftData

   @Model
   final class Board {
       var name: String
       var apiKey: String
       var dateAdded: Date

       init(name: String, apiKey: String, dateAdded: Date = .now) { ... }
   }
   ```

2. **Update `FeaturesKitDemoApp.swift`** -- Add SwiftData model container:
   ```swift
   import SwiftData

   @main
   struct FeaturesKitDemoApp: App {
       var body: some Scene {
           WindowGroup {
               HomeView()
           }
           .modelContainer(for: Board.self)
       }
   }
   ```

### Files to create/modify
- Create: `FeaturesKitDemo/Board.swift`
- Modify: `FeaturesKitDemo/FeaturesKitDemoApp.swift`

### Verification
- Project builds without errors
- `grep -r "import SwiftData" FeaturesKitDemo/` returns both files

## Phase 2: Home View (Board List)

### What to implement

1. **Create `HomeView.swift`** -- Main screen showing saved boards:
   - `NavigationStack` with title "Boards"
   - `@Query(sort: \Board.dateAdded)` to fetch boards
   - `List` displaying each board (name, truncated API key)
   - Tap a board -> set `selectedBoard` -> present `fullScreenCover` with `BoardDetailView`
   - Swipe to delete boards
   - Toolbar: "+" button to add board, gear icon for settings
   - Empty state when no boards exist

2. **Create `BoardDetailView.swift`** -- Wraps `FeaturesKit` view for a selected board:
   - Reads base URL from `@AppStorage("baseURL")`
   - Renders `FeaturesKit(board.apiKey, baseURL: baseURL)`
   - Overlay toolbar/button to dismiss the fullScreenCover
   - Uses `fullScreenCover` presentation to avoid nested `NavigationStack`

### Files to create
- `FeaturesKitDemo/HomeView.swift`
- `FeaturesKitDemo/BoardDetailView.swift`

### Verification
- App launches to HomeView showing empty state
- Boards appear in list after Phase 3 (add flow)

## Phase 3: Add Board and Settings

### What to implement

1. **Create `AddBoardView.swift`** -- Sheet for adding a new board:
   - Form with two fields: board name (required) and API key (required)
   - "Add" button inserts a new `Board` into model context
   - Dismisses on successful add
   - Validates both fields are non-empty

2. **Create `SettingsView.swift`** -- Settings screen:
   - `@AppStorage("baseURL") var baseURL: String = "https://your-domain.com"`
   - Text field to edit the base URL
   - NavigationStack with title "Settings"

3. **Remove or repurpose `ContentView.swift`** -- No longer needed (HomeView replaces it)

### Files to create
- `FeaturesKitDemo/AddBoardView.swift`
- `FeaturesKitDemo/SettingsView.swift`

### Files to delete
- `FeaturesKitDemo/ContentView.swift`

### Verification
- Tapping "+" in HomeView opens AddBoardView sheet
- Filling in name + API key and tapping Add creates a board in the list
- Tapping gear icon navigates to SettingsView
- Changing base URL persists across app restarts
- Tapping a board opens fullScreenCover with FeaturesKit view using correct apiKey and baseURL
- Deleting a board via swipe removes it from the list

## Phase 4: Final Verification

1. Build the project -- no warnings or errors
2. Verify no nested NavigationStack (FeaturesKit presented via fullScreenCover)
3. Verify SwiftData persistence: add board, kill app, reopen, board still there
4. Verify @AppStorage persistence: change base URL, kill app, reopen, URL retained
5. Verify empty state displays when no boards exist
6. Grep checks:
   - `grep -r "NavigationStack" FeaturesKitDemo/` -- only in HomeView.swift (and SettingsView if using NavigationStack)
   - `grep -r "@Model" FeaturesKitDemo/` -- only in Board.swift
   - `grep -r "fullScreenCover" FeaturesKitDemo/` -- in HomeView.swift
