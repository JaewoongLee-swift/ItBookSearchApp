//
//  ItBookDetailManagerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import XCTest

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
}
