source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

abstract_target 'Workspace' do

  # Main
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'

  target 'UI' do
    pod 'Cartography'
    pod 'Reusable'
  end

  target 'LivePhotoToVideo' do
    pod 'Reveal-SDK', :configurations => ['Debug']
  end

  target 'LivePhotoToVideoTests' do
    inherit! :search_paths


  end

end
