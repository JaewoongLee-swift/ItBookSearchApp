//
//  URLSessionProtocol.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}
