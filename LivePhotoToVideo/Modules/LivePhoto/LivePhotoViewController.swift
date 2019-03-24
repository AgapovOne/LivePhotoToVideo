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

    private lazy var photoLiveView: PHLivePhotoView = {
        let view = PHLivePhotoView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var statusImageView = UIImageView()
    private lazy var emptyView = EmptyPhotoView()
    private lazy var captionLabel = UILabel.UI.headline(text: "Choose a Photo.\nUse it as a video or a GIF.")
    private lazy var bottomButton = UIButton.UI.big(title: "Choose a Photo", color: .charcoal)

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(captionLabel)
        view.addSubview(bottomButton)
        view.addSubview(photoLiveView)

        view.addSubview(statusImageView)
        view.addSubview(emptyView)

        constrain(captionLabel, photoLiveView, statusImageView, emptyView, bottomButton) { caption, photo, statusImage, emptyView, bottomButton in
            [caption, photo, bottomButton].forEach {
                $0.leading == $0.superview!.leading + 16
                $0.trailing == $0.superview!.trailing - 16
            }

            caption.top == caption.superview!.top + 64
            photo.top == caption.bottom + 16
            photo.bottom == bottomButton.top - 16
            bottomButton.bottom == bottomButton.superview!.bottom - 16

            statusImage.top == photo.top + 8
            statusImage.leading == photo.leading + 8

            emptyView.center == photo.center
        }

        photoLiveView.backgroundColor = UIColor.black.withAlphaComponent(0.1)

        bottomButton.addTarget(self, action: #selector(tapChooseAPhoto), for: .touchUpInside)

        setEmptyView(isHidden: false)
    }

    private func setEmptyView(isHidden: Bool) {
        emptyView.setHidden(isHidden: isHidden)
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
            setEmptyView(isHidden: true)
        } else {
            if #available(iOS 11.0, *) {
                guard
                    let asset = info[.phAsset] as? PHAsset
                    else {
                        photoLiveView.livePhoto = nil
                        statusImageView.image = nil
                        setEmptyView(isHidden: false)
                        return
                }
                switch asset.mediaSubtypes {
                case .photoLive:
                    let size = CGSize(width: photoLiveView.frame.size.width * UIScreen.main.scale,
                                      height: photoLiveView.frame.size.height * UIScreen.main.scale)
                    PHImageManager.default().requestLivePhoto(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { (livePhoto, dict) in
                        self.photoLiveView.livePhoto = livePhoto
                        self.statusImageView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
                        self.setEmptyView(isHidden: true)
                    }
                default:
                    photoLiveView.livePhoto = nil
                    statusImageView.image = nil
                    setEmptyView(isHidden: false)
                }
            } else {
                photoLiveView.livePhoto = nil
                statusImageView.image = nil
                setEmptyView(isHidden: false)
            }
        }
    }
}
