//
//  ImageCache.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let storage = NSCache<NSString, UIImage>()
    
    private init() {
        storage.totalCostLimit = 52428800
    }
    
    //cache비용제한 정책메소드를 init으로 결정하도록 변경
//    static func configureCachePolicy(with maximumBytes: Int) {
//        self.shared.storage.totalCostLimit = maximumBytes
//    }
    
    func cachedImage(urlString: String) -> UIImage? {
        let cachedKey = NSString(string: urlString)
        
        if let cachedImage = storage.object(forKey: cachedKey) {
            return cachedImage
        }
        
        return nil
    }
    
    func setObject(image: UIImage, urlString: String) {
        let forKey = NSString(string: urlString)
        self.storage.setObject(image, forKey: forKey)
    }
}
