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

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let side = self.view.frame.width / 3
        layout.itemSize = CGSize(width: side, height: side)
//        layout.minimumLineSpacing = 16
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(cellType: PhotoCollectionViewCell.self)
        c.backgroundColor = .white
        c.delegate = self
        c.dataSource = self
        return c
    }()
    private let refreshControl = UIRefreshControl()

    private var viewModel: PhotosViewModel!

    public convenience init(viewModel: PhotosViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)

        constrain(collectionView) { c in
            c.edges == c.superview!.edges
        }

        setupBindings()

        PHPhotoLibrary.shared().register(self)
        fetchPhotos()
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    private func setupBindings() {
//        viewModel.photos
    }

    private var fetchResult = PHFetchResult<PHAsset>()

    private lazy var options: PHFetchOptions = {
        let options = PHFetchOptions()
//        options.fetchLimit = 10

        let sortDesciptor = NSSortDescriptor(key: "creationDate", ascending:false)
        let predicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
//
        options.sortDescriptors = [sortDesciptor]
        options.predicate = predicate

        return options
    }()

    func fetchPhotos() {
        DispatchQueue.global(qos: .default).async {
            let assets = PHAsset.fetchAssets(with: self.options)

            DispatchQueue.main.async {
                self.fetchResult = assets
                self.collectionView.reloadData()
                print(assets.count)
            }
        }
    }

    @objc private func reload() {
        refreshControl.endRefreshing()
        fetchPhotos()
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let asset = fetchResult.object(at: indexPath.row)
        cell.identifier = asset.localIdentifier
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width), contentMode: .aspectFit, options: nil) { (image, dict) in
            if cell.identifier == asset.localIdentifier {
                cell.image = image
            }
        }
        return cell
    }

}

extension PhotosViewController: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {

        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }

        // Change notifications may originate from a background queue.
        // As such, re-dispatch execution to the main queue before acting
        // on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            // If we have incremental changes, animate them in the collection view.
            if changes.hasIncrementalChanges {
                // Handle removals, insertions, and moves in a batch update.
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
                // We are reloading items after the batch update since `PHFetchResultChangeDetails.changedIndexes` refers to
                // items in the *after* state and not the *before* state as expected by `performBatchUpdates(_:completion:)`.
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
            } else {
                // Reload the collection view if incremental changes are not available.
                collectionView.reloadData()
            }
//            resetCachedAssets()
        }
    }


}
