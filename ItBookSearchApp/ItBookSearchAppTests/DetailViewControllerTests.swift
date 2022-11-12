//
//  DetailViewControllerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/12.
//

import XCTest
@testable import ItBookSearchApp

final class DetailViewControllerTests: XCTestCase {
    var sut: DetailViewController!

    override func setUpWithError() throws {
        self.sut = DetailViewController(isbn13: "9781491985571")
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_requestItBookDetail_성공적으로_호출하면_itBookDetail에_데이터가_할당된다() {
        // given
        let isbn13 = "9781491985571"
        let url = "https://api.itbook.store/1.0/books/\(isbn13)"
        let data: Data? = JsonLoader.data(fileName: "FileWeb_Scraping_with_Python_ItBookDetail")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookDetailManager(session: mockURLSession)
        
        //when
        var result: ItBookDetail?
        sut.requestItBookDetail(from: isbn13, by: networkManager)
        
        result = sut.itBookDetail
        
        XCTAssertNotNil(result)
    }
    
    func test_requestItBookDetail_호출실패하면_itBookDetail에_데이터는_nil() {
        // given
        let isbn13 = "9781491985571"
        let url = "https://api.itbook.store/1.0/books/\(isbn13)"
        let data: Data? = JsonLoader.data(fileName: "FileWeb_Scraping_with_Python_ItBookDetail")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 500)
        let networkManager = ItBookDetailManager(session: mockURLSession)
        
        //when
        var result: ItBookDetail?
        sut.requestItBookDetail(from: isbn13, by: networkManager)
        
        result = sut.itBookDetail
        
        XCTAssertNil(result)
    }
    
    func test_requestItBookDetail_pdf없는_데이터_itBookDetail의_pdf_nil() {
        // given
        let isbn13 = "9781491985571"
        let url = "https://api.itbook.store/1.0/books/\(isbn13)"
        let data: Data? = JsonLoader.data(fileName: "FileWeb_Scraping_with_Python_ItBookDetail")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookDetailManager(session: mockURLSession)
        
        //when
        var result: ItBookPDF?
        sut.requestItBookDetail(from: isbn13, by: networkManager)
        
        result = sut.itBookDetail?.pdf
        
        XCTAssertNil(result)
    }
    
    func test_requestItBookDetail_pdf있는_데이터_itBookDetail의_pdf_존재() {
        // given
        let isbn13 = "9781617294136"
        let url = "https://api.itbook.store/1.0/books/\(isbn13)"
        let data: Data? = JsonLoader.data(fileName: "Securing_DevOps_ItBookDetail")
        let mockURLSession = MockURLSession.make(
            url: url, data: data, statusCode: 200)
        let networkManager = ItBookDetailManager(session: mockURLSession)
        
        //when
        var result: ItBookPDF?
        sut.requestItBookDetail(from: isbn13, by: networkManager)
        
        result = sut.itBookDetail?.pdf
        
        XCTAssertNotNil(result)
    }
}
