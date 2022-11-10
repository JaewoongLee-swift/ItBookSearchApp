//
//  DetailViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class DetailViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var isbn10Label: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var isbn13Label: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var pageLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var firstPDFButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var secondPDFButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
