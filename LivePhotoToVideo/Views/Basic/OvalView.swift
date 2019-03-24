//
//  OvalView.swift
//  UI
//
//  Created by Alex Agapov on 24/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit

final class OvalView: UIView {

    private func layoutOvalMask() {
        let mask = self.shapeMaskLayer()
        let bounds = self.bounds
        if mask.frame != bounds {
            mask.frame = bounds
            mask.path = CGPath(ellipseIn: bounds, transform: nil)
        }
    }

    private func shapeMaskLayer() -> CAShapeLayer {
        if let layer = self.layer.mask as? CAShapeLayer {
            return layer
        }
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        self.layer.mask = layer
        return layer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutOvalMask()
    }

}
