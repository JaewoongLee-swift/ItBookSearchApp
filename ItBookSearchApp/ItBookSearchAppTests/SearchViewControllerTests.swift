//
//  SearchViewControllerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/10.
//

import XCTest
@testable import ItBookSearchApp

final class SearchViewControllerTests: XCTestCase {
    
    var searchViewController: SearchViewController?

    override func setUpWithError() throws {
        searchViewController = SearchViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_searchCollectionView_setupLayout_subViewCount() {
        searchViewController?.setupLayout()
        
        let result = searchViewController?.view.subviews.count
        
        XCTAssertEqual(1, result, "SearchViewController의 view에 collectionView가 제대로 추가되지 않았습니다.")
    }
    
    //TODO: Cell이 모두 구현된 후 테스트 필요
//    func test_searchCollectionView_setupLayout_constraints() {
//
//        let result = (searchViewController?.collectionView.frame.width, searchViewController?.collectionView.frame.height)
//        print(result)
//        let view = (searchViewController?.view.frame.width, searchViewController?.view.frame.height)
//        print(view)
//
//        XCTAssertTrue(result == view, "SearchViewController의 collectionView의 constraints가 제대로 설정되지 않았습니다.")
//    }

}
