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
    private let dataDecoder: DataParser
    private let imageMemoryCacheManager: MemoryCache
    private let imageDiskCacheManager: DiskCache
    
    init(
        urlSessionManager: NetworkSession,
        dataDecoder: DataParser,
        imageMemoryCacheManager: MemoryCache,
        imageDiskCacheManager: DiskCache
    ) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(
            urlSessionManager: urlSessionManager,
            dataDecoder: dataDecoder
        ))
        self.urlSessionManager = urlSessionManager
        self.dataDecoder = dataDecoder
        self.imageMemoryCacheManager = imageMemoryCacheManager
        self.imageDiskCacheManager = imageDiskCacheManager
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ErrorMessageView(errorMessage: viewModel.errorMessage)
                
                if viewModel.isLoading {
                    LoadingIndicator()
                }
                
                RecipeList(
                    viewModel: viewModel,
                    urlSessionManager: urlSessionManager,
                    imageMemoryCacheManager: imageMemoryCacheManager,
                    imageDiskCacheManager: imageDiskCacheManager
                )
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
        dataDecoder: DataDecoder(),
        imageMemoryCacheManager: ImageMemoryCache(),
        imageDiskCacheManager: ImageDiskCache()
    )
}
