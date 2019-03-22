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
    }

    private func setupBindings() {
//        viewModel.photos
    }
}
