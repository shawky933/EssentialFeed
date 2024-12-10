//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 10.12.24.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    init(client: Any) {

    }
}

final class RemoteFeedImageDataLoaderTests: XCTestCase {

    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    // MARK: - Helper

    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeak(client)
        trackForMemoryLeak(sut)
        return (sut: sut, client: client)
    }

    private class HTTPClientSpy {
        let requestedURLs = [URL]()
    }
}
