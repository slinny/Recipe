//
//  RecipeApp.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import SwiftUI

@main
struct RecipeApp: App {
    let urlSessionManager: NetworkSession = RecipeURLSessionManager()
    let dataDecoder: DataParser = DataDecoder()
    let imageDiskCache: DiskCache = ImageDiskCache()
    let imageMemoryCache: MemoryCache = ImageMemoryCache()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(
                urlSessionManager: urlSessionManager,
                dataDecoder: dataDecoder,
                imageMemoryCacheManager: imageMemoryCache,
                imageDiskCacheManager: imageDiskCache
            )
        }
    }
}
