//
//  SearchViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class SearchViewController: UIViewController {
    var itBookStoreManager: ItBookStoreManager?
    var itBookStore: ItBookStore?
    
    var books : [ItBook] = []
    
    var searchedText = ""
    var totalPage: Int?
    var currentPage: Int?
    var isPaging = false
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        
        return collectionView
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Error : 0"
        label.font = .systemFont(ofSize: 12.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "TotalPage : 0"
        label.font = .systemFont(ofSize: 12.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.text = "Page : 0"
        label.font = .systemFont(ofSize: 12.0)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        
        [
            errorLabel,
            totalLabel,
            pageLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setNavigationItems()
        setupLayout()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = 215.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(isbn13: books[indexPath.row].isbn13)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
            cell.configure(books[indexPath.row])
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.searchTextField.text {
            if text != "" {
                requestItBookStore(from: text)
                searchedText = text
            }
        }
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            let contentOffsetY = scrollView.contentOffset.y
            let collectionViewContentSize = scrollView.contentSize.height
            let height = scrollView.frame.height
            
            guard !isPaging else { return }
        
            if contentOffsetY > (collectionViewContentSize - height) {
                isPaging = true
                
                guard let totalPage = totalPage else { return }
                guard let currentPage = currentPage else { return }
                
                if totalPage > currentPage {
                    self.currentPage? += 1
                    requestItBookStorePagination(from: searchedText, at: self.currentPage ?? 0)
                }
            }
            
        }
        
}

extension SearchViewController {
    func setupLayout() {
        view.addSubview(stackView)
        view.addSubview(collectionView)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setNavigationItems() {
        navigationItem.title = "ItBookSearch"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "도서명을 검색해주세요."
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    func requestItBookStore(from title: String, by manager: ItBookStoreManager = ItBookStoreManager()) {
        itBookStoreManager = manager
        
        itBookStoreManager?.requestItBookStore(bookName: title) { [weak self] response in
            if case .success(let data) = response {
                self?.itBookStore = data
                self?.books.append(contentsOf: self?.itBookStore?.books ?? [])
                self?.totalPage = Int(self?.itBookStore?.total ?? "0")
                self?.currentPage = Int(self?.itBookStore?.page ?? "0")
                
                DispatchQueue.main.async {
                    self?.errorLabel.text = "Error : \(self?.itBookStore?.error ?? "")"
                    self?.totalLabel.text = "TotalPage : \(self?.totalPage ?? 0)"
                    self?.pageLabel.text = "Page : \(self?.currentPage ?? 0)"
                    self?.collectionView.reloadData()
                    self?.isPaging = false
                }
                
            } else if case .failure(let error) = response {
                print(error)
            }
        }
    }
    
    func requestItBookStorePagination(from title: String, at page: Int, by manager: ItBookStoreManager = ItBookStoreManager()) {
        itBookStoreManager = manager
        
        itBookStoreManager?.requestItBookStore(bookName: title, page: page) { [weak self] response in
            if case .success(let data) = response {
                self?.itBookStore = data
                self?.books.append(contentsOf: self?.itBookStore?.books ?? [])
                self?.totalPage = Int(self?.itBookStore?.total ?? "0")
                self?.currentPage = Int(self?.itBookStore?.page ?? "0")
                
                DispatchQueue.main.async {
                    self?.errorLabel.text = "Error : \(self?.itBookStore?.error ?? "")"
                    if let totalPage = self?.totalPage {
                        if let currentPage = self?.currentPage {
                            if currentPage > totalPage {
                                self?.totalLabel.text = "TotalPage : \(currentPage)"
                            } else {
                                self?.totalLabel.text = "TotalPage : \(totalPage)"
                            }
                            self?.pageLabel.text = "Page : \(currentPage)"
                        }
                    }
                    self?.collectionView.reloadData()
                    self?.isPaging = false
                }
                
            } else if case .failure(let error) = response {
                print(error)
            }
        }
    }
}
