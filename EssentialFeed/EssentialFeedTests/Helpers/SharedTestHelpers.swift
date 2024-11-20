//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Shawky Elhanak on 12.11.24.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any Error", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}
