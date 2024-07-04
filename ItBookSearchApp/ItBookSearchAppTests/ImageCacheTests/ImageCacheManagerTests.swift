//
//  ImageCacheManagerTests.swift
//  ItBookSearchAppTests
//
//  Created by Jaewoong Lee on 6/22/24.
//

import XCTest
@testable import ItBookSearchApp

final class ImageCacheManagerTests: XCTestCase {
    var memoryCache: MockImageCacheable!
    var diskCache: MockImageCacheable!
    var session: MockURLSession!
    var sut: ImageCacheManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        memoryCache = MockImageCacheable()
        diskCache = MockImageCacheable()
        session = MockURLSession()
        
        sut = .init(
            memoryCacheManager: memoryCache,
            diskCacheManager: diskCache,
            session: session
        )
    }
    
    override func tearDownWithError() throws {
        memoryCache = nil
        diskCache = nil
        session = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testFetchImage_FromMemoryCache() {
        // given
        let image = TestImageLoader.loadImage(resourceName: "mockImage", type: "png")
        let urlString = "testKey"
        memoryCache.storage[urlString] = image
        
        let expectation = self.expectation(description: "Image fetch from memory cache")
        
        // when
        let _ = sut.fetchImage(from: urlString) { fetchedImage in
            // then
            XCTAssertEqual(fetchedImage, image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testFetchImage_FromDiskCache() throws {
        // given
        guard let image = TestImageLoader.loadImage(resourceName: "mockImage", type: "png"),
        let compressedData = image.jpegData(compressionQuality: 1.0),
        let compressedImage = UIImage(data: compressedData) else {
            XCTFail("\(#function) mockImage를 찾을 수 없습니다.")
            return
        }
        
        let urlString = "testKey"
        diskCache.storage[urlString] = compressedImage
        
        let expectation = self.expectation(description: "Image fetch from disk cache")
        
        // when
        let _ = sut.fetchImage(from: urlString) { fetchedImage in
            // then
            XCTAssertEqual(fetchedImage, compressedImage)
            XCTAssertEqual(self.memoryCache.storage[urlString], compressedImage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testFetchImage_FromNetwork() throws {
        // given
        guard let image = TestImageLoader.loadImage(resourceName: "mockImage", type: "png") else {
            XCTFail("\(#function) mockImage를 찾을 수 없습니다.")
            return
        }
        let urlString = "https://example.com/testImage"
        session.data = image.pngData()
        
        let expectation = self.expectation(description: "Image fetch from network")
        
        // when
        let task = sut.fetchImage(from: urlString) { fetchedImage in
            XCTAssertEqual(fetchedImage?.pngData(), image.pngData())
            XCTAssertEqual(self.memoryCache.storage[urlString]?.pngData(), image.pngData())
            XCTAssertEqual(self.diskCache.storage[urlString]?.pngData(), image.pngData())
            expectation.fulfill()
        }
        
        XCTAssertNotNil(task)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testFetchImage_Cancellation() throws {
        // given
        guard let image = TestImageLoader.loadImage(resourceName: "mockImage", type: "png") else {
            XCTFail("\(#function) mockImage를 찾을 수 없습니다.")
            return
        }
        let urlString = "https://example.com/testImage"
        session.data = image.jpegData(compressionQuality: 1.0)
        
        let expectation = self.expectation(description: "Image fetch cancelled")
        
        // when
        let task = sut.fetchImage(from: urlString) { fetchedImage in
            // then
            XCTFail("Fetch should have been cancelled")
        }
        
        task?.cancel()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchImage_URLCreationFailure() {
        // given
        let urlString = ""
        
        let expectation = self.expectation(description: "URL creation failure")
        
        // when
        let task = sut.fetchImage(from: urlString) { fetchedImage in
            // then
            XCTAssertNil(fetchedImage, "Image should be nil due to URL creation failure")
            expectation.fulfill()
        }
        
        
        XCTAssertNil(task)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchImage_SessionError() {
        // given
        let urlString = "https://example.com/testImage"
        let sessionError = NSError(domain: "testError", code: 0, userInfo: nil)
        session.error = sessionError
        
        let expectation = self.expectation(description: "Session error")
        
        // when
        let task = sut.fetchImage(from: urlString) { fetchedImage in
            // then
            XCTAssertNil(fetchedImage, "Image should be nil due to session error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
