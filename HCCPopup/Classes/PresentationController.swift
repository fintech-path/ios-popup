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

class PresentationController: UIPresentationController {
    /// Whether the presented will be dismissed when user taps on the scrim.
    var isDismissible = false
    var alignment: Popup.Alignment = .bottomLeft
    /// Will apply to containerView.size
    var scaleX: CGFloat = 1
    /// Will apply to containerView.size
    var scaleY: CGFloat = 1

    private(set) lazy var dimmingView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(white: 0, alpha: 0.5)
        $0.alpha = 0
        return $0
    }(UIView())

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapGesture(recognizer _: UITapGestureRecognizer) {
        guard isDismissible else { return }
        presentingViewController.dismiss(animated: true)
    }

    override func presentationTransitionWillBegin() {
        if let containerView = containerView, !dimmingView.isDescendant(of: containerView) {
            containerView.insertSubview(dimmingView, at: 0)
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", metrics: nil, views: ["dimmingView": dimmingView]))
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else { return dimmingView.alpha = 1 }
        transitionCoordinator.animate { _ in self.dimmingView.alpha = 1 }
    }

    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else { return dimmingView.alpha = 0 }
        transitionCoordinator.animate { _ in self.dimmingView.alpha = 0 }
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer _: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return parentSize.applying(.init(scaleX: scaleX, y: scaleY))
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let parentSize = containerView.bounds.size
        let size = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: parentSize)
        var origin: CGPoint
        switch alignment {
        case .topLeft:
            origin = .zero
        case .topRight:
            origin = .init(x: parentSize.width - size.width, y: 0)
        case .bottomLeft:
            origin = .init(x: 0, y: parentSize.height - size.height)
        case .bottomRight:
            origin = .init(x: parentSize.width - size.width, y: parentSize.height - size.height)
        case .center:
            origin = .init(x: (parentSize.width - size.width) / 2, y: (parentSize.height - size.height) / 2)
        case let .custom(x, y):
            origin = .init(x: (x + 1) * parentSize.width / 2, y: (y + 1) * parentSize.height / 2)
        }
        return .init(origin: origin, size: size)
    }
}

extension Popup.Alignment {
    var x: Double {
        switch self {
        case .topLeft, .bottomLeft:
            return -1
        case .topRight, .bottomRight:
            return 1
        case .center:
            return 0
        case let .custom(x, _):
            return x
        }
    }

    var y: Double {
        switch self {
        case .topLeft, .topRight:
            return -1
        case .bottomLeft, .bottomRight:
            return 1
        case .center:
            return 0
        case let .custom(_, y):
            return y
        }
    }
}
