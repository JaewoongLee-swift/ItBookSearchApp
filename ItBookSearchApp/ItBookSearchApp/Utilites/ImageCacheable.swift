//
//  ImageCacheable.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 6/21/24.
//

import UIKit

protocol ImageCacheable {
    func cachedImage(forKey key: String) -> UIImage?
    func setObject(_ image: UIImage, forKey key: String)
}
