//
//  NewsFeedViewController.swift
//  Facebook
//
//  Created by Timothy Lee on 8/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    @IBOutlet weak var photo4: UIImageView!
    @IBOutlet weak var photo5: UIImageView!
    
    var isPresenting: Bool = true
    var imageViewToSegue: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
        
        self.photo1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapPhoto:"))
        self.photo2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapPhoto:"))
        self.photo3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapPhoto:"))
        self.photo4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapPhoto:"))
        self.photo5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapPhoto:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = 50
        scrollView.scrollIndicatorInsets.top = 0
        scrollView.scrollIndicatorInsets.bottom = 50
    }
    
    func onTapPhoto(gestureRecognizer: UITapGestureRecognizer) {
        imageViewToSegue = gestureRecognizer.view as UIImageView
        self.performSegueWithIdentifier("photoSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationViewController = segue.destinationViewController as PhotoViewController
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
        
        destinationViewController.photoDetail = self.imageViewToSegue.image
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let destinationImageCenter = CGPoint(x: 320/2, y: 284)
        let destinationImageHeight = CGFloat(480)
        var originImageCenter = self.imageViewToSegue.center
        
        if (isPresenting) {
            // Animating to transition
            var window = UIApplication.sharedApplication().keyWindow
            var copyImage = UIImageView()
            copyImage.frame = window.convertRect(imageViewToSegue.frame, fromView: scrollView)
            copyImage.image = imageViewToSegue.image
            copyImage.contentMode = UIViewContentMode.ScaleAspectFit
            copyImage.clipsToBounds = true
            
            var scaleFactor = CGFloat()
            let scaleWidth = window.frame.width / copyImage.frame.width
            let scaleHeight = destinationImageHeight / copyImage.frame.height
            let minScale = min(scaleWidth, scaleHeight)
            let maxScale = max(scaleWidth, scaleHeight)
            
            if (copyImage.image!.size.height > copyImage.image!.size.width) {
                scaleFactor = scaleHeight
            } else {
                scaleFactor = minScale
            }
            
            window.addSubview(copyImage)
            
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                copyImage.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
                copyImage.center = destinationImageCenter
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    copyImage.removeFromSuperview()
            }
        } else {
            // Animating return transition
            var photoViewController = fromViewController as PhotoViewController
            var feedViewController = toViewController as? NewsFeedViewController
            
            var window = UIApplication.sharedApplication().keyWindow
            var copyImage = UIImageView()
            var scaleFactor =  self.imageViewToSegue.frame.width / photoViewController.photoDetailView.frame.width
            
            var photoViewScrollPositionY = photoViewController.scrollPosition
            var photoFrame = photoViewController.photoDetailView.frame
            
            copyImage.image = photoViewController.photoDetailView.image
            copyImage.contentMode = UIViewContentMode.ScaleAspectFit
            copyImage.clipsToBounds = true
            copyImage.frame = photoViewController.photoDetailView.frame
            
            window.addSubview(copyImage)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                copyImage.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
                copyImage.center = window.convertPoint(originImageCenter, fromView: self.scrollView)
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    copyImage.removeFromSuperview()
            }
        }
    }

}
