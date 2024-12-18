//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialApp
//
//  Created by Shawky Elhanak on 18.12.24.
//

import XCTest

extension XCTestCase {
	func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
		addTeardownBlock { [weak instance] in
			XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
		}
	}
}
