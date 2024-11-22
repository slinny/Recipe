//
//  CachedAsyncImage.swift
//  Recipe
//
//  Created by Siran Li on 11/17/24.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: String
    @State private var image: UIImage?
    private let networkSession: NetworkSession
    private let imageMemoryCache: MemoryCache
    private let imageDiskCache: DiskCache
    
    init(
        url: String,
        networkSession: NetworkSession = RecipeURLSessionManager(),
        imageMemoryCache: MemoryCache = ImageMemoryCache(),
        imageDiskCache: DiskCache = ImageDiskCache()
    ) {
        self.url = url
        self.networkSession = networkSession
        self.imageMemoryCache = imageMemoryCache
        self.imageDiskCache = imageDiskCache
    }
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.5)
            }
        }
        .task {
            image = await loadImage(forKey: url)
        }
    }
    
    private func loadImage(forKey url: String) async -> UIImage? {
        let key = createKey(from: url)
        if let cachedImage = getImageFromCache(forKey: key) {
            return cachedImage
        } else {
            return await fetchImage(forKey: url)
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
                imageMemoryCache.cache(fetchedImage, forKey: key)
                do {
                    try imageDiskCache.store(fetchedImage, forKey: key)
                } catch {
                    print("Error saving image to disk: \(error)")
                }
                return fetchedImage
            }
            return nil
        } catch {
            print("Error fetching image: \(error)")
            return nil
        }
    }
    
    private func createKey(from urlString: String) -> String {
        let invalidCharacters = "/\\:*?\"<>|."
        let key = urlString.replacingOccurrences(of: "[\(invalidCharacters)]", with: "#", options: .regularExpression)
        return key
    }
}
