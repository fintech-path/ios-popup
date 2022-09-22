### [README of Chinese](./README_CN.md)

# HCCPopup

[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_9.0+-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS_9.0+-yellowgreen?style=flat-square)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square)](https://img.shields.io/badge/Version-0.1.0-blue?style=flat-square)
[![CocoaPods Compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat-square)](https://cocoapods.org/)
[![License](https://img.shields.io/badge/License-Apache_2.0-green?style=flat-square)](https://img.shields.io/badge/License-Apache_2.0-green?style=flat-square)


## About
A syntactic sugar library of `UIViewControllerTransitioningDelegate`.

Related documents from Apple: [*Creating Custom Presentations*](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/DefiningCustomPresentations.html)
## Screenshot
![screenshot_0](./Screenshot/screenshot_0.gif)
![screenshot_1](./Screenshot/screenshot_1.gif)
## Example
To run the example project, clone the repo, and run `pod install` from the *Example* directory first.
## Release notes
### 1.0.0
- [x] Predefined alignments: `topLeft`, `topRight`, `bottomLeft`, `bottomRight`, `center`
- [x] Custom alignment: `custom`
- [x] Predefined animations: `horizontal`, `vertical`, `center`, `reversed`
- [ ] Custom animation: support custom `CGAffineTransform`

## Documentation 
### Requirements
iOS 9.0+

swift 5+
### Installation

HCCPopup is a [Private Pod](https://github.com/hccxc/ios-popup.git) for now. To install
it, simply add the following line to your Podfile:

```ruby
pod 'HCCPopup' , :git => 'https://github.com/hccxc/ios-popup.git'
```
### Usage
#### Popup.Alignment
The `.custom(x:y:)` case in a rectangle with height `h` and width `w` describes the `origin` point `(x * w/2 + w/2, y * h/2 + h/2)` in the coordinate system of the rectangle.
#### Popup
```swift
// Hold your `Popup`
let popup = Popup()
popup.configuration = .init(isDismissible: isDismissible, alignment: alignment, scaleX: scaleX, scaleY: scaleY, animation: animation)
// For `presentedViewController`
// Set `Popup` as `transitioningDelegate` of `presentedViewController`
// Set `modalPresentationStyle` to `.custom`
presented.transitioningDelegate = popup
presented.modalPresentationStyle = .custom
someViewController.present(presented, animated: true)
```
### UIViewController extension
```swift
let viewController = UIViewController()
let config = Popup.Configuration(isDismissible: isDismissible, alignment: alignment, scaleX: scaleX, scaleY: scaleY, animation: animation)
// `pup` is a readonly `Popup` instance
viewController.pup(config).present(vcToPresent, animated: true)
```
## License
HCCPopup is available under the Apache 2.0 license. See the LICENSE file for more info.
