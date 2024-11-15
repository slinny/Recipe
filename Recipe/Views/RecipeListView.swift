//
//  ContentView.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - RecipeListView
struct RecipeListView: View {
    @StateObject private var viewModel: RecipeListViewModel
    
    init(viewModel: RecipeListViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? RecipeListViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ErrorMessageView(errorMessage: viewModel.errorMessage)
                
                RecipeList(recipes: viewModel.recipes)
                    .refreshable {
                        await viewModel.loadRecipes()
                    }
                
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

// MARK: - RecipeList
struct RecipeList: View {
    let recipes: [Recipe]
    
    var body: some View {
        List(recipes) { recipe in
            RecipeRow(recipe: recipe)
        }
        .listStyle(PlainListStyle())
    }
}

// MARK: - RecipeRow
struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: recipe.photoURLSmall))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
            
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

// MARK: - LoadingIndicator
struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(2)
            .padding()
    }
}

#Preview {
    RecipeListView()
}
