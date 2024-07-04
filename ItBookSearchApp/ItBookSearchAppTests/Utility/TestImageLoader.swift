//
//  TestImageLoader.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 6/26/24.
//

import UIKit

class TestImageLoader {
    static func loadImage(resourceName: String, type: String) -> UIImage? {
        let testBundle = Bundle(for: self)
        guard let filePath = testBundle.path(forResource: resourceName, ofType: type) else { return nil }
        
        return UIImage(contentsOfFile: filePath)
    }
}
