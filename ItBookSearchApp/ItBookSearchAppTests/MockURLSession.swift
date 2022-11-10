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
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.response.data,
                              self.response.urlResponse,
                              self.response.error)
        }
    }
}
