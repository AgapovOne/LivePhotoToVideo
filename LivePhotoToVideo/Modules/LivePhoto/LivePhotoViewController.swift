//
//  LivePhotoViewController.swift
//  UI
//
//  Created by Alex Agapov on 23/03/2019.
//  Copyright © 2019 agapovco. All rights reserved.
//

import UIKit
import Cartography
import Photos
import PhotosUI
import MobileCoreServices

public final class LivePhotoViewController: UIViewController {

    private lazy var photoLiveView = PHLivePhotoView()
    private lazy var statusImageView = UIImageView(image: PHLivePhotoView.livePhotoBadgeImage(options: .liveOff)) //.overContent))
    private lazy var captionLabel = UILabel.UI.headline(text: "Choose a Photo.\nUse as a video or a GIF.")
    private lazy var bottomButton = UIButton.UI.big(title: "Choose a Photo", color: .charcoal)

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(captionLabel)
        view.addSubview(bottomButton)
        view.addSubview(photoLiveView)

        view.addSubview(statusImageView)

        constrain(captionLabel, photoLiveView, statusImageView, bottomButton) { c, p, i, b in
            [c,p,b].forEach {
                $0.leading == $0.superview!.leading + 16
                $0.trailing == $0.superview!.trailing - 16
            }

            c.top == c.superview!.top + 64
            p.top == c.bottom + 16
            p.bottom == b.top - 16
            b.bottom == b.superview!.bottom - 16

            i.top == p.top + 8
            i.leading == p.leading + 8
        }

        photoLiveView.backgroundColor = .red


        bottomButton.addTarget(self, action: #selector(tapChooseAPhoto), for: .touchUpInside)
    }

    @objc private func tapChooseAPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension LivePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("CANCEL")
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let livePhoto = info[.livePhoto] as? PHLivePhoto {
            photoLiveView.livePhoto = livePhoto
            statusImageView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        } else {
            if #available(iOS 11.0, *) {
                guard
                    let asset = info[.phAsset] as? PHAsset
                    else {
                        self.photoLiveView.livePhoto = nil
                        self.statusImageView.image = nil
                        return
                }

                switch asset.mediaSubtypes {
                case .photoLive:
                    let size = CGSize(width: photoLiveView.frame.size.width * UIScreen.main.scale,
                                      height: photoLiveView.frame.size.height * UIScreen.main.scale)
                    PHImageManager.default().requestLivePhoto(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { (livePhoto, dict) in
                        self.photoLiveView.livePhoto = livePhoto
                        self.statusImageView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
                    }
                default:
                    self.photoLiveView.livePhoto = nil
                    self.statusImageView.image = nil
                }
            } else {
                self.photoLiveView.livePhoto = nil
                self.statusImageView.image = nil
            }
        }
    }
}
