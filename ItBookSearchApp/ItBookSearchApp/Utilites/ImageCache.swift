//
//  ImageCache.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

protocol ImageCacheable {
    func cachedImage(urlString: String) -> UIImage?
    func setObject(image: UIImage, urlString: String)
}

class ImageCacheManager: ImageCacheable {
    /// 기본 maximumByte : 100mb
    static let shared = ImageCacheManager()
    
    private let storage: NSCache<NSString, UIImage>
    
    private init(maximumBytes: Int = 104857600) {
        self.storage = NSCache<NSString, UIImage>()
        self.storage.totalCostLimit = maximumBytes
    }
    
    func cachedImage(urlString: String) -> UIImage? {
        let cachedKey = NSString(string: urlString)
        
        return self.storage.object(forKey: cachedKey)
    }
    
    func setObject(image: UIImage, urlString: String) {
        let forKey = NSString(string: urlString)
        
        self.storage.setObject(image, forKey: forKey)
    }
}
