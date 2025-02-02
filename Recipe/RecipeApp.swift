//
//  RecipeApp.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import SwiftUI

@main
struct RecipeApp: App {
    @StateObject private var appDependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(dependencies: appDependencies)
        }
    }
}
