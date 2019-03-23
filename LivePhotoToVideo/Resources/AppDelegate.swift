//
//  AppDelegate.swift
//  LivePhotoToVideo
//
//  Created by Aleksey Agapov on 06/09/2017.
//  Copyright © 2017 agapovco. All rights reserved.
//

import UIKit
import UI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        let viewController = PermissionsViewController()
        let viewController = PhotosViewController(viewModel: PhotosViewModelImpl())

        window = UIWindow()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
