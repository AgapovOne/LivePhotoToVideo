//
//  PhotoViewModel.swift
//  LivePhotoToVideo
//
//  Created by Aleksey Agapov on 07/09/2017.
//  Copyright © 2017 agapovco. All rights reserved.
//

import UIKit

class PhotoViewModel {
    let thumbnail: UIImage
    let name: String

    init(photo: Photo) {
        self.thumbnail = photo.fullResolutionImage
        self.name = photo.name
    }
}
