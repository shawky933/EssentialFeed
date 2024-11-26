//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 13.11.24.
//

import Foundation

final class FeedCachePolicy {
    private init () {}

    private static let calendar = Calendar(identifier: .gregorian)

    private static var maxCacheAgeInDays: Int {
        7
    }

    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
