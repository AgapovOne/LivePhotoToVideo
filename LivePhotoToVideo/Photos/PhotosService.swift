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
        return options
    }()

    func fetchPhotos() -> Observable<[PHAsset]> {
        return Observable.create { event in
            let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: self.options)

            event.on(.next([]))

            return Disposables.create()
        }
    }
}
