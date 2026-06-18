//
//  FeaturesKitDemoApp.swift
//  FeaturesKitDemo
//
//  Created by Fernando Balandran on 6/17/26.
//

import SwiftUI
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
