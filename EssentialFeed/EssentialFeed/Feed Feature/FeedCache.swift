//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 18.12.24.
//

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
