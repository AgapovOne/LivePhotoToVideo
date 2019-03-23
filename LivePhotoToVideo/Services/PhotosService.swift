//
//  PhotosService.swift
//  LivePhotoToVideo
//
//  Created by Aleksey Agapov on 06/09/2017.
//  Copyright © 2017 agapovco. All rights reserved.
//

import Foundation
import Photos
import RxSwift

class PhotosService {
    private lazy var options: PHFetchOptions = {
        let options = PHFetchOptions()

        let sortDesciptor = NSSortDescriptor(key: "creationDate", ascending:false)
        let predicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)

        options.sortDescriptors = [sortDesciptor]
        options.predicate = predicate

        return options
    }()

    func fetchPhotos() -> Observable<[PHAsset]> {
        return Observable.create { event in

            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
//                self.livePhotoAssets = PHAsset.fetchAssets(with: options)
                let assets = PHAsset.fetchAssets(with: self.options)


                DispatchQueue.main.async {
//                    event.on(.next(assets))
                    event.on(.next([]))
                }
            }


            return Disposables.create()
        }
    }
}
