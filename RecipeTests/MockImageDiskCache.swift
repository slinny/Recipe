//
//  MockImageDiskCache.swift
//  Recipe
//
//  Created by Siran Li on 2/1/25.
//

import SwiftUI
@testable import Recipe

class MockImageDiskCache: DiskCache {
    var storedImages: [String: UIImage] = [:]
    var retrievedKeys: [String] = []
    var storedKeys: [String] = []
    var totalSize: Int = 0
    var storageLimit: Int = 100 * 1024 * 1024 // Default to 100 MB

    func store(_ image: UIImage, forKey key: String) throws {
        storedImages[key] = image
        storedKeys.append(key)
        // Simulate the size of the image
        let imageSize = Int(image.size.width * image.size.height * 4) // Assuming 4 bytes per pixel (RGBA)
        totalSize += imageSize
        try enforceStorageLimit()
    }

   func retrieve(forKey key: String) throws -> UIImage? {
        retrievedKeys.append(key)
        return storedImages[key]
    }

    func totalCacheSize() throws -> Int {
        return totalSize
    }

    func enforceStorageLimit() throws {
        if totalSize > storageLimit {
            // Simulate removing the oldest image
            if let oldestKey = storedKeys.first {
                storedImages.removeValue(forKey: oldestKey)
                storedKeys.removeFirst()
                // Simulate the size reduction
                let imageSize = Int((storedImages.first?.value.size.width ?? 0) * (storedImages.first?.value.size.height ?? 0) * 4)
                totalSize -= imageSize
            }
        }
    }
}
