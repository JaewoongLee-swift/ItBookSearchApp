//
//  ItBookStore.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/08.
//

import Foundation

struct ItBookStore: Decodable {
    let error: String
    let total: String
    let page: String
    let books: [ItBook]
    
    enum CodingKeys: CodingKey {
        case error
        case total
        case page
        case books
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = (try? container.decode(String.self, forKey: .error)) ?? "0"
        self.total = (try? container.decode(String.self, forKey: .total)) ?? "0"
        self.page = (try? container.decode(String.self, forKey: .page)) ?? "0"
        self.books = (try? container.decode([ItBook].self, forKey: .books)) ?? []
    }
}

struct ItBook: Decodable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let imageURL: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case isbn13
        case price
        case imageURL = "image"
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = (try? container.decode(String.self, forKey: .title)) ?? "제목오류"
        self.subtitle = (try? container.decode(String.self, forKey: .subtitle)) ?? "부제오류"
        self.isbn13 = (try? container.decode(String.self, forKey: .isbn13)) ?? ""
        self.price = (try? container.decode(String.self, forKey: .price)) ?? "$0"
        self.imageURL = (try? container.decode(String.self, forKey: .imageURL)) ?? "https://itbook.store/img/books/9781449344689.png"
        self.url = (try? container.decode(String.self, forKey: .url)) ?? "https://itbook.store/books/9781449344689"
    }
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
