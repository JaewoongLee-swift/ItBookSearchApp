//
//  ImageFetcher.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 6/18/24.
//

import UIKit

class ImageFetcher {
    private let memoryCacheManager: ImageCacheable
    private let diskCacheManager: ImageCacheable
    private let session: URLSessionProtocol
    
    init(
        memoryCacheManager: ImageCacheable,
        diskCacheManager: ImageCacheable,
        session: URLSessionProtocol = URLSession.shared
    ) {
        self.memoryCacheManager = memoryCacheManager
        self.diskCacheManager = diskCacheManager
        self.session = session
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTaskProtocol? {
        if let memoryCachedImage = memoryCacheManager.cachedImage(forKey: urlString) {
            completion(memoryCachedImage)
            return nil
        }
        
        if let diskCachedImage = diskCacheManager.cachedImage(forKey: urlString) {
            memoryCacheManager.setObject(diskCachedImage, forKey: urlString)
            completion(diskCachedImage)
            return nil
        }
        
        return fetchImageFromSession(urlString: urlString, completion: completion)
    }
    
    private func fetchImageFromSession(urlString: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTaskProtocol? {
        guard let imageUrl = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        
        let task = session.dataTask(with: imageUrl) { [weak self] data, response, error in
            guard let self,
                  error == nil,
                  let data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
                    
            self.memoryCacheManager.setObject(image, forKey: urlString)
            self.diskCacheManager.setObject(image, forKey: urlString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
        
        return task
    }
}
