//
//  LivePhotoViewController.swift
//  UI
//
//  Created by Alex Agapov on 23/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit
import Cartography
import PhotosUI

public final class LivePhotoViewController: UIViewController {

    private lazy var photoLiveView: PHLivePhotoView = PHLivePhotoView()
    private lazy var bottomButton: UIButton = {
        let button = UIButton.UI.big(title: "Pick Photo", color: .brown)
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(photoLiveView)
        constrain(photoLiveView) { p in
            p.edges == p.superview?.edges.inseted(horizontally: 48, vertically: 16)
        }
    }
}
