//
//  UIColor+Extensions.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

// MARK: - UIColor Utils

extension UIColor {

    static func blend(first color1: UIColor, second color2: UIColor, percent: CGFloat) -> UIColor {
        let first  = color1.toRGBA()
        let second = color2.toRGBA()

        let r = first.r * (1.0 - percent) + second.r * percent
        let g = first.g * (1.0 - percent) + second.g * percent
        let b = first.b * (1.0 - percent) + second.b * percent
        let a = first.a * (1.0 - percent) + second.a * percent

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue  = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init?(cgColor color: CGColor?) {
        guard let color = color else {
            return nil
        }
        self.init(cgColor: color)
    }

    func toRGBA() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }

    var inverted: UIColor {
        if self == .white {
            return .black
        }
        if self == .black {
            return .white
        }
        let rgba = toRGBA()
        return UIColor(red: 1.0 - rgba.r, green: 1.0 - rgba.g, blue: 1.0 - rgba.b, alpha: rgba.a)
    }

    var isDark: Bool {
        return !isLight
    }

    var isLight: Bool {
        let rgba = toRGBA()
        let brightness = (rgba.r * 299 + rgba.g * 587 + rgba.b * 114) / 1000;
        return brightness > 0.5
    }
}
