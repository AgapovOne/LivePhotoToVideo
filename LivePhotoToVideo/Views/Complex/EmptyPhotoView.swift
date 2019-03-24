//
//  EmptyPhotoView.swift
//  UI
//
//  Created by Alex Agapov on 24/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit
import Cartography

class EmptyPhotoView: UIView {
    private lazy var ovalView: UIView = {
        let ovalView = OvalView()
        ovalView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        constrain(ovalView) { o in
            o.width == 28
            o.height == 10
        }
        return ovalView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.text = "🌄"
        return label
    }()

    private lazy var emptyView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center

        stackView.addArrangedSubview(emptyLabel)
        stackView.addArrangedSubview(ovalView)

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(emptyView)

        constrain(emptyView) { view in
            view.edges == view.superview!.edges
        }
    }

    private func startAnimation() {
        stopAnimation()

        let translationAnimation = CABasicAnimation(keyPath: "transform")
        translationAnimation.fromValue = CATransform3DIdentity
        translationAnimation.toValue = CATransform3DMakeTranslation(0, 10, 0)
        translationAnimation.duration = 2
        translationAnimation.autoreverses = true
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        translationAnimation.repeatCount = .greatestFiniteMagnitude

        emptyLabel.layer.add(translationAnimation, forKey: "jumpy_label")

        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = CATransform3DIdentity
        scaleAnimation.toValue = CATransform3DMakeScale(1.25, 1.25, 1)
        scaleAnimation.duration = 2
        scaleAnimation.autoreverses = true
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude

        ovalView.layer.add(scaleAnimation, forKey: "scale")
    }

    private func stopAnimation() {
        emptyLabel.layer.removeAllAnimations()
        ovalView.layer.removeAllAnimations()
    }

    func setHidden(isHidden: Bool) {
        self.isHidden = isHidden
        if isHidden {
            stopAnimation()
        } else {
            startAnimation()
        }
    }
}
