//
//  SearchCollectionViewCell.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let id = "SearchCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title :"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtitle :"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var isbn13Label: UILabel = {
        let label = UILabel()
        label.text = "isbn13 :"
        label.font = .systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "price :"
        label.font = .systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var imageView: URLUIImageView = {
        let imageView = URLUIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func prepareForReuse() {
        imageView.image = UIImage()
        imageView.cancelLoadingImage()
    }
}

extension SearchCollectionViewCell {
    func configure(_ book: ItBook) {
        titleLabel.text = book.getTitle()
        subtitleLabel.text = book.getSubTitle()
        isbn13Label.text = book.getISBN13()
        priceLabel.text = book.getPrice()
        urlLabel.text = book.getURL()
        
        imageView.setImage(url: book.getImageURL())
        
        setupLayout()
    }
    
    private func setupLayout() {
        [
            titleLabel,
            subtitleLabel,
            isbn13Label,
            priceLabel,
            urlLabel,
            imageView
        ].forEach { addSubview($0) }
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        isbn13Label.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8.0).isActive = true
        isbn13Label.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        isbn13Label.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: isbn13Label.bottomAnchor, constant: 8.0).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        urlLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
    }
}
