//
//  File.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 16.12.24.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

	public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {

	}

	public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
		completion(.success(.none))
	}

}
