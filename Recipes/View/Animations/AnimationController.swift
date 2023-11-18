//
//  AnimationController.swift
//  Recipes
//
//  Created by Александр Василевич on 16.11.23.
//

import UIKit

class AnimationController: NSObject {
    
    private let animationDuration: Double
    private let animationType: AnimationType
    private let startingPoint: CGPoint
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType, startingPoint: CGPoint) {
        self.animationDuration = animationDuration
        self.animationType = animationType
        self.startingPoint = startingPoint
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            presentAnimation(with: transitionContext)
        case .dismiss:
            dismissAnimation(with: transitionContext)
        }
    }
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        transitionContext.containerView.addSubview(presentedView)
        
        let viewCenter = presentedView.center
        presentedView.center = startingPoint
        presentedView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut) {
            presentedView.center = viewCenter
            presentedView.transform = CGAffineTransform.identity
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissedView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.addSubview(dismissedView)

        let duration = transitionDuration(using: transitionContext)
     
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            dismissedView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
