//
//  RecipeImageCacheManager.swift
//  Recipe
//
//  Created by Siran Li on 11/10/24.
//

import SDWebImage

/// Singleton manager for handling image caching operations, utilizing SDWebImage for optimized disk and memory caching.
class RecipeImageCacheManager: ImageCacheManager {
    
    static let shared = RecipeImageCacheManager()
    private let imageCache: SDImageCache
    
    private init() {
        imageCache = SDImageCache(namespace: "RecipeImageCache")
        configureCache()
    }
    
    /// Configures cache properties, including memory storage and disk size limits.
    private func configureCache() {
        imageCache.config.shouldCacheImagesInMemory = true
        imageCache.config.shouldUseWeakMemoryCache = false
        imageCache.config.maxDiskSize = 50 * 1024 * 1024 // 50 MB
    }
    
    /// Loads an image from a URL, either from cache or by downloading it if not available in cache.
    /// - Parameters:
    ///   - urlString: The URL string for the image.
    ///   - completion: Completion handler providing the loaded image.
    func loadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        // Return cached image if available
        if let cachedImage = imageCache.imageFromDiskCache(forKey: urlString) {
            return cachedImage
        }
        
        // Otherwise, download and cache the image
        return await downloadImage(from: url, cacheKey: urlString)
    }
    
    /// Downloads an image from a URL and caches it on completion.
    /// - Parameters:
    ///   - url: The image URL.
    ///   - cacheKey: The key under which the image should be cached.
    ///   - completion: Completion handler providing the downloaded image.
    private func downloadImage(from url: URL, cacheKey: String) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            SDWebImageManager.shared.loadImage(
                with: url,
                options: .highPriority,
                progress: nil
            ) { [weak self] image, _, error, _, _, _ in
                guard let self = self, let image = image, error == nil else {
                    continuation.resume(returning: nil)
                    return
                }
                
                // Cache downloaded image
                Task {
                    await self.cacheImage(image, for: cacheKey)
                    continuation.resume(returning: image)
                }
            }
        }
    }
    
    /// Explicitly caches an image for a given key.
    /// - Parameters:
    ///   - image: The image to cache.
    ///   - key: The unique key to associate with the cached image.
    func cacheImage(_ image: UIImage, for key: String) async {
        await withCheckedContinuation { continuation in
            imageCache.store(image, forKey: key, toDisk: true) {
                continuation.resume()
            }
        }
    }
    
    /// Clears the image cache (both memory and disk).
    func clearCache() {
        imageCache.clear(with: .all, completion: nil)
    }
    
    /// Retrieves an image from the cache based on a key.
    /// - Parameter key: The key associated with the cached image.
    /// - Returns: The cached image if available; otherwise, `nil`.
    func getCachedImage(forKey key: String) -> UIImage? {
        return imageCache.imageFromDiskCache(forKey: key)
    }
    
    /// Returns the current disk cache size.
    /// - Returns: The total disk cache size in bytes.
    func getCacheSize() -> Int {
        return Int(imageCache.totalDiskSize())
    }
}
