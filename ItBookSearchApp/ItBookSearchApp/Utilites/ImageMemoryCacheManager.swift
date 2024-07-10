//
//  ImageMemoryCacheManager.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

class ImageMemoryCacheManager: ImageCacheable {
    private let storage: NSCache<NSString, UIImage>
    
    /// 기본 maximumByte : 100mb
    init(maximumBytes: Int = 100 * 1024 * 1024) {
        self.storage = NSCache<NSString, UIImage>()
        self.storage.totalCostLimit = maximumBytes
    }
    
    func cachedImage(forKey key: String) -> UIImage? {
        let cachedKey = NSString(string: key)
        
        return self.storage.object(forKey: cachedKey)
    }
    
    func setObject(_ image: UIImage, forKey key: String) {
        let forKey = NSString(string: key)
        
        self.storage.setObject(image, forKey: forKey)
    }
}
