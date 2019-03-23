//: [Previous](@previous)

import UIKit
import PlaygroundSupport

import UI

class fvm: PhotosViewModel {}

//let controller = PermissionsViewController()
let controller = PhotosViewController(viewModel: fvm())

//let addTraits = UITraitCollection(preferredContentSizeCategory: .extraLarge)
//let addTraits = UITraitCollection(preferredContentSizeCategory: .extraSmall)
let addTraits = UITraitCollection()

let (parent, _) = playgroundControllers(device: .phone4_7inch, orientation: .portrait, child: controller, additionalTraits: addTraits)

PlaygroundPage.current.liveView = parent
//PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
