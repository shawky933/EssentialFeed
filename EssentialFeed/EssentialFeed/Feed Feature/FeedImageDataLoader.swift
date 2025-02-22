//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 30.11.24.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
