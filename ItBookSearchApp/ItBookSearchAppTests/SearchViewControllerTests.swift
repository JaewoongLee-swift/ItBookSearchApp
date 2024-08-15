//
//  SearchViewControllerTests.swift
//  ItBookSearchAppTests
//
//  Created by 이재웅 on 2022/11/11.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest

@testable import ItBookSearchApp

final class SearchViewControllerTest: XCTestCase {
    var sut: SearchViewController!
    var reactor: SearchReactor!
    var imageFetcher: ImageFetcher!
    var mockSearchApiSession: MockURLSession!
    var mockImageFetchSession: MockURLSession!
    var mockMemoryCacheable: MockImageCacheable!
    var mockDiskCacheable: MockImageCacheable!

    override func setUpWithError() throws {
        mockImageFetchSession = MockURLSession()
        mockMemoryCacheable = MockImageCacheable()
        mockDiskCacheable = MockImageCacheable()
        imageFetcher = ImageFetcher(
            memoryCacheManager: mockMemoryCacheable,
            diskCacheManager: mockDiskCacheable,
            session: mockImageFetchSession
        )
        
        mockSearchApiSession = MockURLSession()
        reactor = SearchReactor(
            searchApi: ItBookAPI.Search(session: mockSearchApiSession),
            imageFetcher: imageFetcher
        )
        reactor.isStubEnabled = true
        
        sut = SearchViewController()
        sut.reactor = reactor
        sut.loadView()
        sut.viewDidLoad()
    }

    override func tearDownWithError() throws {
        sut = nil
        reactor = nil
        imageFetcher = nil
        mockSearchApiSession = nil
        mockImageFetchSession = nil
        mockMemoryCacheable = nil
        mockDiskCacheable = nil
    }
    
    func test_searchBar에_텍스트가_입력되면_reactor_actions에_텍스트가_전달됨() throws {
        // given
        let searchTitle = "swift"
        let expectation = expectation(description: "")
        let searchBar = try XCTUnwrap(sut.navigationItem.searchController?.searchBar)

        // when
        searchBar.text = searchTitle
        searchBar.delegate?.searchBarTextDidEndEditing?(searchBar)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        // then
        XCTAssertEqual(reactor.stub.actions.last, .search(query: searchTitle))
    }
    
    func test_collectionView의_prefetchItems가_실행되면_reactor_actions에_prefetchRows가_전달됨() throws {
        // given
        let collectionView = sut.collectionView
        let prefetchedIndexPath = IndexPath(row: 0, section: 0)
        
        // when
        collectionView.prefetchDataSource?.collectionView(collectionView, prefetchItemsAt: [prefetchedIndexPath])
        
        // then
        XCTAssertEqual(reactor.stub.actions.last, .prefetchRows(rows: [prefetchedIndexPath.row]))
    }
    
    func test_collectionView의_contentOffset이_변경될_경우_reactor_actions에_loadMore가_전달됨() throws {
        // given
        let collectionView = sut.collectionView
        let collectionViewContentSizeHeight = collectionView.contentSize.height
        let collectionViewHeight = collectionView.frame.height
        let contentOffsets = [
            CGPoint(x: 0, y: (collectionViewContentSizeHeight - collectionViewHeight) + 1),
            CGPoint(x: 0, y: (collectionViewContentSizeHeight - collectionViewHeight) - 1)
        ]
        
        // when
        for contentOffset in contentOffsets {
            collectionView.contentOffset = contentOffset
            
            XCTAssertEqual(reactor.stub.actions.last, .loadMore(contentOffset.y > (collectionViewContentSizeHeight - collectionViewHeight)))
        }
    }
    
    func test_collectionView에_itemSelected가_실행되면_reactor_actions에_selectItem이_전달됨() throws {
        // given
        let collectionView = sut.collectionView
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        
        // when
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: selectedIndexPath)
        
        // then
        XCTAssertEqual(reactor.stub.actions.last, .selectItem(index: selectedIndexPath.row))
    }
    
    func test_reactor_state_books가_전달되면_collectionView_items에_등록됨() throws {
        // given
        let itBookStoreData = try XCTUnwrap(JsonLoader.data(fileName: "SwiftItBookStore"))
        let itBookStore = try JSONDecoder().decode(ItBookStore.self, from: itBookStoreData)
        let books = itBookStore.books
        
        // when
        reactor.stub.state.value = .init(books: books)
        
        // then
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), books.count)
    }
    
    func test_reactor_state_totalPage가_전달되면_totalLabel에_등록됨() throws {
        // given
        let totalPage = 10
        
        // when
        reactor.stub.state.value = .init(totalPage: totalPage)
        
        // then
        XCTAssertEqual(sut.totalLabel.text, "TotalPage : \(totalPage)")
    }
    
    func test_reactor_state_currentPage가_전달되면_pageLabel에_등록됨() throws {
        // given
        let currentPage = 10
        
        // when
        reactor.stub.state.value = .init(currentPage: currentPage)
        
        // then
        XCTAssertEqual(sut.pageLabel.text, "CurrentPage : \(currentPage)")
    }
    
    func test_reactor_state_error가_전달되면_errorLabel에_등록됨() throws {
        // given
        let errorMessage = "Error"
        
        // when
        reactor.stub.state.value = .init(error: errorMessage)
        
        // then
        XCTAssertEqual(sut.errorLabel.text, "Error Message : \(errorMessage)")
    }
    
    func test_reactor_state_selectedItem이_전달되면_DetailViewController가_push됨() throws {
        // given
        sut.detailViewController = DetailViewController(
            isbn13: "Test",
            booksApi: .init(session: MockURLSession())
        )
        let navigationController = UINavigationController(rootViewController: sut)
        
        let itBookStoreData = try XCTUnwrap(JsonLoader.data(fileName: "SwiftItBookStore"))
        let itBookStore = try JSONDecoder().decode(ItBookStore.self, from: itBookStoreData)
        let itBook = try XCTUnwrap(itBookStore.books.first)
        
        let beforeViewControllerCount = navigationController.viewControllers.count
        
        let pushExpectation = expectation(description: "")
        
        // when
        reactor.stub.state.value = .init(selectedItem: itBook)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            pushExpectation.fulfill()
        }
        wait(for: [pushExpectation], timeout: 2)
        
        // then
        XCTAssertEqual(beforeViewControllerCount + 1, navigationController.viewControllers.count)
        XCTAssertTrue(navigationController.topViewController is DetailViewController)
    }
}
