//
//  ImageCache.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import Foundation

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
}
