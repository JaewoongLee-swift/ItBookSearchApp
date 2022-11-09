//
//  ItBookSearchAppTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/08.
//

import XCTest
@testable import ItBookSearchApp

final class ItBookSearchAppTests: XCTestCase {
    
    var searchCollectionViewCell: SearchCollectionViewCell?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.searchCollectionViewCell = SearchCollectionViewCell()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_searchCollectionViewCell_addSubViews() {
        searchCollectionViewCell?.addSubViews()
        
        let result = searchCollectionViewCell?.subviews.count
        
        XCTAssertEqual(6, result, "SearchCollectionViewCell의 subView가 제대로 추가되지 않았습니다.")
    }
}
