//
//  MockURLSessionDataTask.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import Foundation
@testable import ItBookSearchApp

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    //실제 네트워크 요청이 아닌 단순 completionHandler 호출용
    func resume() {
        resumeHandler()
    }
}
