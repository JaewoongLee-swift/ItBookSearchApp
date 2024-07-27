//
//  Extension+URLResponse.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 7/27/24.
//

import Foundation

extension URLResponse {
    static func searchURLResponse(statusCode: Int) -> HTTPURLResponse {
        let url = URL(string: "https://api.itbook.store/1.0/search/")!
        
        return .init(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    static func booksURLResponse(statusCode: Int) -> HTTPURLResponse {
        let url = URL(string: "https://api.itbook.store/1.0/books/")!
        
        return .init(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
