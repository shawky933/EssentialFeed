//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 18.12.24.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
