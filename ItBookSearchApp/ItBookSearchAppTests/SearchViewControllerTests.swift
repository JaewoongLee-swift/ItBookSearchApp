//
//  SearchViewControllerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import XCTest
@testable import ItBookSearchApp

final class SearchViewControllerTest: XCTestCase {
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
        let expectation = expectation(description: "SearchViewController request ItBookStore with status code 200")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertNotNil(self.sut.itBookStore)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_requestItBookStore_성공적으로_호출하면_books에_데이터가_할당된다() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        let expectation = expectation(description: "books exist after SearchViewController request ItBookStore with status code 200")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertFalse(self.sut.books.isEmpty)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }

    func test_requestItBookStore_호출실패시_books는_비어있음() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        let expectation = expectation(description: "Books not exist after SearchViewController request ItBookStore with status code 500")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertTrue(self.sut.books.isEmpty)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_requestItBookStore_검색텍스트가_없을때_books는_empty() {
        // given
        let searchTitle = ""
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SearchTextNilItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        let expectation = expectation(description: "Books exist but empty after SearchViewController request ItBookStore with status code 200")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertTrue(self.sut.books.isEmpty)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_requestItBookStore_검색결과가_없을때_books는_empty() {
        // given
        let searchTitle = "aaaaa"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "EmptyItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        let expectation = expectation(description: "Books don't exist after SearchViewController request ItBookStore with status code 200")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertTrue(self.sut.books.isEmpty)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_requestItBookStore_성공적으로_호출하면_totalPage에_값이_할당된다() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        let expectation = expectation(description: "Total page is assigned after SearchViewController request ItBookStore with status code 200")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertNotNil(self.sut.totalPage)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_requestItBookStore_호출실패하면_totalPage_nil() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        let expectation = expectation(description: "Total page is nil after SearchViewController request ItBookStore with status code 500")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertNil(self.sut.totalPage)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_requestItBookStore_호출실패하면_currentPage_nil() {
        // given
        let searchTitle = "swift"
        let url = "https://api.itbook.store/1.0/search/\(searchTitle)"
        let data: Data? = JsonLoader.data(fileName: "SwiftItBookStore")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookStoreManager(session: mockURLSession)
        let expectation = expectation(description: "Current page is nil after SearchViewController request ItBookStore with status code 500")
        
        // when
        sut.requestItBookStore(from: searchTitle, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertNil(self.sut.currentPage)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
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
        let expectation = expectation(description: "Books is appended  after SearchViewController request ItBookStore with status code 200")
        
        // when
        var result = 0
        let booksCountBeforeRequest = sut.books.count
        
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            if let itBookStoresBookCountAfterRequest = self.sut.itBookStore?.books.count {
                XCTAssertEqual(self.sut.books.count, itBookStoresBookCountAfterRequest + booksCountBeforeRequest)
            } else {
                XCTFail("'requestItBookStorePagination' is failed")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
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
        let expectation = expectation(description: "Books don't changed  after SearchViewController request ItBookStore with status code 500")
        
        // when
        let booksCountBeforeRequest = sut.books.count
        
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertEqual(self.sut.books.count, booksCountBeforeRequest)
         
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
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
        let expectation = expectation(description: "ItBookStore's book count is 0 if pagination result is empty")
        
        // when
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertEqual(self.sut.itBookStore?.books.count, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
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
        let expectation = expectation(description: "ItBookStore doesn't change if pagination request is failed")
        
        //when
        sut.requestItBookStorePagination(from: searchTitle, at: page, by: networkManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then
            XCTAssertNil(self.sut.itBookStore)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
