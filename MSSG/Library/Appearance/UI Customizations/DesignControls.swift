//
//  DesignControls.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

// MARK: - DesignView

@IBDesignable
class DesignView: UIView {

    // MARK: Shape Layer

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }

    override var backgroundColor: UIColor? {
        didSet {
            updateLayerPath(bounds: bounds)
        }
    }

}

// MARK: - DesignButton

@IBDesignable
class DesignButton: UIButton {

    // MARK: Shape Layer

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }

}
