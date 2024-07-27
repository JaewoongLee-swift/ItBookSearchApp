//
//  URLInfo+ItBookAPI.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 7/18/24.
//

import Foundation

extension NetworkAPI.URLInfo {
    static func ItBookAPI(path: String) -> Self {
        .init(host: "api.itbook.store", path: path)
    }
}
