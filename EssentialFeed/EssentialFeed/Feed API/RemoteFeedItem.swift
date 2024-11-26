//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 11.11.24.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
