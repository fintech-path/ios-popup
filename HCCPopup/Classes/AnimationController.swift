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

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresentation: Bool
    let animation: Popup.Animation

    init(isPresentation: Bool, animation: Popup.Animation) {
        self.isPresentation = isPresentation
        self.animation = animation
        super.init()
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animation.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let viewController = transitionContext.viewController(forKey: key) else { return }
        if isPresentation {
            transitionContext.containerView.addSubview(viewController.view)
        }
        let transform = animation.transform(using: transitionContext, presentationFrame: transitionContext.finalFrame(for: viewController))
        viewController.view.transform = !isPresentation ? .identity : transform
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                viewController.view.transform = self.isPresentation ? .identity : transform
            },
            completion: {
                if (self.isPresentation && transitionContext.transitionWasCancelled) || (!self.isPresentation && !transitionContext.transitionWasCancelled) {
                    viewController.view.removeFromSuperview()
                }
                transitionContext.completeTransition($0 && !transitionContext.transitionWasCancelled)
            }
        )
    }
}

extension Popup.Animation {
    var duration: TimeInterval {
        switch self {
        case let .center(duration), let .horizontal(duration), let .vertical(duration), let .custom(duration, _):
            return duration
        case let .reversed(animation):
            if case let .reversed(anim) = animation {
                return anim.duration
            } else {
                return animation.duration
            }
        }
    }

    func transform(using transitionContext: UIViewControllerContextTransitioning, presentationFrame: CGRect, reversed: Bool = false) -> CGAffineTransform {
        let transform: CGAffineTransform
        let containerViewWidth = transitionContext.containerView.frame.width
        let containerViewHeight = transitionContext.containerView.frame.height
        switch self {
        case .horizontal:
            transform = .init(translationX: reversed ? containerViewWidth - presentationFrame.minX : 0 - presentationFrame.maxX, y: 0)
        case .vertical:
            transform = .init(translationX: 0, y: reversed ? containerViewHeight - presentationFrame.minY : 0 - presentationFrame.maxY)
        case let .reversed(animation):
            if case let .reversed(anim) = animation {
                return anim.transform(using: transitionContext, presentationFrame: presentationFrame, reversed: !reversed)
            } else {
                return animation.transform(using: transitionContext, presentationFrame: presentationFrame, reversed: !reversed)
            }
        case .center:
            transform = .init(scaleX: 0.01, y: 0.01)
        case let .custom(_, transformer):
            transform = transformer(transitionContext)
        }
        return transform
    }
}
