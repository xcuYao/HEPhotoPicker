//
//  HETransitionsAnimator.swift
//  HEPhotoPicker
//
//  Created by mac on 2019/5/28.
//

import UIKit

class HETransitionsAnimator: NSObject {
    var sourceImageView: UIImageView?
    var destinationImageView: UIImageView?
    public var transitionType : HETransitionType = .navigation
    
    
}

extension HETransitionsAnimator : UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate{
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
    // 返回动画时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    // 要设置的动画
    //UIKit calls this method when presenting or dismissing a view controller. Use this method to configure the animations associated with your custom transition. You can use view-based animations or Core Animation to configure your animations.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let sourceImageView = sourceImageView, let destinationImageView = destinationImageView{
            let containerView = transitionContext.containerView
            // Disable selection so we don't select anything while the push animation is running
            fromViewController.view?.isUserInteractionEnabled = false
            
            // Setup views
            sourceImageView.isHidden = true
            destinationImageView.isHidden = true
            toViewController.view.alpha = 0.0
            fromViewController.view.alpha = 1.0
            containerView.backgroundColor = toViewController.view.backgroundColor
            
            // Setup scaling image
            let scalingFrame = containerView.convert(sourceImageView.frame, from: sourceImageView.superview)
            let scalingImage = UIImageView(frame: scalingFrame)
            scalingImage.contentMode = sourceImageView.contentMode
            scalingImage.image = sourceImageView.image
            scalingImage.clipsToBounds = true
            
            //Init image scale
            let destinationFrame = containerView.convert(destinationImageView.frame, from: destinationImageView.superview)
            
            // Add views to container view
            containerView.addSubview(toViewController.view)
            containerView.addSubview(scalingImage)
            
            // Animate
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0.0,
                           options: UIView.AnimationOptions(),
                           animations: { () -> Void in
                            // Fade in
                            fromViewController.view.alpha = 0.0
                            toViewController.view.alpha = 1.0
                            
                            scalingImage.frame = destinationFrame
                            scalingImage.contentMode = destinationImageView.contentMode
            }, completion: { (finished) -> Void in
                scalingImage.removeFromSuperview()
                
                // Unhide
                destinationImageView.isHidden = false
                sourceImageView.isHidden = false
                fromViewController.view.alpha = 1.0
                
                // Finish transition
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
                // Enable selection again
                fromViewController.view?.isUserInteractionEnabled = true
            })
        }
    }

  
}
