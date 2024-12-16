//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 16.12.24.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
