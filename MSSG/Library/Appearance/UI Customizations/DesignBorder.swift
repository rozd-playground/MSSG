//
//  BorderSupport.swift
//  RYAHApp
//
//  Created by Max Rozdobudko on 10/7/19.
//  Copyright © 2019 RYAH MEDTECH INC. All rights reserved.
//

import UIKit

// MARK: - Border Support

extension CACornerMask {

    var corners: UIRectCorner {
        var result: UIRectCorner = []
        if self.contains(.layerMinXMinYCorner) {
            result.insert(.topLeft)
        }
        if self.contains(.layerMaxXMinYCorner) {
            result.insert(.topRight)
        }
        if self.contains(.layerMinXMaxYCorner) {
            result.insert(.bottomLeft)
        }
        if self.contains(.layerMaxXMaxYCorner) {
            result.insert(.bottomRight)
        }
        return result
    }

}

// MARK: Borderable

protocol Borderable: class {
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
}

// MARK: - DesignView Implementation

@IBDesignable
extension DesignView: Borderable {

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var maskedCorners: CACornerMask {
        get { return layer.maskedCorners }
        set { layer.maskedCorners = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor) }
        set { layer.borderColor = newValue?.cgColor }
    }

}


// MARK: - DesignButton Implementation

@IBDesignable
extension DesignButton: Borderable {

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var maskedCorners: CACornerMask {
        get { return layer.maskedCorners }
        set { layer.maskedCorners = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor) }
        set { layer.borderColor = newValue?.cgColor }
    }

}

// MARK: - UITableViewCell Implementation

@IBDesignable
extension UITableViewCell: Borderable {

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var maskedCorners: CACornerMask {
        get { return layer.maskedCorners }
        set { layer.maskedCorners = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor) }
        set { layer.borderColor = newValue?.cgColor }
    }

}
