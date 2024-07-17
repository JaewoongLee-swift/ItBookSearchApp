//
//  URLSessionProtocol.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: urlRequest, completionHandler: completionHandler) as URLSessionDataTask
    }
}
