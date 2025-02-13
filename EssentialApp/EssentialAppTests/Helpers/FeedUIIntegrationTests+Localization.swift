//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 04.12.24.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {

    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }

    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }

    var feedTitle: String {
        FeedPresenter.title
    }

    var commentsTitle: String {
        ImageCommentsPresenter.title
    }
}
