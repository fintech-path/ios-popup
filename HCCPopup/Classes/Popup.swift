/*
 * Copyright 2007-2022 Home Credit Xinchi Consulting Co. Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import UIKit

@objc(HCCPopup)
public class Popup: NSObject {
    /// Alignment of the Popup.
    ///
    /// The `.custom(x:y:)` case in a rectangle with height h and width w describes
    /// the `origin` point (x * w/2 + w/2, y * h/2 + h/2) in the coordinate system of the
    /// rectangle.
    ///
    public enum Alignment {
        case topLeft, topRight, bottomLeft, bottomRight, center
        case custom(x: Double, y: Double)
    }

    public indirect enum Animation {
        case horizontal(duration: TimeInterval), vertical(duration: TimeInterval), center(duration: TimeInterval)
        case reversed(Popup.Animation)
        case custom(duration: TimeInterval, transformer: (UIViewControllerContextTransitioning) -> CGAffineTransform)
    }

    public struct Configuration {
        public let isDismissible: Bool
        public let alignment: Popup.Alignment
        public let scaleX: CGFloat
        public let scaleY: CGFloat
        public let animation: Popup.Animation

        public init(isDismissible: Bool = false, alignment: Popup.Alignment = .bottomLeft, scaleX: CGFloat = 1, scaleY: CGFloat = 1, animation: Popup.Animation = .reversed(.vertical(duration: 0.3))) {
            self.isDismissible = isDismissible
            self.alignment = alignment
            self.scaleX = scaleX
            self.scaleY = scaleY
            self.animation = animation
        }
    }

    public weak var presenting: UIViewController?
    public var configuration = Popup.Configuration()

    public var isDismissible: Bool { configuration.isDismissible }
    public var alignment: Popup.Alignment { configuration.alignment }
    public var scaleX: CGFloat { configuration.scaleX }
    public var scaleY: CGFloat { configuration.scaleY }
    public var animation: Popup.Animation { configuration.animation }

    convenience init(presenting: UIViewController) {
        self.init()
        self.presenting = presenting
    }

    public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let presenting = presenting else {
            return
        }
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.transitioningDelegate = self
        presenting.present(viewControllerToPresent, animated: flag) {
            viewControllerToPresent.transitioningDelegate = nil
            completion?()
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension Popup: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        return {
            $0.isDismissible = isDismissible
            $0.alignment = alignment
            $0.scaleX = scaleX
            $0.scaleY = scaleY
            return $0
        }(PresentationController(presentedViewController: presented, presenting: presenting))
    }

    public func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: true, animation: animation)
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: false, animation: animation)
    }
}
