//
//  UIImageView+.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

extension UIImageView {
    //TODO: Unit Test 필요
    func setImage(url: String) {
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: "url")
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                self.image = cachedImage
                
                return
            }
            
            guard let url = URL(string: url) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                    self.image = image
                }
            }
        }
    }
}
