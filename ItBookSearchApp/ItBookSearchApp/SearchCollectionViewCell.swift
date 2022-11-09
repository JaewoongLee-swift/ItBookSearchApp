//
//  SearchCollectionViewCell.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtitle"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        
        return label
    }()
    
    private lazy var isbn13Label: UILabel = {
        let label = UILabel()
        label.text = "isbn13"
        label.font = .systemFont(ofSize: 12.0)
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$price"
        label.font = .systemFont(ofSize: 12.0)
        
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.text = "https://url"
        label.font = .systemFont(ofSize: 12.0)
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        
        return imageView
    }()
}

extension SearchCollectionViewCell {
    func addSubViews() {
        [
            titleLabel,
            subtitleLabel,
            isbn13Label,
            priceLabel,
            urlLabel,
            imageView
        ].forEach { addSubview($0) }
        
    }
}
