//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 09.12.24.
//

struct FeedErrorViewModel {
    let message: String?

    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        FeedErrorViewModel(message: message)
    }
}
