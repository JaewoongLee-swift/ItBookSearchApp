//
//  MockImageCacheable.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 6/25/24.
//

import UIKit
@testable import ItBookSearchApp

class MockImageCacheable: ImageCacheable {
    var setObjectCount = 0
    var cachedImageCount = 0
    var storage: [String: UIImage] = [:]
    
    func cachedImage(forKey key: String) -> UIImage? {
        storage[key]
    }
    
    func setObject(_ image: UIImage, forKey key: String) {
        storage[key] = image
    }
}

