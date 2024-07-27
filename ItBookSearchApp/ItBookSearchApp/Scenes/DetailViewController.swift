//
//  DetailViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class DetailViewController: UIViewController {
    let bookISBN13: String
    var itBookDetail: ItBookDetail?
    var booksApi: ItBookAPI.Books
    
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
    
    init(isbn13: String, booksApi: ItBookAPI.Books = ItBookAPI.Books()) {
        self.bookISBN13 = isbn13
        self.booksApi = booksApi
        
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
    
    func requestItBookDetail(from isbn13: String) {
        let _ = booksApi.request(isbn13: isbn13) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let itBookDetail):
                self.itBookDetail = itBookDetail
                self.setDetailImage(urlString: itBookDetail.getImageURL())
                
                DispatchQueue.main.async {
                    self.titleLabel.text = "Title: \(itBookDetail.getTitle())"
                    self.subtitleLabel.text = "Subtitle: \(itBookDetail.getSubtitle())"
                    self.authorLabel.text = "Author: \(itBookDetail.getAuthors())"
                    self.publisherLabel.text = "Publisher: \(itBookDetail.getPublisher())"
                    self.isbn10Label.text = "ISBN10: \(itBookDetail.getISBN10())"
                    self.isbn13Label.text = "ISBN13: \(itBookDetail.getISBN13())"
                    self.pageLabel.text = "Page: \(itBookDetail.getPages())"
                    self.yearLabel.text = "Year: \(itBookDetail.getYear())"
                    self.ratingLabel.text = "Rating: \(itBookDetail.getRating())"
                    self.descriptionLabel.text = "Description: \(itBookDetail.getDescription())"
                    self.priceLabel.text = "Price: $\(itBookDetail.getPrice())"
                    self.urlLabel.text = "URL: \(itBookDetail.getURL())"
                }
            case .failure(let error):
                // TODO: Error 노출 시 Alert 노출
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func touchFirstPDFButton() {
        presentPDFViewController(urlString: itBookDetail?.getPDFs()?.chapter2)
    }
    
    @objc func touchSecondPDFButton() {
        presentPDFViewController(urlString: itBookDetail?.getPDFs()?.chapter5)
    }
    
    func presentPDFViewController(urlString: String?) {
        if let pdfURL = urlString {
            let pdfViewController = PDFViewController(url: pdfURL)
            pdfViewController.modalPresentationStyle = .automatic
            
            present(pdfViewController, animated: true)
        } else {
            print("PDF가 존재하지 않습니다.")
        }
    }
}

extension DetailViewController {
    //TODO: ViewModel 생성 시 책임 분리
    private func setDetailImage(urlString: String) {
        let _ = AppDelegate.imageFetcher.fetchImage(from: urlString) { [weak self] image in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
