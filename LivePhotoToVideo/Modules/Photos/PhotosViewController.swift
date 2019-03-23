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

public protocol PhotosViewModel {}

public final class PhotosViewController: UIViewController {

    let disposeBag = DisposeBag()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let side = self.view.frame.width / 2 - 8
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumLineSpacing = 16
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(cellType: PhotoCollectionViewCell.self)
        return c
    }()

    private var viewModel: PhotosViewModel!

    public init(viewModel: PhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

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
        DispatchQueue.global(qos: .default).async {
            let assets = PHAsset.fetchAssets(with: self.options)

            DispatchQueue.main.async {
                self.photos = assets
                self.collectionView.reloadData()
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        return cell
    }

}
