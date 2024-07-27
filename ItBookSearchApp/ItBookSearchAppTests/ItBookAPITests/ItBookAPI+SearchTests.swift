//
//  ItBookAPI+SearchTests.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 7/22/24.
//

import XCTest
@testable import ItBookSearchApp

final class ItBookAPI_SearchTests: XCTestCase {
    var sut: ItBookAPI.Search!
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws { 
        mockSession = MockURLSession()
        sut = ItBookAPI.Search(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockSession = nil
    }
    
    func test_request_with_statusCode_200_then_success() {
        // given
        mockSession.urlResponse = .searchURLResponse(statusCode: 200)
        mockSession.data = JsonLoader.data(fileName: "MongoDBItBookStore")
        
        let expectation = expectation(description: "If status code is 200, ItBookAPI Search success response")
        
        // when
        let _ = sut.request(bookName: "Test") { result in
            switch result {
            case .success(_):
                // then
                expectation.fulfill()
            case .failure(let error):
                XCTFail("ItBookAPI_Search's status code is 200, but response failed with error. (\(error.localizedDescription))")
            }
        }

        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_request_with_error_then_fail() {
        // given
        let givenError = ItBookStoreError.requestFailError
        mockSession.urlResponse = .searchURLResponse(statusCode: 200)
        mockSession.data = JsonLoader.data(fileName: "MongoDBItBookStore")
        mockSession.error = givenError

        let expectation = expectation(description: "If result has error, ItBookAPI Search fails to response")
        
        // when
        let _ = sut.request(bookName: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Search's result has error, but response returns success.")
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
        mockSession.urlResponse = .searchURLResponse(statusCode: 300)
        mockSession.data = JsonLoader.data(fileName: "MongoDBItBookStore")
        
        let expectation = expectation(description: "If status code is 300, ItBookAPI Search fails to response")
        
        // when
        let _ = sut.request(bookName: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Search's status code is 300, but response returns success.")
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
        mockSession.urlResponse = .searchURLResponse(statusCode: 200)
        
        let expectation = expectation(description: "If status code is 200 with empty data, ItBookAPI Search fails to response")
        
        // then
        let _ = sut.request(bookName: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Search's status code is 200, but response failed with error.")
            case .failure(let error):
                XCTAssertEqual(error as? ItBookStoreError, ItBookStoreError.requestFailError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_request_with_statusCode_200_and_wrong_data_then_fail() {
        // given
        mockSession.urlResponse = .searchURLResponse(statusCode: 200)
        mockSession.data = "Wrong Data".data(using: .utf8)
        
        let expectation = expectation(description: "If status code is 200 with wrong data, ItBookAPI Search fails to response")
        
        // then
        let _ = sut.request(bookName: "Test") { result in
            switch result {
            case .success(_):
                XCTFail("ItBookAPI_Search's status code is 200, but response failed with error.")
            case .failure(let error):
                XCTAssertEqual(error as? ItBookStoreError, ItBookStoreError.jsonParsingError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
