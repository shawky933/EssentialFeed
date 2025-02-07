//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Shawky Elhanak on 09.12.24.
//

public struct ResourceErrorViewModel {
    public let message: String?

    static var noError: ResourceErrorViewModel {
        ResourceErrorViewModel(message: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        ResourceErrorViewModel(message: message)
    }
}
