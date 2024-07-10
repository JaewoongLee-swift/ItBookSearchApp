//
//  NetworkAPIDefinition.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 7/10/24.
//

import Foundation

protocol NetworkAPIDefinition {
    associatedtype Parameter: Encodable
    associatedtype Response: Decodable
    
    var urlInfo: NetworkAPI.URLInfo { get }
    var method: NetworkAPI.Method { get }
    var headers: [String: String]? { get }
    var parameters: Parameter? { get }
}
