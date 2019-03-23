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
            let font = UIFont.systemFont(ofSize: 50, weight: .black)

            if #available(iOS 11.0, *) {
                label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
            } else {
                label.font = font
            }
            label.textColor = UIColor(white: 0.1, alpha: 1)
            label.numberOfLines = 0
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
            label.textColor = UIColor(white: 0.25, alpha: 1)
            label.numberOfLines = 0
            return label
        }
    }
}
