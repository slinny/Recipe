//
//  RecipeImageCacheManagerProtocol.swift
//  Recipe
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
import SwiftUI

protocol ImageCacheManager {
    /// Loads an image from a URL, either from cache or by downloading it if not available in cache.
    /// - Parameter url: The URL string for the image.
    /// - Returns: The image if found (from cache or downloaded), or `nil` if not found or on error.
    func loadImage(from url: String) async -> UIImage?
    
    /// Explicitly caches an image for a given key.
    /// - Parameters:
    ///   - image: The image to cache.
    ///   - key: The unique key to associate with the cached image.
    func cacheImage(_ image: UIImage, for key: String) async
    
    /// Clears the image cache (both memory and disk).
    func clearCache()
    
    /// Retrieves an image from the cache based on a key.
    /// - Parameter key: The key associated with the cached image.
    /// - Returns: The cached image if available; otherwise, `nil`.
    func getCachedImage(forKey key: String) -> UIImage?
    
    /// Returns the current disk cache size.
    /// - Returns: The total disk cache size in bytes.
    func getCacheSize() -> Int
}
