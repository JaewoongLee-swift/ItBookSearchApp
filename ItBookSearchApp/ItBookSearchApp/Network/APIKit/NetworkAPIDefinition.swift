//
//  NetworkAPIDefinition.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 7/10/24.
//

import Foundation

protocol NetworkAPIDefinition {
    typealias URLInfo = NetworkAPI.URLInfo
    typealias RequestInfo = NetworkAPI.RequestInfo
    
    associatedtype Parameter: Encodable
    associatedtype Response: Decodable
    
    var urlInfo: URLInfo { get }
    var requestInfo: RequestInfo<Parameter> { get }
    var session: URLSessionProtocol { get }
}

extension NetworkAPIDefinition {
    func request(completion: @escaping (Result<Response, Error>) -> Void) -> URLSessionDataTaskProtocol {
        let url = urlInfo.url
        let request = requestInfo.request(url: url)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data else { return }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
        return dataTask
    }
}


