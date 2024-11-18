//
//  MemoryCache.swift
//  Recipe
//
//  Created by Siran Li on 11/17/24.
//
import SwiftUI

protocol MemoryCache {
    func cache(_ image: UIImage, forKey key: String)
    func fetch(forKey key: String) -> UIImage?
}
