//
//  ContentView.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel: RecipeListViewModel
    
    init(viewModel: RecipeListViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? RecipeListViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                List(viewModel.recipes) { recipe in
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
                .listStyle(PlainListStyle())
                .refreshable {
                    await viewModel.loadRecipes()
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
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

#Preview {
    RecipeListView()
}
