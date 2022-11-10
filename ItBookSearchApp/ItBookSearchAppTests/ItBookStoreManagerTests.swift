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
        let url = "https://api.itbook.store/1.0/search/mongodb"
        let mockResponse: MockURLSession.Response = {
            let data: Data? = JsonLoader.data(fileName: "ItBookStore")
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
        sut.requestItBookStore(bookName: "mongodb") { response in
            if case let .success(itBookStore) = response {
                result = itBookStore
            }
        }
        
        //then
        let expectation: ItBookStore? = JsonLoader.load(type: ItBookStore.self, fileName: "ItBookStore")
        XCTAssertEqual(result?.total, expectation?.total)
        XCTAssertEqual(result?.books.first?.title, expectation?.books.first?.title)
    }
}
