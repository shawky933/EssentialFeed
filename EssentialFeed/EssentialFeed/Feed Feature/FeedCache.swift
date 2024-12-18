//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 18.12.24.
//

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
