//
//  ImageDiskCacheManager.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 6/17/24.
//

import UIKit

class ImageDiskCacheManager: ImageCacheable {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let maximumByte: UInt64
    
    /// 기본 maximumByte : 100mb
    init(maximumByte: UInt64 = 100 * 1024 * 1024) {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathExtension("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path()) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
        
        self.maximumByte = maximumByte
    }
    
    func cachedImage(forKey key: String) -> UIImage? {
        let filePath = self.filePath(forKey: key)
        
        if let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
    
    func setObject(_ image: UIImage, forKey key: String) {
        let filePath = self.filePath(forKey: key)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: filePath)
        }
    }
    
    private func filePath(forKey key: String) -> URL {
        let safeKey = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        
        return cacheDirectory.appending(path: safeKey)
    }
    
    /// TTL 알고리즘을 활용한 디스크 캐싱 함수
    private func cleanUpDiskIfNeeded() {
        let urlProperties: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey, .totalFileAllocatedSizeKey]
        
        guard let cachedUrls = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: urlProperties, options: .skipsHiddenFiles) else { return }
        
        var cachedSize: UInt64 = 0
        var fileUrls: [URL] = []
        
        for url in cachedUrls {
            let resourceValues = try? url.resourceValues(forKeys: Set(urlProperties))
            
            guard let isDirectory = resourceValues?.isDirectory, !isDirectory else { continue }
            
            if let fileSize = resourceValues?.totalFileAllocatedSize {
               cachedSize += UInt64(fileSize)
                fileUrls.append(url)
            }
        }
        
        if cachedSize > maximumByte {
            let sortedFiles = fileUrls.sorted { leftUrl, rightUrl in
                let leftDate = (try? leftUrl.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                let rightDate = (try? rightUrl.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                
                return leftDate < rightDate
            }
            
            for fileUrl in sortedFiles {
                try? fileManager.removeItem(at: fileUrl)
                if cachedSize <= maximumByte { break }
            }
        }
    }
}
