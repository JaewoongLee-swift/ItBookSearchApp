//
//  ItBookStore.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/08.
//

import Foundation

struct ItBookStore {
    let error: String
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

struct ItBookDetail {
    let error: Int
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let language: String
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    let price: String
    let imageURL: String
    let url: String
    let pdf: ItBookPDF?
}

struct ItBookPDF {
    let chapter2: String
    let chapter5: String
}
