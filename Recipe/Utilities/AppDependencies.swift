//
//  AppDependencies.swift
//  Recipe
//
//  Created by Siran Li on 2/1/25.
//

import Foundation

class AppDependencies: ObservableObject {
    let networkSession: NetworkSession
    let imageMemoryCache: MemoryCache
    let imageDiskCache: DiskCache
    let dataDecoder: DataDecoder
    
    init(
        networkSession: NetworkSession = RecipeURLSessionManager(),
        imageMemoryCache: MemoryCache = ImageMemoryCache(),
        imageDiskCache: DiskCache = ImageDiskCache(),
        dataDecoder: DataDecoder = DataDecoder()
    ) {
        self.networkSession = networkSession
        self.imageMemoryCache = imageMemoryCache
        self.imageDiskCache = imageDiskCache
        self.dataDecoder = dataDecoder
    }
}
