//
//  DetailViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class DetailViewController: UIViewController {
    let bookISBN13: String
    var itBookDetailManager: ItBookDetailManager?
    var itBookDetail: ItBookDetail?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.numberOfLines = 2
        label.text = "Title : title"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.text = "Subtitle : suttitle"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Author : author"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Publisher : publisher"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var isbn10Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "ISBN10 : isbn10"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var isbn13Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "ISBN13 : isbn13"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Page : page"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Year : year"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Rating : rating"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Description : description"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Price : price"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "URL : url"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = "Error : error"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var firstPDFButton: UIButton = {
        let button = UIButton()
        button.setTitle("PDF1", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(touchFirstPDFButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var secondPDFButton: UIButton = {
        let button = UIButton()
        button.setTitle("PDF2", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(touchSecondPDFButton), for: .touchUpInside)
        
        return button
    }()
    
    init(isbn13: String) {
        self.bookISBN13 = isbn13
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLayout()
        
        requestItBookDetail(from: bookISBN13)
    }
}

extension DetailViewController {
    private func setupLayout() {
        [
            imageView,
            titleLabel,
            subtitleLabel,
            authorLabel,
            publisherLabel,
            isbn10Label,
            isbn13Label,
            pageLabel,
            yearLabel,
            ratingLabel,
            descriptionLabel,
            priceLabel,
            urlLabel,
            firstPDFButton,
            secondPDFButton
        ].forEach { view.addSubview($0) }
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8.0).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        publisherLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8.0).isActive = true
        publisherLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        isbn10Label.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 8.0).isActive = true
        isbn10Label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        isbn13Label.topAnchor.constraint(equalTo: isbn10Label.bottomAnchor, constant: 8.0).isActive = true
        isbn13Label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        pageLabel.topAnchor.constraint(equalTo: isbn13Label.bottomAnchor, constant: 8.0).isActive = true
        pageLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        yearLabel.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 8.0).isActive = true
        yearLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        ratingLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 8.0).isActive = true
        ratingLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8.0).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        urlLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true

        firstPDFButton.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 20.0).isActive = true
        firstPDFButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        firstPDFButton.widthAnchor.constraint(equalToConstant: 125.0).isActive = true
        firstPDFButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        secondPDFButton.topAnchor.constraint(equalTo: firstPDFButton.topAnchor).isActive = true
        secondPDFButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        secondPDFButton.widthAnchor.constraint(equalToConstant: 125.0).isActive = true
        secondPDFButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    func requestItBookDetail(from isbn13: String, by manager: ItBookDetailManager = ItBookDetailManager()) {
        itBookDetailManager = manager
        
        itBookDetailManager?.requestItBookDetail(isbn13: isbn13) { [weak self] response in
            guard let self = self else { return }
            if case .success(let data) = response {
                self.itBookDetail = data
                guard let bookDetail = self.itBookDetail else { return }
                
                if let url = URL(string: bookDetail.imageURL) {
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                self.imageView.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.titleLabel.text = "Title: \(bookDetail.title)"
                    self.subtitleLabel.text = "Subtitle: \(bookDetail.subtitle)"
                    self.authorLabel.text = "Author: \(bookDetail.authors)"
                    self.publisherLabel.text = "Publisher: \(bookDetail.authors)"
                    self.isbn10Label.text = "ISBN10: \(bookDetail.isbn10)"
                    self.isbn13Label.text = "ISBN13: \(bookDetail.isbn13)"
                    self.pageLabel.text = "Page: \(bookDetail.pages)"
                    self.yearLabel.text = "Year: \(bookDetail.year)"
                    self.ratingLabel.text = "Rating: \(bookDetail.rating)"
                    self.descriptionLabel.text = "Description: \(bookDetail.desc)"
                    self.priceLabel.text = "Price: $\(bookDetail.price)"
                    self.urlLabel.text = "URL: \(bookDetail.url)"
                }
            }
        }
    }
    
    @objc func touchFirstPDFButton() {
        if let pdfURL = itBookDetail?.pdf?.chapter2 {
            let pdfViewController = PDFViewController(url: pdfURL)
            pdfViewController.modalPresentationStyle = .automatic
            
            present(pdfViewController, animated: true)
        } else {
            print("PDF가 존재하지 않습니다.")
        }
    }
    
    @objc func touchSecondPDFButton() {
        if let pdfURL = itBookDetail?.pdf?.chapter5 {
            let pdfViewController = PDFViewController(url: pdfURL)
            pdfViewController.modalPresentationStyle = .automatic
            
            present(pdfViewController, animated: true)
        } else {
            print("PDF가 존재하지 않습니다.")
        }
    }
}
