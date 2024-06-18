//
//  DiskCache.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 6/17/24.
//

import UIKit

protocol DiskCacheable {
    func cachedImage(urlString: String) -> UIImage?
    func saveImage(_ image: UIImage, forKey key: String)
}

class DiskCacheManager: DiskCacheable {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathExtension("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path()) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    func cachedImage(urlString: String) -> UIImage? {
        let filePath = self.filePath(forKey: urlString)
        guard let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data) else {
                  return nil
              }
        
        return image
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        let filePath = self.filePath(forKey: key)
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: filePath)
        }
    }
    
    private func filePath(forKey key: String) -> URL {
        let safeKey = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        
        return cacheDirectory.appending(path: safeKey)
    }
}
