//
//  MockURLSession.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import Foundation
@testable import ItBookSearchApp

class MockURLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
    }
}
