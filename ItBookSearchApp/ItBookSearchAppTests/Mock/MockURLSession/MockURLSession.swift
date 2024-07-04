//
//  MockURLSession.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import Foundation
@testable import ItBookSearchApp

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ItBookSearchApp.URLSessionDataTaskProtocol {
        return MockURLSessionDataTask(resumeHandler: {
            completionHandler(self.data,
                              self.urlResponse,
                              self.error)
        })
    }
    
    static func make(url: String, data: Data?, statusCode: Int) -> MockURLSession {
        .init(data: data,
              urlResponse: HTTPURLResponse(url: URL(string: url)!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil),
              error: nil)
    }
}
