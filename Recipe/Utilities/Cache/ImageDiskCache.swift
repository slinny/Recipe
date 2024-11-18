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

    init(cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!) {
        self.cacheDirectory = cacheDirectory
        self.fileManager = FileManager.default
    }

    func store(_ image: UIImage, forKey key: String) throws {
        let data = image.jpegData(compressionQuality: 0.75)!
        let filePath = cacheDirectory.appendingPathComponent(key)
        try data.write(to: filePath)
    }

    func retrieve(forKey key: String) throws -> UIImage? {
        let filePath = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: filePath) else { return nil }
        return UIImage(data: data)
    }

    func remove(forKey key: String) throws {
        let filePath = cacheDirectory.appendingPathComponent(key)
        try fileManager.removeItem(at: filePath)
    }

    func clear() throws {
        try fileManager.removeItem(at: cacheDirectory)
        try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}
