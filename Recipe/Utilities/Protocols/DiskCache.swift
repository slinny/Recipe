//
//  DiskCache.swift
//  Recipe
//
//  Created by Siran Li on 11/17/24.
//
import SwiftUI

protocol DiskCache {
    func store(_ image: UIImage, forKey key: String) throws
    func retrieve(forKey key: String) throws -> UIImage?
    func totalCacheSize() throws -> Int
    func enforceStorageLimit() throws
}
