//
//  UIImage+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Shawky Elhanak on 30.11.24.
//

import UIKit

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1

        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}
