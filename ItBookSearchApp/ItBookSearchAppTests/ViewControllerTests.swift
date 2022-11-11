//
//  ViewControllerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import XCTest
@testable import ItBookSearchApp

final class ViewController: XCTestCase {
    var sut: SearchViewController!

    override func setUpWithError() throws {
        self.sut = SearchViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_requestItBookStore_성공적으로_호출하면_itBookStore에_데이터가_할당된다() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: ItBookStore?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.itBookStore
        
        XCTAssertNotNil(result)
    }
    
    func test_requestItBookStore_성공적으로_호출하면_books에_데이터가_할당된다() {
        // given
        sut = SearchViewController()
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: [ItBook]?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertNotEqual(result?.count, 0)
    }

    func test_requestItBookStore_호출실패시_itBookStore는_nil() {
        // given
        sut = SearchViewController()
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: [ItBook]?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertNil(result)
    }
    
    func test_requestItBookStore_호출실패시_books는_nil() {
        // given
        sut = SearchViewController()
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: [ItBook]?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertNil(result)
    }
    
    func test_requestItBookStore_검색텍스트가_없을때_books는_empty() {
        // given
        sut = SearchViewController()
        let searchTitle = ""
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SearchTextNilItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: [ItBook]?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertEqual(result?.count, 0)
    }
    
    func test_requestItBookStore_검색결과가_없을때_books는_empty() {
        // given
        sut = SearchViewController()
        let searchTitle = "aaaaa"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "EmptyItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: [ItBook]?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertEqual(result?.count, 0)
    }
}
