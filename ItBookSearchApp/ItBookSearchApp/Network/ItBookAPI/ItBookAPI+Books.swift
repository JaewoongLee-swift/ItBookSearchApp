//
//  ItBookAPI+Books.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 7/19/24.
//

import Foundation

extension ItBookAPI {
    struct Books: NetworkAPIDefinition {
        typealias Response = ItBookDetail
        
        var urlInfo: URLInfo
        let requestInfo: NetworkAPI.RequestInfo<EmptyParameter> = .init(method: .get)
        let session: URLSessionProtocol
        
        private let defaultPath: String
        
        init(session: URLSessionProtocol = URLSession.shared) {
            let path = "/1.0/books/"
            
            self.urlInfo = .ItBookAPI(path: path)
            self.session = session
            self.defaultPath = path
        }
    }
}

extension ItBookAPI.Books {
    mutating func request(isbn13: String, completion: @escaping (Result<ItBookDetail, Error>) -> Void) -> URLSessionDataTaskProtocol {
        urlInfo.setPath(defaultPath + isbn13)
        
        let request = requestInfo.request(url: urlInfo.url)
        
        let dataTask = session.dataTask(with: request) { data, response, error
            in
            if let error {
                completion(.failure(error))
                return
            }
            
            if let data,
               let response = response as? HTTPURLResponse,
               (200..<300) ~= response.statusCode {
                do {
                    let itBookDetail = try JSONDecoder().decode(ItBookDetail.self, from: data)
                    completion(.success(itBookDetail))
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
