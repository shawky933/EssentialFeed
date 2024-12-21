//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Shawky Elhanak on 21.12.24.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
