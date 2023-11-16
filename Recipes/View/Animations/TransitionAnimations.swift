//
//  TranstionAnimations.swift
//  Recipes
//
//  Created by Александр Василевич on 15.11.23.
//

import UIKit

class TransitionAnimations {
    
    static func onPushTransition() -> CATransition {
        let onPushTransition = CATransition()
        onPushTransition.duration = 0.25
        onPushTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        onPushTransition.type = CATransitionType.fade
        onPushTransition.subtype = CATransitionSubtype.fromBottom
        return onPushTransition
    }
    
    static func onPopTransition() -> CATransition {
        let onPopTransition = CATransition()
        onPopTransition.duration = 0.5
        onPopTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        onPopTransition.type = CATransitionType.reveal
        onPopTransition.subtype = CATransitionSubtype.fromTop
        return onPopTransition
    }
    
    static func onDisplayFromLeftTransition() -> CATransition {
        let onDisplayFromLeftTransition = CATransition()
        onDisplayFromLeftTransition.duration = 0.5
        onDisplayFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        onDisplayFromLeftTransition.type = CATransitionType.push
        onDisplayFromLeftTransition.subtype = CATransitionSubtype.fromLeft
        return onDisplayFromLeftTransition
    }
    
    static func onDisplayFromRightTransition() -> CATransition {
        let onDisplayFromRightTransition = CATransition()
        onDisplayFromRightTransition.duration = 0.5
        onDisplayFromRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        onDisplayFromRightTransition.type = CATransitionType.push
        onDisplayFromRightTransition.subtype = CATransitionSubtype.fromRight
        return onDisplayFromRightTransition
    }
}
