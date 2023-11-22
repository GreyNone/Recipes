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
    private let selectedCellSize: CGSize
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType, startingPoint: CGPoint, selectedCellSize: CGSize) {
        self.animationDuration = animationDuration
        self.animationType = animationType
        self.startingPoint = startingPoint
        self.selectedCellSize = selectedCellSize
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
        presentedView.transform = CGAffineTransform(scaleX: selectedCellSize.width / presentedView.frame.width,
                                                    y: selectedCellSize.height / presentedView.frame.height)
        presentedView.alpha = 0

        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            presentedView.center = viewCenter
            presentedView.alpha = 1
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
     
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            dismissedView.center = self.startingPoint
            dismissedView.alpha = 0.1
            dismissedView.transform = CGAffineTransform(scaleX: selectedCellSize.width / dismissedView.frame.width,
                                                        y: selectedCellSize.height / dismissedView.frame.height)
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
