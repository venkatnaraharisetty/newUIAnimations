//
//  ImageTransitionDelegate.swift
//  newUIAnimations
//
//  Created by Naraharisetty, Venkat on 12/24/18.
//  Copyright © 2018 Naraharisetty, Venkat. All rights reserved.
//

import UIKit

protocol Scaling {
    func animateImageView (transition:ImageTransitionDelegate) -> UIImageView?
}

enum TransitionState {
    case begin
    case end
}
class ImageTransitionDelegate: NSObject {
    let animatedDuration = 0.9
    var navigationControlOperation:UINavigationController.Operation = .none
}

extension ImageTransitionDelegate: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animatedDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else {return}
        guard let toVC = transitionContext.viewController(forKey: .to) else {return}
        
        var backgroundVC = fromVC
        var foregroundVC = toVC
        if navigationControlOperation == .pop {
            backgroundVC = toVC
            foregroundVC = fromVC
        }
        guard let backgroundImageView = (backgroundVC as? Scaling)?.animateImageView(transition: self) else {
            return
        }
        guard let foregroundImageView = (foregroundVC as? Scaling)?.animateImageView(transition: self) else {
            return
        }
        
        let imageViewSnapShot = UIImageView(image: backgroundImageView.image)
        imageViewSnapShot.contentMode = .scaleAspectFill
        imageViewSnapShot.layer.masksToBounds = true
        if navigationControlOperation == .pop {
            imageViewSnapShot.layer.cornerRadius = 14
        }
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foreGroundColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapShot)
        var transitionStateFrom = TransitionState.begin
        var transitionStateTo = TransitionState.end
        
        if navigationControlOperation == .pop {
            transitionStateFrom = .end
            transitionStateTo = .begin
        }
        prepareView(for: transitionStateFrom, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foreGroundImageView: foregroundImageView, snapshotImageView: imageViewSnapShot)
        
        foregroundVC.view.layoutIfNeeded()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.prepareView(for: transitionStateTo, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foreGroundImageView: foregroundImageView, snapshotImageView: imageViewSnapShot)
        }){ _ in
            backgroundVC.view.transform = .identity
            imageViewSnapShot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundVC.view.backgroundColor = foreGroundColor
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
    
    func prepareView(for state:TransitionState, containerView:UIView, backgroundVC:UIViewController,backgroundImageView:UIImageView, foreGroundImageView:UIImageView, snapshotImageView:UIImageView){
        switch state {
        case .begin:
            backgroundVC.view.transform = .identity
            backgroundVC.view.alpha = 1
            
            snapshotImageView.frame = containerView.convert(backgroundImageView.frame, from: backgroundImageView.superview)
        case .end:
            backgroundVC.view.alpha = 0
            snapshotImageView.frame = containerView.convert(foreGroundImageView.frame, from: foreGroundImageView.superview)
            
        }
    }
    
}


extension ImageTransitionDelegate:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is Scaling && toVC is Scaling {
            print("fromVC and ToVC confirm to scaling")
            self.navigationControlOperation = operation
            var navbarIsVisible = false
            if operation == .pop{
                navbarIsVisible =  true
            }
            navigationController.setNavigationBarHidden(!navbarIsVisible, animated: true)
            //self.nav
            return self
        } else {
            return nil
        }
    }
}
