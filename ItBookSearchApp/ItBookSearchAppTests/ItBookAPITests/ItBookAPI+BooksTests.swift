//
//  ItBookAPI+BooksTests.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 7/24/24.
//

import XCTest
@testable import ItBookSearchApp

final class ItBookAPI_BooksTests: XCTestCase {
    var sut: ItBookAPI.Books!
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        sut = ItBookAPI.Books(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockSession = nil
    }
    
    func test_request_with_statusCode_200_then_success() {
        // given
        mockSession.urlResponse = urlResponse(statusCode: 200)
        mockSession.data = JsonLoader.data(fileName: "Securing_DevOps_ItBookDetail")
        
        let expectation = expectation(description: "If status code is 200, ItBookAPI Books success response")
        
        // when
        let _ = sut.request(isbn13: "Test") { result in
            switch result {
            case .success(_):
                // then
                expectation.fulfill()
            case .failure(let error):
                XCTFail("ItBookAPI_Books's status code is 200, but response failed with error. (\(error.localizedDescription))")
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_request_with_error_then_fail() {
        // given
        let givenError = ItBookStoreError.requestFailError
        mockSession.urlResponse = urlResponse(statusCode: 200)
        mockSession.data = JsonLoader.data(fileName: "Securing_DevOps_ItBookDetail")
        mockSession.error = givenError
        
        let expectation = expectation(description: "If result has error, ItBookAPI Books fails to response")
        
        // when
        let _ = sut.request(isbn13: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Books's result has error, but response returns success.")
            case .failure(let error):
                // then
                XCTAssertEqual(error as? ItBookStoreError, givenError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_request_with_statusCode_300_then_fail() {
        // given
        mockSession.urlResponse = urlResponse(statusCode: 300)
        mockSession.data = JsonLoader.data(fileName: "Securing_DevOps_ItBookDetail")
        
        let expectation = expectation(description: "If status code is 300, ItBookAPI Books fails to response")
        
        // when
        let _ = sut.request(isbn13: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Books's status code is 300, but response returns success.")
            case .failure(let error):
                // then
                XCTAssertEqual(error as? ItBookStoreError, ItBookStoreError.requestFailError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_request_with_statusCode_200_and_empty_data_then_fail() {
        // given
        mockSession.urlResponse = urlResponse(statusCode: 200)
        
        let expectation = expectation(description: "If status code is 200 with empty data, ItBookAPI Books fails to response")
        
        // when
        let _ = sut.request(isbn13: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Books's status code is 200, but response failed with error.")
            case .failure(let error):
                // then
                XCTAssertEqual(error as? ItBookStoreError, ItBookStoreError.requestFailError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_request_with_statusCode_200_and_wrong_data_then_fail() {
        // given
        mockSession.urlResponse = urlResponse(statusCode: 200)
        mockSession.data = "Wrong Data".data(using: .utf8)
        
        let expectation = expectation(description: "If status code is 200 with wrong data, ItBookAPI Books fails to response")
        
        // when
        let _ = sut.request(isbn13: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Books's status code is 200, but response failed with error.")
            case .failure(let error):
                // then
                XCTAssertEqual(error as? ItBookStoreError, ItBookStoreError.jsonParsingError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}

extension ItBookAPI_BooksTests {
    private func urlResponse(statusCode: Int) -> HTTPURLResponse {
        let url = URL(string: "https://api.itbook.store/1.0/books/")!
        
        return .init(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
