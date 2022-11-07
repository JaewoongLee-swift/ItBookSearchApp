//
//  ItBookStore.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/08.
//

import Foundation

struct ItBookStore {
    let error: Int
    let total: String
    let page: String
    let books: [ItBook]
}

struct ItBook {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let imageURL: String
    let url: String
}
