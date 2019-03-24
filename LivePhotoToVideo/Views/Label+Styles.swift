//
//  Label+Styles.swift
//  LivePhotoToVideo
//
//  Created by Alex Agapov on 23/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit

extension UILabel {
    enum UI {
        static var headline: UILabel {
            let label = UILabel()
            let font = UIFont.systemFont(ofSize: 30, weight: .heavy)

            if #available(iOS 11.0, *) {
                label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
            } else {
                label.font = font
            }
            label.textColor = .darkCharcoal
            label.numberOfLines = 0
            return label
        }

        static func headline(text: String) -> UILabel {
            let label = headline
            label.text = text
            return label
        }

        static var body: UILabel {
            let label = UILabel()
            let font = UIFont.systemFont(ofSize: 20, weight: .semibold)

            if #available(iOS 11.0, *) {
                label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
            } else {
                label.font = font
            }
            label.textColor = .darkCharcoal
            label.numberOfLines = 0
            return label
        }
    }
}
