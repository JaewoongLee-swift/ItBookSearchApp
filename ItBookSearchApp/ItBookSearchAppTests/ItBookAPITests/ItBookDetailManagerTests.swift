//
//  ItBookDetailManagerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import XCTest
@testable import ItBookSearchApp

final class ItBookDetailManagerTests: XCTestCase {
    var url: String?
    var data: Data?

    override func setUpWithError() throws {
        url = "https://api.itbook.store/1.0/books/9781617294136"
        data = JsonLoader.data(fileName: "ItBookStore")
    }

    override func tearDownWithError() throws {
        url = nil
        data = nil
    }
    
    func test_fetchData_statusCode_is_200() {
        //given
        let isbn13 = "9781617294136"
        let url = "https://api.itbook.store/1.0/search/\(isbn13)"
        let data: Data? = JsonLoader.data(fileName: "Securing_DevOps_ItBookDetail")

        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let sut = ItBookDetailManager(session: mockURLSession)
        let expectation: ItBookDetail? = JsonLoader.load(type: ItBookDetail.self, fileName: "Securing_DevOps_ItBookDetail")
        let expectationForWait = self.expectation(description: "ItBookDetail fetch with status code 200")
        
        //when
        var result: ItBookDetail?
        sut.requestItBookDetail(isbn13: isbn13) { response in
            if case .success(let itBookDetail) = response {
                result = itBookDetail
            }
            
            //then
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.getTitle(), expectation?.getTitle())
            XCTAssertEqual(result?.getISBN13(), expectation?.getISBN13())
            XCTAssertEqual(result?.getPDFs()?.chapter2, expectation?.getPDFs()?.chapter2)
            XCTAssertEqual(result?.getPDFs()?.chapter5, expectation?.getPDFs()?.chapter5)
            
            expectationForWait.fulfill()
        }
        
        wait(for: [expectationForWait], timeout: 10.0)
    }
    
    func test_fetchData_pdf_is_empty() {
        //given
        let isbn13 = "9781491985571"
        let url = "https://api.itbook.store/1.0/search/\(isbn13)"
        let data: Data? = JsonLoader.data(fileName: "FileWeb_Scraping_with_Python_ItBookDetail")

        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let sut = ItBookDetailManager(session: mockURLSession)
        let expectation: ItBookDetail? = JsonLoader.load(type: ItBookDetail.self, fileName: "FileWeb_Scraping_with_Python_ItBookDetail")
        let expectationForWait = self.expectation(description: "ItBookDetail fetch with status code 200, but no pdfs")
        
        //when
        var result: ItBookDetail?
        sut.requestItBookDetail(isbn13: isbn13) { response in
            if case .success(let itBookDetail) = response {
                result = itBookDetail
            }
            
            //then
            XCTAssertEqual(result?.getTitle(), expectation?.getTitle())
            XCTAssertEqual(result?.getISBN13(), expectation?.getISBN13())
            XCTAssertNil(result?.getPDFs())
            
            expectationForWait.fulfill()
        }
        
        wait(for: [expectationForWait], timeout: 10.0)
    }
    
    func test_fetchData_statusCode_is_500() {
        //given
        let isbn13 = "9781491985571"
        let url = "https://api.itbook.store/1.0/search/\(isbn13)"
        let data: Data? = JsonLoader.data(fileName: "FileWeb_Scraping_with_Python_ItBookDetail")

        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let sut = ItBookDetailManager(session: mockURLSession)
        let expectation: ItBookStoreError? = ItBookStoreError.requestFailError
        let expectationForWait = self.expectation(description: "ItBookDetail fetch with status code 500")
        
        //when
        var result: ItBookStoreError?
        sut.requestItBookDetail(isbn13: isbn13) { response in
            if case .failure(let error) = response {
                result = error as? ItBookStoreError
            }
            
            //then
            XCTAssertEqual(result, expectation)
            expectationForWait.fulfill()
        }
        
        wait(for: [expectationForWait], timeout: 10.0)
    }
}
