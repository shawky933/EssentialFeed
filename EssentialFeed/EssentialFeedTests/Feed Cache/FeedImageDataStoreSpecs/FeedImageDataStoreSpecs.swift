//
//  FeedImageDataStoreSpecs.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 26.02.25.
//

import Foundation

protocol FeedImageDataStoreSpecs {
	func test_retrieveImageData_deliversNotFoundWhenEmpty() throws
	func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws
	func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws
	func test_retrieveImageData_deliversLastInsertedValue() throws
}
