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

    // MARK: - Input
    let reload: AnyObserver<Void>

    // MARK: - Output
    let photos: Observable<[PhotoViewModel]>

    init(service: PhotosService = PhotosService()) {
        self.service = service


        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()

        self.photos = Observable.just([])
    }

}
