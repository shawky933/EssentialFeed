//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 16.12.24.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
