//
//  ContentView.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import SwiftUI

// MARK: - RecipeListView
struct RecipeListView: View {
    
    @StateObject private var viewModel: RecipeListViewModel
    private let urlSessionManager: NetworkSession
    private let recipeDecoder: RecipeParser
    private let imageMemoryCacheManager: MemoryCache
    private let imageDiskCacheManager: DiskCache
    
    init(
        urlSessionManager: NetworkSession,
        recipeDecoder: RecipeParser,
        imageMemoryCacheManager: MemoryCache,
        imageDiskCacheManager: DiskCache
    ) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(
            urlSessionManager: urlSessionManager,
            recipeDecoder: recipeDecoder
        ))
        self.urlSessionManager = urlSessionManager
        self.recipeDecoder = recipeDecoder
        self.imageMemoryCacheManager = imageMemoryCacheManager
        self.imageDiskCacheManager = imageDiskCacheManager
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ErrorMessageView(errorMessage: viewModel.errorMessage)
                
                RecipeList(
                    viewModel: viewModel,
                    urlSessionManager: urlSessionManager,
                    imageMemoryCacheManager: imageMemoryCacheManager,
                    imageDiskCacheManager: imageDiskCacheManager
                )
                
                if viewModel.isLoading {
                    LoadingIndicator()
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                if viewModel.recipes.isEmpty {
                    Task {
                        await viewModel.loadRecipes()
                    }
                }
            }
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
    let viewModel: RecipeListViewModel
    let urlSessionManager: NetworkSession
    let imageMemoryCacheManager:MemoryCache
    let imageDiskCacheManager: DiskCache
    var body: some View {
        List(viewModel.recipes) { recipe in
            RecipeRow(
                recipe: recipe,
                urlSessionManager: urlSessionManager,
                imageMemoryCacheManager: imageMemoryCacheManager,
                imageDiskCacheManager: imageDiskCacheManager
            )
        }
        .listStyle(PlainListStyle())
    }
}

// MARK: - RecipeRow
struct RecipeRow: View {
    let recipe: Recipe
    let urlSessionManager: NetworkSession
    let imageMemoryCacheManager:MemoryCache
    let imageDiskCacheManager: DiskCache
    
    var body: some View {
        HStack {
            CachedAsyncImage(
                url: recipe.photoURLSmall,
                networkSession: urlSessionManager,
                imageMemoryCache: imageMemoryCacheManager,
                imageDiskCache: imageDiskCacheManager
            )
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
    RecipeListView(
        urlSessionManager: RecipeURLSessionManager(),
        recipeDecoder: RecipeDecoder(),
        imageMemoryCacheManager: ImageMemoryCache(),
        imageDiskCacheManager: ImageDiskCache()
    )
}
