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
        case loadMore(Bool)
        case selectItem(index: Int)
        case prefetchRows(rows: [Int])
    }
    
    enum Mutation {
        case setQuery(String)
        case setBooks([ItBook], Int, Int)
        case appendBooks([ItBook], Int)
        case setError(String)
        case setLoading(Bool)
        case setSelectedItem(ItBook?)
    }
    
    struct State {
        var query: String = ""
        var books: [ItBook] = []
        var totalPage: Int = 0
        var currentPage: Int = 0
        var error: String?
        var isLoading: Bool = false
        var pageEnd: Bool = false
        var selectedItem: ItBook?
    }
    
    let initialState = State()
    
    private var searchApi: ItBookAPI.Search
    private let imageFetcher: ImageFetcher
    
    init(searchApi: ItBookAPI.Search, imageFetcher: ImageFetcher) {
        self.searchApi = searchApi
        self.imageFetcher = imageFetcher
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let query):
            return Observable.concat([
                Observable.just(.setQuery(query)),
                Observable.just(.setLoading(true)),
                searchBooks(query: query).map { .setBooks($0.0, $0.1, $0.2) },
                Observable.just(.setLoading(false))
            ])
        case .loadMore(let loadMore):
            guard currentState.currentPage < currentState.totalPage
                    && !currentState.pageEnd
                    && loadMore 
                    && !currentState.isLoading else {
                return Observable.empty()
            }
            
            return Observable.concat([
                Observable.just(.setLoading(true)),
                searchBooks(query: currentState.query, page: currentState.currentPage + 1).map { .appendBooks($0.0, $0.2) },
                Observable.just(.setLoading(false))
            ])
        case .selectItem(let index):
            let selectedItem = currentState.books[index]
            return Observable.just(.setSelectedItem(selectedItem))
        case .prefetchRows(let rows):
            for row in rows {
                _ = imageFetcher.fetchImage(from: currentState.books[row].getImageURL()) { _ in }
            }
            
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.selectedItem = nil
        
        switch mutation {
        case .setQuery(let query):
            newState.query = query
        case .setBooks(let books, let totalPage, let currentPage):
            newState.books = books
            newState.totalPage = totalPage
            newState.currentPage = currentPage
        case .appendBooks(let books, let currentPage):
            reduceAppendBooks(books: books, currentPage: currentPage, newState: &newState)
        case .setError(let error):
            newState.error = error
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setSelectedItem(let selectedItem):
            newState.selectedItem = selectedItem
        }
        
        return newState
    }
    
    private func reduceAppendBooks(books: [ItBook], currentPage: Int, newState: inout State) {
        if books.isEmpty || currentPage == newState.totalPage {
            newState.pageEnd = true
        } else {
            newState.pageEnd = false
            newState.books.append(contentsOf: books)
            newState.currentPage = currentPage
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
