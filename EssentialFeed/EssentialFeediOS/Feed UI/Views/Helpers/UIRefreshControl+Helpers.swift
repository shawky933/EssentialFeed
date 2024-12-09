//
//  UIRefreshControl+Helpers.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 09.12.24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
