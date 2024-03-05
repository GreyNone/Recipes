//
//  TranstionAnimations.swift
//  Recipes
//
//  Created by Александр Василевич on 15.11.23.
//

import UIKit

class TransitionAnimations {
    static func revealTransition() -> CATransition {
        let onDisplayFromLeftTransition = CATransition()
        onDisplayFromLeftTransition.duration = 0.5
        onDisplayFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        onDisplayFromLeftTransition.type = CATransitionType.reveal
        return onDisplayFromLeftTransition
    }
}
