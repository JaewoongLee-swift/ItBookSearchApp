//
//  URLUIImageView.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit

class URLUIImageView: UIImageView {
    var imageFetchTask: CancellableTask?
    
    func setImage(urlString: String) {
        self.imageFetchTask = ImageFetcher.shared.fetchImage(from: urlString) { [weak self] image in
            guard let self else { return }
            
            self.image = image
        }
    }
    
    func cancelLoadingImage() {
        imageFetchTask?.cancel()
        imageFetchTask = nil
    }
}
