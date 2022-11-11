//
//  SearchViewControllerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import XCTest
@testable import ItBookSearchApp

final class SearchViewController: XCTestCase {
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
        var result: [ItBook]
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertNotEqual(result.count, 0)
    }

    func test_requestItBookStore_호출실패시_books는_비어있음() {
        // given
        sut = SearchViewController()
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: [ItBook]
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertTrue(result.isEmpty)
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
        var result: [ItBook]
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertTrue(result.isEmpty)
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
        var result: [ItBook]
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.books
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_requestItBookStore_성공적으로_호출하면_totalPage에_값이_할당된다() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: Int?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.totalPage
        
        XCTAssertNotNil(result)
    }
    
    func test_requestItBookStore_호출실패하면_totalPage_nil() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: Int?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.totalPage
        
        XCTAssertNil(result)
    }
    
    func test_requestItBookStore_호출실패하면_currentPage_nil() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: Int?
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        result = sut.currentPage
        
        XCTAssertNil(result)
    }
    
    func test_requestItBookStorePagination_호출성공하면_books에_append() {
        // given
        let searchTitle = "swift"
        let page = 2
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)/\(page)"
        let data: Data? = JsonLoader.data(fileName: "Swift2ItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result = 0
        var totalCount = 0
        let itBookCountBeforeRequest = sut.itBookStore?.books.count
        
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        let requestedItBookCount = sut.itBookStore?.books.count
        result = sut.books.count
        
        if let beforeCount = itBookCountBeforeRequest {
            totalCount += beforeCount
        }
        if let afterCount = requestedItBookCount {
            totalCount += afterCount
        }
        
        
        XCTAssertEqual(result, totalCount)
    }
    
    func test_requestItBookStorePagination_호출실패하면_books_그대로() {
        // given
        let searchTitle = "swift"
        let page = 2
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)/\(page)"
        let data: Data? = JsonLoader.data(fileName: "Swift2ItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result = 0
        let itBookCountBeforeRequest = sut.books.count
        
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        result = sut.books.count
        
        XCTAssertEqual(result, itBookCountBeforeRequest)
    }
    
    func test_requestItBookStorePagination_pagination결과_없으면_itBookStore의_booksCount는_0() {
        // given
        let searchTitle = "swift"
        let page = 50
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)/\(page)"
        let data: Data? = JsonLoader.data(fileName: "Swift50ItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: Int?
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        result = sut.itBookStore?.books.count
        
        XCTAssertEqual(result, 0)
    }
    
    func test_requestItBookStorePagination_호출실패하면_itBookStore_그대로() {
        // given
        let searchTitle = "swift"
        let page = 2
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)/\(page)"
        let data: Data? = JsonLoader.data(fileName: "Swift2ItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        
        //when
        let beforeItBookStore = sut.itBookStore
        var result: ItBookStore?
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        result = sut.itBookStore
        
        XCTAssertEqual(result?.error, beforeItBookStore?.error)
        XCTAssertEqual(result?.total, beforeItBookStore?.total)
        XCTAssertEqual(result?.page, beforeItBookStore?.page)
        XCTAssertEqual(result?.books.count, beforeItBookStore?.books.count)
    }
}
