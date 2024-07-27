//
//  NetworkAPI+URLInfo.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 7/10/24.
//

import Foundation

extension NetworkAPI {
    struct URLInfo {
        let scheme: String
        let host: String
        let port: Int?
        private(set) var path: String
        let query: [String: String]?
        
        init(
            scheme: String = "https",
            host: String,
            port: Int? = nil,
            path: String,
            query: [String : String]? = nil
        ) {
            self.scheme = scheme
            self.host = host
            self.port = port
            self.path = path
            self.query = query
        }
    }
}

extension NetworkAPI.URLInfo {
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = path
        components.percentEncodedQueryItems = query?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            assertionFailure("URL 정보를 확인해주세요.")
            return .init(string: "https://\(host)")!
        }
        
        return url
    }
    
    mutating func addPath(_ path: String) {
        self.path += path
    }
}
