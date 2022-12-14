//
//  ImageCache.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    static func configureCachePolicy(with maximumBytes: Int) {
        self.shared.totalCostLimit = maximumBytes
    }
    
    private init() { }
}
