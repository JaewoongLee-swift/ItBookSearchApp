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
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
