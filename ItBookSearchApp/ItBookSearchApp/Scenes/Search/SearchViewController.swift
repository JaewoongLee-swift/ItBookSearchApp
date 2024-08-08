//
//  SearchViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit
import ReactorKit
import RxCocoa

class SearchViewController: UIViewController, View {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 215.0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setNavigationItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    func bind(reactor: SearchReactor) {
        // Action
        navigationItem.searchController?.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.search(query: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .compactMap(\.last?.row)
            .withUnretained(self)
            .map { _ in Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { Reactor.Action.selectItem(index: $0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.books }
            .bind(to: collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.id, cellType: SearchCollectionViewCell.self)) { row, book, cell in
                cell.configure(book)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { "TotalPage : \($0.totalPage)" }
            .bind(to: totalLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { "CurrentPage : \($0.currentPage)" }
            .bind(to: pageLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { "Error Message : \($0.error ?? "")" }
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedItem }
            .asDriver(onErrorJustReturn: nil)
            .filter { $0 != nil }
            .drive(onNext: { [weak self] selectedItem in
                guard let self else { return }
                let detailViewController = DetailViewController(isbn13: selectedItem!.getISBN13())
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
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
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
}
