//
//  PhotosViewModel.swift
//  LivePhotoToVideo
//
//  Created by Aleksey Agapov on 06/09/2017.
//  Copyright © 2017 agapovco. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhotosViewModel {
    private var service: PhotosService

    init(service: PhotosService = PhotosService()) {
        self.service = service

        setupBindings()
    }

    // MARK: - Input

    // MARK: - Output
    var photos: Observable<[Photo]> = Variable<[Photo]>([])

    private func setupBindings() {

    }
}
