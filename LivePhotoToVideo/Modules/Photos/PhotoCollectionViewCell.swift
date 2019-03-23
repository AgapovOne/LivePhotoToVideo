//
//  PhotoCollectionViewCell.swift
//  UI
//
//  Created by Alex Agapov on 23/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit
import Reusable
import Cartography

class PhotoCollectionViewCell: UICollectionViewCell, Reusable {

    private let imageView = UIImageView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(imageView)

        constrain(imageView) { i in
            i.edges == i.superview!.edges
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

}
