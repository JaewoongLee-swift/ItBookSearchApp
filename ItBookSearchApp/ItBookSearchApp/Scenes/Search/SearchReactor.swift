//
//  SearchReactor.swift
//  ItBookSearchApp
//
//  Created by Jaewoong Lee on 8/2/24.
//

import ReactorKit

class SearchReactor: Reactor {
    enum Action {
        case search(query: String)
        case loadMore
        case selectItem(index: Int)
    }
    
    enum Mutation {
           case setBooks([ItBook], Int, Int)
           case appendBooks([ItBook], Int, Int)
           case setError(String)
           case setLoading(Bool)
           case setSelectedItem(ItBook?)
       }
    
    struct State {
        var query: String = ""
        var books: [ItBook] = []
        var totalPage: Int?
        var currentPage: Int?
        var error: String?
        var isLoading: Bool = false
        var selectedItem: ItBook?
    }
    
    let initialState = State()
    
    private var searchApi: ItBookAPI.Search
    
    init(searchApi: ItBookAPI.Search) {
        self.searchApi = searchApi
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let query):
            return Observable.concat([
                Observable.just(.setLoading(true)),
                searchBooks(query: query).map { .setBooks($0.0, $0.1, $0.2) },
                Observable.just(.setLoading(false))
            ])
        case .loadMore:
            guard let currentPage = currentState.currentPage,
                  let totalPage = currentState.totalPage,
                  currentPage < totalPage else {
                return Observable.empty()
            }
            
            return searchBooks(query: currentState.query, page: currentPage + 1).map { .appendBooks($0.0, $0.1, $0.2) }
        case .selectItem(let index):
            let selectedItem = currentState.books[index]
            return Observable.just(.setSelectedItem(selectedItem))

        }
    }
    
    private func searchBooks(query: String, page: Int? = nil) -> Observable<([ItBook], Int, Int)> {
        return Observable.create { observer in
            if let page {
                let _ = self.searchApi.request(bookName: query, page: page) { result in
                    switch result {
                    case .success(let itBookStore):
                        let books = itBookStore.books
                        let totalPage = Int(itBookStore.total) ?? 0
                        let currentPage = Int(itBookStore.page) ?? 0
                        observer.onNext((books, totalPage, currentPage))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create()
            } else {
                let _ = self.searchApi.request(bookName: query) { result in
                    switch result {
                    case .success(let itBookStore):
                        let books = itBookStore.books
                        let totalPage = Int(itBookStore.total) ?? 0
                        let currentPage = Int(itBookStore.page) ?? 0
                        observer.onNext((books, totalPage, currentPage))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create()
            }
        }
    }
}
