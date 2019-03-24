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
import RxSwift
import RxCocoa

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
    private lazy var choosePhotoButton: UIButton = {
        let button = UIButton.UI.big(title: "Choose a Photo", color: .charcoal)
        button.addTarget(self, action: #selector(tapChooseAPhoto), for: .touchUpInside)
        return button
    }()
    private lazy var convertToGifButton: UIButton = {
        let button = UIButton.UI.big(title: "Choose a Photo", color: .charcoal)
        button.addTarget(self, action: #selector(tapChooseAPhoto), for: .touchUpInside)
        return button
    }()

    private var assetSize: CGSize {
        return CGSize(width: photoLiveView.frame.size.width * UIScreen.main.scale,
                      height: photoLiveView.frame.size.height * UIScreen.main.scale)
    }

    private let disposeBag = DisposeBag()
    private let phAssetRelay = BehaviorRelay<PHAsset?>(value: nil)

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(captionLabel)
        view.addSubview(choosePhotoButton)
        view.addSubview(convertToGifButton)
        view.addSubview(photoLiveView)

        view.addSubview(statusImageView)
        view.addSubview(emptyView)

        constrain(captionLabel, photoLiveView, statusImageView, emptyView, choosePhotoButton) { caption, photo, status, empty, chooseButton in
            [caption, photo, chooseButton].forEach {
                $0.leading == $0.superview!.leading + 16
                $0.trailing == $0.superview!.trailing - 16
            }

            caption.top == caption.superview!.top + 64
            photo.top == caption.bottom + 16
            photo.bottom == chooseButton.top - 16
            chooseButton.bottom == chooseButton.superview!.bottom - 16

            status.top == photo.top + 8
            status.leading == photo.leading + 8

            empty.center == photo.center
        }

        photoLiveView.backgroundColor = UIColor.black.withAlphaComponent(0.1)

        setupBindings()
    }

    private func setupBindings() {
        phAssetRelay
            .subscribe(onNext: { [weak self] asset in
                guard let self = self else { return }
                guard let asset = asset else {
                    self.setLivePhoto(nil)
                    return
                }

                switch asset.mediaSubtypes {
                case .photoLive:
                    PHImageManager.default().requestLivePhoto(for: asset,
                                                              targetSize: self.assetSize,
                                                              contentMode: .aspectFit,
                                                              options: nil) { [weak self] (livePhoto, _) in
                                                                self?.setLivePhoto(livePhoto)
                    }
                default:
                    self.setLivePhoto(nil)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setLivePhoto(_ photo: PHLivePhoto?) {
        photoLiveView.livePhoto = photo
        statusImageView.image = photo == nil ? nil : PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        setEmptyView(isHidden: photo != nil)
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
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if #available(iOS 11.0, *) {
            guard
                let asset = info[.phAsset] as? PHAsset
                else {
                    phAssetRelay.accept(nil)
                    return
            }

            phAssetRelay.accept(asset)
        } else {
            phAssetRelay.accept(nil)
        }
    }
}
