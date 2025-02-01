//
//  CachedAsyncImageViewModel.swift
//  Recipe
//
//  Created by Siran Li on 2/1/25.
//

import SwiftUI

@MainActor
class CachedAsyncImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    private let networkSession: NetworkSession
    private let imageMemoryCache: MemoryCache
    private let imageDiskCache: DiskCache
    
    init(dependencies: AppDependencies) {
        self.networkSession = dependencies.networkSession
        self.imageMemoryCache = dependencies.imageMemoryCache
        self.imageDiskCache = dependencies.imageDiskCache
    }

    func loadImage(from url: String) async {
        let key = createKey(from: url)
        
        if let cachedImage = getImageFromCache(forKey: key) {
            self.image = cachedImage
            return
        }
        
        if let fetchedImage = await fetchImage(forKey: url) {
            self.image = fetchedImage
        }
    }
    
    private func getImageFromCache(forKey key: String) -> UIImage? {
        if let cachedImage = imageMemoryCache.fetch(forKey: key) {
            return cachedImage
        }
        do {
            return try imageDiskCache.retrieve(forKey: key)
        } catch {
            print("Error fetching image from cache: \(error)")
            return nil
        }
    }
    
    private func fetchImage(forKey url: String) async -> UIImage? {
        guard let imageURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return nil
        }
        let key = createKey(from: url)
        do {
            let imageData = try await networkSession.fetchData(from: imageURL.absoluteString)
            if let fetchedImage = UIImage(data: imageData) {
                cacheImage(fetchedImage, forKey: key)
                return fetchedImage
            }
        } catch {
            print("Error fetching image: \(error)")
        }
        return nil
    }
    
    private func cacheImage(_ image: UIImage, forKey key: String) {
        imageMemoryCache.cache(image, forKey: key)
        do {
            try imageDiskCache.store(image, forKey: key)
        } catch {
            print("Error saving image to disk: \(error)")
        }
    }
    
    private func createKey(from urlString: String) -> String {
        let invalidCharacters = "/\\:*?\"<>|."
        return urlString.replacingOccurrences(of: "[\(invalidCharacters)]", with: "#", options: .regularExpression)
    }
}
