//
//  ItBookAPI+Search.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 7/18/24.
//

import Foundation

extension ItBookAPI {
    struct Search: NetworkAPIDefinition {
        typealias Response = ItBookStore
        
        var urlInfo: URLInfo
        let requestInfo: RequestInfo<EmptyParameter> = .init(method: .get)
        let session: URLSessionProtocol
        
        private let defaultPath: String
        
        init(session: URLSessionProtocol = URLSession.shared) {
            let path = "/1.0/search"
            
            self.urlInfo = .ItBookAPI(path: path)
            self.session = session
            self.defaultPath = path
        }
    }
}

extension ItBookAPI.Search {
    mutating func request(bookName: String, page: Int? = nil, completion: @escaping (Result<ItBookStore, Error>) -> Void) -> URLSessionDataTaskProtocol {
        let bookPath = "/" + bookName
        urlInfo.setPath(defaultPath + bookPath)
        
        if let page {
            let pagePath = "/" + String(page)
            urlInfo.setPath(defaultPath + bookPath + pagePath)
        }
        let request = requestInfo.request(url: urlInfo.url)
        print("### Request URL : \(urlInfo.url)")
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error { 
                completion(.failure(error))
                return
            }
            
            if let data,
               let response = response as? HTTPURLResponse,
               (200..<300) ~= response.statusCode {
                do {
                    let data = try JSONDecoder().decode(ItBookStore.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(ItBookStoreError.jsonParsingError))
                }
            } else {
                completion(.failure(ItBookStoreError.requestFailError))
            }
        }
        
        dataTask.resume()
        
        return dataTask
    }
}
