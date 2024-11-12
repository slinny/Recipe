//
//  ContentView.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Show error message if there is any
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // List to display recipes
                List(viewModel.recipes) { recipe in
                    HStack {
                        // Using SDWebImage to load images with caching support
                        WebImage(url: URL(string: recipe.photoURLSmall))
                            .onSuccess { image, data, cacheType in
                                // Optionally handle success (e.g., logging or custom processing)
                            }
                            .onFailure { error in
                                // Optionally handle error (e.g., logging or showing an error image)
                            }
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
                .listStyle(PlainListStyle())
                .refreshable {
                    // Refresh recipes when pulled down
                    await viewModel.loadRecipes()
                }
                
                // Show loading indicator while fetching data
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                // Load recipes if not already loaded
                if viewModel.recipes.isEmpty {
                    Task {
                        await viewModel.loadRecipes()
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeListView()
}
