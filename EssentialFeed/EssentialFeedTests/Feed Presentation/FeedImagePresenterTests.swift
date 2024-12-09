//
//  FeedImagePresenterTests.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 09.12.24.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {

    }
}

class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy {
        let messages = [Any]()
    }
}
