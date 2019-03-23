//
//  Button+Styles.swift
//  UI
//
//  Created by Alex Agapov on 23/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit

extension UIButton {
    enum UI {
        static func big(title: String, color: UIColor) -> UIButton {
            let button = UIButton(type: .custom)

            button.backgroundColor = color
            button.layer.cornerRadius = 12

            let font = UIFont.systemFont(ofSize: 20, weight: .light)

            let normalTitle = NSAttributedString(string: title,
                                                 attributes: [.font: font,
                                                              .foregroundColor: UIColor.white])
            button.setAttributedTitle(normalTitle, for: .normal)

            let highlightedTitle = NSAttributedString(string: title,
                                                      attributes: [.font: font,
                                                                   .foregroundColor: UIColor.white.withAlphaComponent(0.75)])
            button.setAttributedTitle(highlightedTitle, for: .highlighted)
            return button
        }
    }
}
