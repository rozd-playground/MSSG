//
//  ShadowSupport.swift
//  RYAHApp
//
//  Created by Max Rozdobudko on 10/7/19.
//  Copyright © 2019 RYAH MEDTECH INC. All rights reserved.
//

import UIKit

// MARK: - Shadow

struct Shadow {
    let color: UIColor
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
}

extension Shadow {
    static let debug        = Shadow(color: .red, opacity: 1.0, offset: .zero, radius: 20)
}

// MARK: ShadowSides

struct ShadowSides: OptionSet {
    static let left     = ShadowSides(rawValue: 1 << 0)
    static let top      = ShadowSides(rawValue: 1 << 1)
    static let right    = ShadowSides(rawValue: 1 << 2)
    static let bottom   = ShadowSides(rawValue: 1 << 3)

    static let all: ShadowSides = [.left, .top, .right, .bottom]

    let rawValue: Int
}

extension ShadowSides {

    func insets(radius: CGFloat) -> UIEdgeInsets {
        let offset = radius * 2
        return UIEdgeInsets(top: contains(.top) ? offset : 0,
                            left: contains(.left) ? offset : 0,
                            bottom: contains(.bottom) ? offset : 0,
                            right: contains(.right) ? offset : 0)
    }

}

// MARK: - Shadowable

protocol Shadowable: class {
    var shadowColor: UIColor? { get set }
    var shadowOpacity: Float { get set }
    var shadowOffset: CGSize { get set }
    var shadowRadius: CGFloat { get set }
    var shadowSides: ShadowSides? { get set }
}

// MARK: Apply Shadow Extension

extension Shadowable {

    func drop(shadow: Shadow, on sides: ShadowSides) {
        shadowColor    = shadow.color
        shadowOpacity  = shadow.opacity
        shadowOffset   = shadow.offset
        shadowRadius   = shadow.radius
        shadowSides     = sides
    }

    func drop(shadow: Shadow?) {
        guard let shadow = shadow else {
            clearShadow()
            return
        }
        self.drop(shadow: shadow, on: .all)
    }

    func clearShadow() {
        shadowColor = nil
        shadowOpacity = .zero
        shadowOffset = .zero
        shadowRadius = .zero
        shadowSides = nil
    }

    func retrieveShadow() -> Shadow? {
        guard let shadowColor = self.shadowColor else {
            return nil
        }
        return Shadow(color: shadowColor, opacity: shadowOpacity, offset: shadowOffset, radius: shadowRadius)
    }

}

// MARK: Shadowable Default Implementation

fileprivate struct AssociatedKeys {
    static var shadowSides = "Shadowable.shadowSides"
}

extension Shadowable where Self: UIView {

    var shadowColor: UIColor? {
        get { return UIColor(cgColor: layer.shadowColor) }
        set { layer.shadowColor = newValue?.cgColor }
    }

    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    var shadowSides: ShadowSides? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.shadowSides) as? ShadowSides
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shadowSides, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsDisplay()
        }
    }

    func updateShadowSides(bounds rect: CGRect) {
        guard let shadowSides = shadowSides else {
            layer.mask = nil
            return
        }

        guard shadowSides != .all else {
            layer.mask = nil
            return
        }

        let insets = shadowSides.insets(radius: shadowRadius)

        let maskLayer = layer.mask ?? createLayerMask()
        layer.mask = maskLayer
        maskLayer.frame = CGRect(x: rect.origin.x - insets.left,
                                 y: rect.origin.y - insets.top,
                                 width: rect.size.width + insets.right + insets.left,
                                 height: rect.size.height + insets.top + insets.bottom)
    }

    func updateLayerPath(bounds rect: CGRect) {
        guard let layer = layer as? CAShapeLayer else {
            return
        }

        let radii = CGSize(width: layer.cornerRadius, height: layer.cornerRadius)
        layer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: layer.maskedCorners.corners, cornerRadii: radii).cgPath
        layer.fillColor = backgroundColor?.cgColor // TODO: see this
    }

    fileprivate func createLayerMask() -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor(hex: 0xFF0000).cgColor
        return layer
    }
}

// MARK: - UITableViewCell Implementation

extension UITableViewCell: Shadowable {

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        updateLayerPath(bounds: bounds)
        updateShadowSides(bounds: bounds)
    }

}

// MARK: - DesignButton Implementation

@IBDesignable
extension DesignButton: Shadowable {

    @IBInspectable var shadowColor: UIColor? {
        get { return UIColor(cgColor: layer.shadowColor) }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    // MARK: Lifecycle

    override func layoutSubviews() {
        updateLayerPath(bounds: bounds)
        updateShadowSides(bounds: bounds)
        super.layoutSubviews()
    }

}

// MARK: - DesignView Implementation

@IBDesignable
extension DesignView: Shadowable {

    @IBInspectable var shadowColor: UIColor? {
        get { return UIColor(cgColor: layer.shadowColor) }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    // MARK: Lifecycle

    override func layoutSubviews() {
        updateLayerPath(bounds: bounds)
        updateShadowSides(bounds: bounds)
        super.layoutSubviews()
    }

}

// MARK: - UINavugationBar Implementation

extension UINavigationBar: Shadowable {

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        updateLayerPath(bounds: bounds)
        updateShadowSides(bounds: bounds)
    }

}
