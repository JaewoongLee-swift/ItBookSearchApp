//
//  SearchViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class SearchViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = 215.0
        
        return CGSize(width: width, height: height)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: [ItBook]의 count를 return하도록 구현
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setupLayout()
        
        return cell
    }
}

extension SearchViewController {
    func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
    }
}
