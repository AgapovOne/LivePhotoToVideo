//
//  PhotosService.swift
//  LivePhotoToVideo
//
//  Created by Aleksey Agapov on 06/09/2017.
//  Copyright © 2017 agapovco. All rights reserved.
//

import Foundation
import Photos

class PhotosService {
    private lazy var options = {
        let options = PHFetchOptions()
        return options
    }()

    func fetchPhotos() -> PHAsset {
        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
    }
}
