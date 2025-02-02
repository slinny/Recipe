//
//  CachedAsyncImage.swift
//  Recipe
//
//  Created by Siran Li on 11/17/24.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: String
    @StateObject private var viewModel: CachedAsyncImageViewModel
    
    init(url: String, dependencies: AppDependencies) {
        self.url = url
        _viewModel = StateObject(wrappedValue: CachedAsyncImageViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.5)
            }
        }
        .task {
            await viewModel.loadImage(from: url)
        }
    }
}

#Preview {
    CachedAsyncImage(url: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", dependencies: AppDependencies())
}
