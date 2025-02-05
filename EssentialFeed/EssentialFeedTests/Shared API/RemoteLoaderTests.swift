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

    func test_load_deliversErrorOnMapperError() throws {
        let (sut, client) = makeSUT(mapper: { _, _ in
            throw anyNSError()
        })

        try expect(sut, toCompleteWith: failure(.invalidData)) {
            client.complete(withStatusCode: 200, data: anyData())
        }
    }

    func test_load_deliversMappedResource() throws {
        let resource = "a resource"
        let (sut, client) = makeSUT { data, _ in
            String(data: data, encoding: .utf8)!
        }

        try expect(sut, toCompleteWith: .success(resource)) {
            client.complete(withStatusCode: 200, data: Data(resource.utf8))
        }
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() throws {

        let url: URL = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteLoader<String>? = RemoteLoader<String>(url: url, client: client, mapper: { _, _ in "any" })

        var capturedResults = [RemoteLoader<String>.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: try makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        mapper: @escaping RemoteLoader<String>.Mapper = { _, _ in "any" },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteLoader<String>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader<String>(url: url, client: client, mapper: mapper)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }

    private func failure(_ error: RemoteLoader<String>.Error) -> RemoteLoader<String>.Result {
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
        _ sut: RemoteLoader<String>,
        toCompleteWith expectedResult: RemoteLoader<String>.Result,
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
                .failure(receivedError as RemoteLoader<String>.Error),
                .failure(expectedError as RemoteLoader<String>.Error)
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
