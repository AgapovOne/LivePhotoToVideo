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
    private var fileURLS = [URL]()

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
        if let asset = phAssetRelay.value {
            /*
//            print(asset)
//
//            PHImageManager.default().requestLivePhoto(for: asset, targetSize: self.assetSize, contentMode: .aspectFit, options: nil) { [weak self] (livePhoto, dict) in
//
//                print(livePhoto, dict)
//
//                guard let livePhoto = livePhoto else { return }
//                let resources = PHAssetResource.assetResources(for: livePhoto)
//                print(resources)
//
//                let videoAsset = resources.first { $0.type == .video }
//
//                print(videoAsset)
//
//            }
//            let imageOptions = PHImageRequestOptions()
//            PHImageManager.default().requestImageData(for: asset, options: imageOptions) { (data, somestring, orientation, dict) in
//                print(data, somestring, orientation, dict)
//            }*/

//            let resources = PHAssetResource.assetResources(for: asset)
//            print(resources)
//
//            guard let videoAsset = resources.first(where: { $0.type == .pairedVideo }) else { return }
//
//            print(videoAsset.assetLocalIdentifier)
//
//            let options = PHFetchOptions()
//            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [videoAsset.assetLocalIdentifier], options: nil)
//
//            print(fetchResult)
//
//            guard let foundVideoAsset = fetchResult.firstObject else { return }
//
//            print(foundVideoAsset.duration)
//            PHImageManager.default().requestPlayerItem(forVideo: foundVideoAsset, options: PHVideoRequestOptions()) { (playerItem, dict) in
//                print(playerItem, dict)
//            }
//            PHImageManager.default().requestAVAsset(forVideo: foundVideoAsset, options: PHVideoRequestOptions()) { (asset, audioMix, dict) in
//                print(asset, audioMix, dict)
//            }

//            NSTemporaryDirectory()

            guard let fileURL = fileURLS.last else { return }
            let activity = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            present(activity, animated: true, completion: nil)

        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]
            picker.delegate = self
            picker.allowsEditing = false;
            present(picker, animated: true, completion: nil)
        }
    }
}

extension LivePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let livePhoto = info[.livePhoto] as? PHLivePhoto {
            print(livePhoto)
            saveFile(for: livePhoto)
        }

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

    func saveFile(for livePhoto: PHLivePhoto) {
        guard let directory = generateFolderForLivePhotoResources() else { return }
        let assetResources = PHAssetResource.assetResources(for: livePhoto)

        for resource in assetResources {
            var buffer: Data?
            PHAssetResourceManager.default().requestData(for: resource, options: nil, dataReceivedHandler: { (data) in
                buffer = data
            }) { (error) in
                guard error == nil else {
                    print("Could not request data for resource: \(resource), error: \(error)")
                    return
                }
//                let ext = UTTypeCopyPreferredTagWithClass(resource.uniformTypeIdentifier as CFString, kUTTagClassFilenameExtension)?
//                    .takeRetainedValue()

                let identifier = resource.uniformTypeIdentifier

                let fileURL = directory
                    .appendingPathComponent(UUID().uuidString)
//                    .appendingPathExtension(identifier)
//                    .appendingPathComponent(resource.originalFilename)
                .appendingPathExtension(URL(string: resource.originalFilename)?.pathExtension ?? "file")
//                    .appendingPathExtension(ext)


                guard let buffer = buffer else {
                    print("Could not find data for ph asset resource \(resource)")
                    return
                }
                do {
                    try buffer.write(to: fileURL)
                    print("Saved to file path \(fileURL)")
                    self.fileURLS.append(fileURL)
                } catch {
                    print("Could not save resource \(resource) to file path \(fileURL)")
                }


                //                    let maybeExt = UTTypeCopyPreferredTagWithClass(
                //                        resource.uniformTypeIdentifier,
                //                        kUTTagClassFilenameExtension
                //                        )?.takeRetainedValue()
                //
                //                    guard let ext = maybeExt else {
                //                        return
                //                    }
                //
                //                    var fileUrl = inDirectory.URLByAppendingPathComponent(NSUUID().UUIDString)
                //                    fileUrl = fileUrl.URLByAppendingPathExtension(ext as String)
                //
                //                    if(!buffer.writeToURL(fileUrl, atomically: true)) {
                //                        print("Could not save resource \(resource) to filepath \(fileUrl)")
                //                    }
            }
        }
    }

    func generateFolderForLivePhotoResources() -> URL? {
        let photoDirectory = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(UUID().uuidString)

        let fileManager = FileManager()
        do {
            try fileManager.createDirectory(at: photoDirectory, withIntermediateDirectories: true, attributes: nil)

            return photoDirectory
        } catch {
            return nil
        }
    }
}
