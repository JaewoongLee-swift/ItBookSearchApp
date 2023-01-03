//
//  URLUIImageView.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

class URLUIImageView: UIImageView {
    var dataTask: URLSessionDataTask?
    
    func setImage(urlString: String) {
        DispatchQueue.global(qos: .background).async {
            if let cachedImage = ImageCacheManager.shared.cachedImage(urlString: urlString) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }
            
            guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
            let filePath = URL(fileURLWithPath: path).appendingPathComponent(urlString)
            let fileManager = FileManager()
            
            if fileManager.fileExists(atPath: filePath.path) {
                guard let imageData = try? Data(contentsOf: filePath) else {
                    print("Disk Cache의 image data가 없습니다.")
                    return
                }
                
                guard let cachedImage = UIImage(data: imageData) else {
                    print("Disk Cache의 image data가 없습니다.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = cachedImage
                    
                    ImageCacheManager.shared.setObject(image: cachedImage, urlString: urlString)
                }
                
                return
            }

            
            guard let url = URL(string: urlString) else { return }
            
            self.dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.image = UIImage()
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheManager.shared.setObject(image: image, urlString: urlString)
                        fileManager.createFile(atPath: filePath.path, contents: image.jpegData(compressionQuality: 1.0), attributes: nil)
                        self.image = image
                    }
                }
            }
            self.dataTask?.resume()
        }
    }
    
    func cancelLoadingImage() {
        dataTask?.cancel()
        dataTask = nil
    }
}
