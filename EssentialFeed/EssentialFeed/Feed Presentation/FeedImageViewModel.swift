//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 09.12.24.
//

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
