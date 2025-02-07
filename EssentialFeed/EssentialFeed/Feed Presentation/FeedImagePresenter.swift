//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 09.12.24.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(description: image.description, location: image.location)
    }
}
