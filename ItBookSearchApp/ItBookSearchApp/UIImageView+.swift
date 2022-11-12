//
//  UIImageView+.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

extension UIImageView {
    //TODO: Unit Test 필요
    func setImage(url: String, session: URLSessionProtocol = URLSession.shared) {
        let session = session
        
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: "url")
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                self.image = cachedImage
                
                return
            }
            
            guard let url = URL(string: url) else { return }
            
            let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.image = UIImage()
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                        self.image = image
                    }
                }
            }
            dataTask.resume()
        }
    }
}
