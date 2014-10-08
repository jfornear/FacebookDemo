//
//  PhotoViewController.swift
//  Facebook
//
//  Created by Jesse Fornear on 10/7/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var photoDetailView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionButtons: UIImageView!
    
    var photoDetail: UIImage!
    var photoViewOrigin = CGPoint()
    var scrollPosition = CGFloat()
    var opacity = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photoDetailView.image = photoDetail
        scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onDoneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // This method is called as the user scrolls
        photoViewOrigin = photoDetailView.frame.origin
        self.doneButton.alpha = 0
        self.actionButtons.alpha = 0
        opacity = (1 - abs(scrollView.contentOffset.y/568))
        
        self.view.backgroundColor = UIColor(white: 0, alpha: opacity)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool) {
            // This method is called right as the user lifts their finger
            if (scrollView.contentOffset.y == 0 || abs(scrollView.contentOffset.y) <= 100) {
                UIView.animateWithDuration(0.2) {
                    self.photoDetailView.frame.origin.y = self.photoViewOrigin.y
                }
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        // This method is called when the scrollview finally stops scrolling.
        self.doneButton.alpha = 1
        self.actionButtons.alpha = 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
