//
//  CachedAsyncImage.swift
//  Recipe
//
//  Created by Siran Li on 11/17/24.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: String
    @EnvironmentObject private var dependencies: AppDependencies
    @StateObject private var viewModel: CachedAsyncImageViewModel

    init(url: String) {
        self.url = url
        _viewModel = StateObject(wrappedValue: CachedAsyncImageViewModel(dependencies: AppDependencies()))
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
