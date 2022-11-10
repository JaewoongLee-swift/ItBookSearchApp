//
//  SearchViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import UIKit

class SearchViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.backgroundColor = .red
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupLayout()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: [ItBook]의 count를 return하도록 구현
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: Custom UICollectionViewCell 구현
        UICollectionViewCell()
    }
}

extension SearchViewController {
    //TODO: collectionView의 셀이 모두 등록된 이후 테스트 필요
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
