//
//  PhotosViewController.swift
//  LivePhotoToVideo
//
//  Created by Aleksey Agapov on 06/09/2017.
//  Copyright © 2017 agapovco. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa
import RxDataSources
import Photos

class PhotosViewController: UIViewController {

    let disposeBag = DisposeBag()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let side = self.view.frame.width / 2
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumLineSpacing = 16
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return c
    }()

    private var viewModel: PhotosViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PhotosViewModel()

        view.addSubview(collectionView)

        constrain(collectionView) { c in
            c.edges == c.superview!.edges
        }

        setupBindings()

        fetchPhotos()
    }

    private func setupBindings() {
//        viewModel.photos


    }

    private var photos = PHFetchResult<PHAsset>()

    private lazy var options: PHFetchOptions = {
        let options = PHFetchOptions()

        let sortDesciptor = NSSortDescriptor(key: "creationDate", ascending:false)
        let predicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)

        options.sortDescriptors = [sortDesciptor]
        options.predicate = predicate

        return options
    }()

    func fetchPhotos() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let assets = PHAsset.fetchAssets(with: self.options)

            DispatchQueue.main.async {
                photos = assets
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }

}
