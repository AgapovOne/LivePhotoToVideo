//
//  PermissionsViewController.swift
//  LivePhotoToVideo
//
//  Created by Alex Agapov on 23/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit
import Cartography

public final class PermissionsViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var headlineLabel: UILabel = {
        let label = UILabel.UI.headline
        label.text = "Allow Photos Access"
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel.UI.body
        label.text = "Photos access is unknown"
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton.UI.big(title: "Allow Photos", color: .brown)
        button.addTarget(self, action: #selector(tapAllowPhotos), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(headlineLabel)
        view.addSubview(button)
        view.addSubview(statusLabel)

        constrain(button, headlineLabel, statusLabel) { b, h, s in
            [b, h, s].forEach {
                $0.leading == $0.superview!.leading + 16
                $0.trailing == $0.superview!.trailing - 16
            }

            h.top == h.superview!.top + 40
            b.top == h.bottom + 16
            s.top == b.bottom + 24
            s.bottom <= s.superview!.bottom + 40
        }
    }

    // MARK: - Actions
    @objc private func tapAllowPhotos() {
        statusLabel.text = statusLabel.text == "x" ? "TAP HAPPENED" : "x"
    }
}
