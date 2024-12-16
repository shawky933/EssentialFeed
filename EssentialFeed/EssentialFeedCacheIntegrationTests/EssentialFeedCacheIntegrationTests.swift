//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Shawky Elhanak on 20.11.24.
//

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()

        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()

        undoStoreSideEffects()
    }

    func test_load_deliversNoItemsOnEmptyCache() throws {
        let sut = try makeFeedLoader()

        expect(sut, toLoad: [])
    }

    func test_load_deliversItemsSavedOnASeparateInstance() throws {
        let sutToPerformSave = try makeFeedLoader()
        let sutToPerformLoad = try makeFeedLoader()
        let feed = uniqueImageFeed().models

        save(feed, with: sutToPerformSave)

        expect(sutToPerformLoad, toLoad: feed)
    }

    func test_save_overridesItemsSavedOnASeparateInstance() throws {
        let sutToPerformFirstSave = try makeFeedLoader()
        let sutToPerformLastSave = try makeFeedLoader()
        let sutToPerformLoad = try makeFeedLoader()
        let firstFeed = uniqueImageFeed().models
        let latestFeed = uniqueImageFeed().models

        save(firstFeed, with: sutToPerformFirstSave)
        save(latestFeed, with: sutToPerformLastSave)

        expect(sutToPerformLoad, toLoad: latestFeed)
    }

    // MARK: - LocalFeedImageDataLoader Tests

    func test_loadImageData_deliversSavedDataOnASeparateInstance() throws {
        let imageLoaderToPerformSave = try makeImageLoader()
        let imageLoaderToPerformLoad = try makeImageLoader()
        let feedLoader = try makeFeedLoader()
        let image = uniqueImage()
        let dataToSave = anyData()

        save([image], with: feedLoader)
        save(dataToSave, for: image.url, with: imageLoaderToPerformSave)

        expect(imageLoaderToPerformLoad, toLoad: dataToSave, for: image.url)
    }

    // MARK: - Helpers

    private func makeFeedLoader(file: StaticString = #filePath, line: UInt = #line) throws -> LocalFeedLoader {
        let storeURL = testSpecificStoreURL()
        let feedStore = try CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedLoader(store: feedStore, currentDate: Date.init)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(feedStore, file: file, line: line)
        return sut
    }

    private func makeImageLoader(file: StaticString = #file, line: UInt = #line) throws -> LocalFeedImageDataLoader {
        let storeURL = testSpecificStoreURL()
        let store = try CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func expect(
        _ sut: LocalFeedLoader,
        toLoad feed: [FeedImage],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(imageFeed):
                XCTAssertEqual(imageFeed, feed, "Expected empty feed", file: file, line: line)

            case let .failure(error):
                XCTFail("Expected success got \(error) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func save(
        _ feed: [FeedImage],
        with sut: LocalFeedLoader,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for save completion")
        sut.save(feed) { result in
            if case let .failure(error) = result {
                XCTFail("Expected to save feed successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func save(
        _ data: Data,
        for url: URL,
        with loader: LocalFeedImageDataLoader,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let saveExp = expectation(description: "Wait for save completion")
        loader.save(data, for: url) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to save image data successfully, got error: \(error)", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
    }

    private func expect(
        _ sut: LocalFeedImageDataLoader,
        toLoad expectedData: Data,
        for url: URL,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case let .success(loadedData):
                XCTAssertEqual(loadedData, expectedData, file: file, line: line)

            case let .failure(error):
                XCTFail("Expected successful image data result, got \(error) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }

    private func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
