//
//  ItBookStoreManagerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import XCTest
@testable import ItBookSearchApp

final class ItBookStoreManagerTests: XCTestCase {
    var url: String?
    var data: Data?

    override func setUpWithError() throws {
        url = "https://api.itbook.store/1.0/search/mongodb"
        data = JsonLoader.data(fileName: "ItBookStore")
    }

    override func tearDownWithError() throws {
        url = nil
        data = nil
    }
    
    func test_fetchData_statusCode_is_200() {
        //given
        let searchText = "mongoDB"
        let url = "https://api.itbook.store/1.0/search/\(searchText)"
        let mockResponse: MockURLSession.Response = {
            let data: Data? = JsonLoader.data(fileName: "MongoDBItBookStore")
            let successResponse = HTTPURLResponse(
                url: URL(string: url)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: ItBookStore?
        sut.requestItBookStore(bookName: searchText) { response in
            if case let .success(itBookStore) = response {
                result = itBookStore
            }
        }
        
        //then
        let expectation: ItBookStore? = JsonLoader.load(type: ItBookStore.self, fileName: "MongoDBItBookStore")
        XCTAssertEqual(result?.total, expectation?.total)
        XCTAssertEqual(result?.error, expectation?.error)
        XCTAssertEqual(result?.page, expectation?.page)
        XCTAssertEqual(result?.books.count, expectation?.books.count)
    }
    
    func test_fetchData_searchResult_is_empty() {
        //given
        let searchText = "fefagawgrgrga"
        let url = "https://api.itbook.store/1.0/search/\(searchText)"
        let mockResponse: MockURLSession.Response = {
            let data: Data? = JsonLoader.data(fileName: "EmptyItBookStore")
            let successResponse = HTTPURLResponse(
                url: URL(string: url)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: ItBookStore?
        sut.requestItBookStore(bookName: searchText) { response in
            if case let .success(itBookStore) = response {
                result = itBookStore
            }
        }
        
        //then
        let expectation: ItBookStore? = JsonLoader.load(type: ItBookStore.self, fileName: "EmptyItBookStore")
        XCTAssertEqual(result?.books.count, expectation?.books.count)
        XCTAssertEqual(result?.total, expectation?.total)
        XCTAssertEqual(result?.error, expectation?.error)
        XCTAssertEqual(result?.page, expectation?.page)
    }
    
    func test_fetchData_searchText_is_empty() {
        //given
        let searchText = ""
        let url = "https://api.itbook.store/1.0/search/\(searchText)"
        let mockResponse: MockURLSession.Response = {
            let data: Data? = JsonLoader.data(fileName: "SearchTextNilItBookStore")
            let successResponse = HTTPURLResponse(
                url: URL(string: url)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: ItBookStore?
        sut.requestItBookStore(bookName: searchText) { response in
            if case let .success(itBookStore) = response {
                result = itBookStore
            }
        }
        
        //then
        let expectation: ItBookStore? = JsonLoader.load(type: ItBookStore.self, fileName: "SearchTextNilItBookStore")
        XCTAssertEqual(result?.books.count, expectation?.books.count)
        XCTAssertEqual(result?.total, expectation?.total)
        XCTAssertEqual(result?.error, expectation?.error)
        XCTAssertEqual(result?.page, expectation?.page)
    }
    
    func test_fetchData_statusCode_is_500() {
        //given
        let searchText = "mongoDB"
        let url = "https://api.itbook.store/1.0/search/\(searchText)"
        let mockResponse: MockURLSession.Response = {
            let data: Data? = JsonLoader.data(fileName: "MongoDBItBookStore")
            let successResponse = HTTPURLResponse(
                url: URL(string: url)!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = ItBookStoreManager(session: mockURLSession)
        
        //when
        var result: ItBookStoreError?
        sut.requestItBookStore(bookName: searchText) { response in
            if case let .failure(error) = response {
                result = error as? ItBookStoreError
            }
        }
        
        //then
        let expectation: ItBookStoreError = ItBookStoreError.requestFailError
        XCTAssertEqual(result, expectation)
    }
}
