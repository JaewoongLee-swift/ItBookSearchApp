//
//  SearchReactor+Extension.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 8/13/24.
//

import Foundation
@testable import ItBookSearchApp

extension SearchReactor.Action: Equatable {
    public static func == (lhs: SearchReactor.Action, rhs: SearchReactor.Action) -> Bool {
        switch lhs {
        case .search(let lhsQuery):
            switch rhs {
            case .search(let rhsQuery):
                return lhsQuery == rhsQuery
            default:
                return false
            }
        case .loadMore(let lhsBool):
            switch rhs {
            case .loadMore(let rhsBool):
                return lhsBool == rhsBool
            default:
                return false
            }
        case .selectItem(let lhsIndex):
            switch rhs {
            case .selectItem(let rhsIndex):
                return lhsIndex == rhsIndex
            default:
                return false
            }
        case .prefetchRows(let lhsRows):
            switch rhs {
            case .prefetchRows(let rhsRows):
                return lhsRows == rhsRows
            default:
                return false
            }
        }
    }
}
