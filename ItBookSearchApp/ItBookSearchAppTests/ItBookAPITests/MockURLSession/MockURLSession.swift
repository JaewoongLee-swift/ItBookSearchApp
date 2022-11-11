//
//  MockURLSession.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import Foundation
@testable import ItBookSearchApp

class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ItBookSearchApp.URLSessionDataTaskProtocol {
        return MockURLSessionDataTask(resumeHandler: {
            completionHandler(self.response.data,
                              self.response.urlResponse,
                              self.response.error)
        })
    }
    
    static func make(url: String, data: Data?, statusCode: Int) -> MockURLSession {
        let mockURLSession: MockURLSession = {
            let urlResponse = HTTPURLResponse(url: URL(string: url)!,
                                              statusCode: statusCode,
                                              httpVersion: nil,
                                              headerFields: nil)
            let mockResponse: MockURLSession.Response = (data: data,
                                                         urlResponse: urlResponse,
                                                         error: nil
            )
            let mockURLSession = MockURLSession(response: mockResponse)
            
            return mockURLSession
        }()
        
        return mockURLSession
    }
}
