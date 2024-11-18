//
//  FileDiskCache.swift
//  Recipe
//
//  Created by Siran Li on 11/17/24.
//


import Foundation
import SwiftUI

class ImageDiskCache: DiskCache {
    
    
    private let cacheDirectory: URL
    private let fileManager: FileManager
    private let compressionQuality: CGFloat
    private let storageLimit: Int

    init(
        cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!,
        compressionQuality: CGFloat = 0.75,
        storageLimit: Int = 100 * 1024 * 1024 // Default to 100 MB
    ) {
        self.cacheDirectory = cacheDirectory
        self.compressionQuality = compressionQuality
        self.storageLimit = storageLimit
        self.fileManager = FileManager.default
        setupCacheDirectory()
    }

    // MARK: - Public Methods
    func store(_ image: UIImage, forKey key: String) throws {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else {
            throw CacheError.failedToEncodeImage
        }

        let filePath = cacheDirectory.appendingPathComponent(key)
        try data.write(to: filePath)

        try enforceStorageLimit()
    }

    func retrieve(forKey key: String) throws -> UIImage? {
        let filePath = cacheDirectory.appendingPathComponent(key)
        guard fileManager.fileExists(atPath: filePath.path),
              let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

    private func setupCacheDirectory() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    func totalCacheSize() throws -> Int {
        let contents = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey])
        return contents?.reduce(0) { total, url in
            let fileSize = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
            return total + fileSize
        } ?? 0
    }

    func enforceStorageLimit() throws {
        var contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.contentAccessDateKey, .fileSizeKey])
        
        var totalSize = try totalCacheSize()
        if totalSize <= storageLimit { return }
        
        // Sort files by last access date (oldest first)
        contents.sort { lhs, rhs in
            let lhsDate = (try? lhs.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate) ?? Date.distantPast
            let rhsDate = (try? rhs.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate) ?? Date.distantPast
            return lhsDate < rhsDate
        }

        for file in contents {
            guard totalSize > storageLimit else { break }
            let fileSize = (try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
            try fileManager.removeItem(at: file)
            totalSize -= fileSize
        }
    }

    // MARK: - Error Handling
    enum CacheError: Error, LocalizedError {
        case failedToEncodeImage

        var errorDescription: String? {
            switch self {
            case .failedToEncodeImage:
                return "Failed to encode image as JPEG."
            }
        }
    }
}

