//
//  MockURLSessionDataTask.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 6/25/24.
//

import Foundation
@testable import ItBookSearchApp

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let resumeHandler: () -> Void
    private var isCancelled = false
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            if !self.isCancelled {
                self.resumeHandler()
            }
        }
    }
    
    func cancel() {
        isCancelled = true
    }
}

