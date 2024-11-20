//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 11.11.24.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
