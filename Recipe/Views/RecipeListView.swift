//
//  RecipeListView.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import SwiftUI

// MARK: - RecipeListView
struct RecipeListView: View {
    @EnvironmentObject var appDependencies: AppDependencies
    @StateObject private var viewModel: RecipeListViewModel

    init() {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(dependencies: AppDependencies()))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ErrorMessageView(errorMessage: viewModel.errorMessage)
                
                if viewModel.isLoading {
                    LoadingIndicator()
                } else {
                    RecipeList(viewModel: viewModel)
                }
            }
            .navigationTitle("Recipes")
            .refreshable {
                Task {
                    await viewModel.loadRecipes()
                }
            }
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
}

// MARK: - ErrorMessageView
struct ErrorMessageView: View {
    let errorMessage: String?
    
    var body: some View {
        if let errorMessage = errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
    }
}

// MARK: - LoadingIndicator
struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(2)
            .padding()
    }
}

// MARK: - RecipeList
struct RecipeList: View {
    @ObservedObject var viewModel: RecipeListViewModel
    @EnvironmentObject var appDependencies: AppDependencies
    
    var body: some View {
        List(viewModel.recipes) { recipe in
            RecipeRow(
                recipe: recipe,
                imageMemoryCacheManager: appDependencies.imageMemoryCache,
                imageDiskCacheManager: appDependencies.imageDiskCache
            )
        }
        .listStyle(PlainListStyle())
    }
}

// MARK: - RecipeRow
struct RecipeRow: View {
    let recipe: Recipe
    let imageMemoryCacheManager: MemoryCache
    let imageDiskCacheManager: DiskCache

    var body: some View {
        HStack {
            CachedAsyncImage(url: recipe.photoURLSmall)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    RecipeListView()
        .environmentObject(AppDependencies()) // Inject dependencies in preview
}
