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
        
        let urlInfo: URLInfo
        let requestInfo: NetworkAPI.RequestInfo<EmptyParameter> = .init(method: .get)
        let session: URLSessionProtocol
        
        init(isbn13: String,
             session: URLSessionProtocol = URLSession.shared) {
            self.urlInfo = .ItBookAPI(path: "/1.0/books/\(isbn13)")
            self.session = session
        }
    }
}

extension ItBookAPI.Books {
    func request(completion: @escaping (Result<ItBookDetail, Error>) -> Void) -> URLSessionDataTaskProtocol {
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
