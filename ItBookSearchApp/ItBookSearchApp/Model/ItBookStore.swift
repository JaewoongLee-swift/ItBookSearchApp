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
    private let title: String
    private let subtitle: String
    private let isbn13: String
    private let price: String
    private let imageURL: String
    private let url: String
    
    func getTitle() -> String {
        return title
    }
    
    func getSubTitle() -> String {
        return subtitle
    }
    
    func getISBN13() -> String {
        return isbn13
    }
    
    func getPrice() -> String {
        return price
    }
    
    func getImageURL() -> String {
        return imageURL
    }
    
    func getURL() -> String {
        return url
    }
    
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

struct ItBookDetail: Decodable {
    let error: String
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
    
    enum CodingKeys: String, CodingKey {
        case error
        case title
        case subtitle
        case authors
        case publisher
        case language
        case isbn10
        case isbn13
        case pages
        case year
        case rating
        case desc
        case price
        case imageURL = "image"
        case url
        case pdf
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = (try? container.decode(String.self, forKey: .error)) ?? "0"
        self.title = (try? container.decode(String.self, forKey: .title)) ?? "제목오류"
        self.subtitle = (try? container.decode(String.self, forKey: .subtitle)) ?? "부제오류"
        self.authors = (try? container.decode(String.self, forKey: .authors)) ?? "저자오류"
        self.publisher = (try? container.decode(String.self, forKey: .publisher)) ?? "출판사오류"
        self.language = (try? container.decode(String.self, forKey: .language)) ?? "언어오류"
        self.isbn10 = (try? container.decode(String.self, forKey: .isbn10)) ?? "0"
        self.isbn13 = (try? container.decode(String.self, forKey: .isbn13)) ?? "0"
        self.pages = (try? container.decode(String.self, forKey: .pages)) ?? "0"
        self.year = (try? container.decode(String.self, forKey: .year)) ?? "0"
        self.rating = (try? container.decode(String.self, forKey: .rating)) ?? "0"
        self.desc = (try? container.decode(String.self, forKey: .desc)) ?? "설명오류"
        self.price = (try? container.decode(String.self, forKey: .price)) ?? "$0"
        self.imageURL = (try? container.decode(String.self, forKey: .imageURL)) ?? "https://itbook.store/img/books/9781449344689.png"
        self.url = (try? container.decode(String.self, forKey: .url)) ?? "https://itbook.store/books/9781449344689"
        self.pdf = try container.decodeIfPresent(ItBookPDF.self, forKey: .pdf)
    }
}

struct ItBookPDF: Decodable {
    let chapter2: String
    let chapter5: String
    
    enum CodingKeys: String, CodingKey {
        case chapter2 = "Chapter 2"
        case chapter5 = "Chapter 5"
    }
}
