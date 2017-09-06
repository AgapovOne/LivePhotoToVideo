//
//  Photo.swift
//  LivePhotoToVideo
//
//  Created by Aleksey Agapov on 06/09/2017.
//  Copyright © 2017 agapovco. All rights reserved.
//

import Foundation
import Photos

struct Photo {
    var phAsset: PHAsset
    var fullResolutionImage: UIImage
    var name: String

    init(_ asset: PHAsset) {
        self.phAsset = asset
        self.fullResolutionImage = asset.
    }
}
