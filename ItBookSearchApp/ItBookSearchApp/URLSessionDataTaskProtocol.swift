//
//  URLSessionDataTaskProtocol.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
