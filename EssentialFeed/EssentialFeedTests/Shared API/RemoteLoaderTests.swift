//
//  RemoteLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Shawky Elhanak on 05.02.25.
//

import XCTest
import EssentialFeed

class RemoteLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() throws {
        let (sut, client) = makeSUT()

        try expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon200HTTPResponse() throws {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        try samples.enumerated().forEach { index, code in
            try expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = try makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() throws {
        let (sut, client) = makeSUT()

        try expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let (sut, client) = makeSUT()

        try expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = try makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONList() throws {
        let (sut, client) = makeSUT()

        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://a-url.com")!)

        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "http://another-url.com")!
        )

        let items = [item1.model, item2.model]

        try expect(sut, toCompleteWith: .success(items)) {
            let json = try makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() throws {

        let url: URL = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteLoader? = RemoteLoader(url: url, client: client)

        var capturedResults = [RemoteLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: try makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(url: url, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }

    private func failure(_ error: RemoteLoader.Error) -> RemoteLoader.Result {
        .failure(error)
    }

    private func makeItem(
        id: UUID,
        description: String? = nil,
        location: String? = nil,
        imageURL: URL
    ) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)

        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }

        return (item, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) throws -> Data {
        let json = ["items": items]
        return try JSONSerialization.data(withJSONObject: json)
    }

    private func expect(
        _ sut: RemoteLoader,
        toCompleteWith expectedResult: RemoteLoader.Result,
        when action: () throws -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (
                .failure(receivedError as RemoteLoader.Error),
                .failure(expectedError as RemoteLoader.Error)
            ):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result: \(expectedResult) got \(receivedResult) insted", file: file, line: line)
            }

            exp.fulfill()
        }

        try action()

        wait(for: [exp], timeout: 1.0)
    }
}
