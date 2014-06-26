//
//  ViewController.swift
//  BouncyView
//
//  Created by Arkadiusz on 26-06-14.
//  Copyright (c) 2014 Arkadiusz Holko. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet var sideHelperView: UIView
    @IBOutlet var centerHelperView: UIView
    @IBOutlet var bouncyView: BouncyView

    @IBOutlet var sideHelperTopConstraint: NSLayoutConstraint
    @IBOutlet var centerHelperTopConstraint: NSLayoutConstraint
    @IBOutlet var bouncyViewTopConstraint: NSLayoutConstraint

    var displayLink: CADisplayLink?
    var animationCount = 0
    let animationDuration = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()

        // reset starting positions (views are in bounds in storyboard for the ease of usage)
        for constraint in [sideHelperTopConstraint, centerHelperTopConstraint, bouncyViewTopConstraint] {
            constraint.constant = 0
        }

        // hide the dummy views
        sideHelperView.hidden = true
        centerHelperView.hidden = true
    }

    @IBAction func toggleVisibility(sender: UIButton) {
        let actionSheetHeight: Float = CGRectGetHeight(bouncyView.frame)
        let hiddenTopMargin: Float = 0
        let showedTopMargin: Float = -actionSheetHeight
        let newTopMargin: Float = abs(centerHelperTopConstraint.constant - hiddenTopMargin) < 1 ? showedTopMargin : hiddenTopMargin
        let options: UIViewAnimationOptions = .BeginFromCurrentState | .AllowUserInteraction

        sideHelperTopConstraint.constant = newTopMargin
        animationWillStart()
        UIView.animateWithDuration(animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.8,
            options: options,
            animations: {
                self.sideHelperView.layoutIfNeeded()
            }, completion: { _ in
                self.animationDidComplete()
            }
        )

        centerHelperTopConstraint.constant = newTopMargin
        animationWillStart()
        UIView.animateWithDuration(animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.9,
            options: options,
            animations: {
                self.centerHelperView.layoutIfNeeded()
            }, completion: { _ in
                self.animationDidComplete()
            }
        )
    }

    func tick(displayLink: CADisplayLink) {
        let sideHelperPresentationLayer = sideHelperView.layer.presentationLayer() as CALayer
        let centerHelperPresentationLayer = centerHelperView.layer.presentationLayer() as CALayer
        let newBouncyViewTopConstraint = CGRectGetMinY(sideHelperPresentationLayer.frame) - CGRectGetMaxY(view.frame)

        bouncyViewTopConstraint.constant = newBouncyViewTopConstraint
        bouncyView.layoutIfNeeded()

        bouncyView.sideToCenterDelta = CGRectGetMinY(sideHelperPresentationLayer.frame) - CGRectGetMinY(centerHelperPresentationLayer.frame)
        bouncyView.setNeedsDisplay()
    }

    func animationWillStart() {
        if !displayLink {
            displayLink = CADisplayLink(target: self, selector: "tick:")
            displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }

        animationCount++
    }

    func animationDidComplete() {
        animationCount--
        if animationCount == 0 {
            displayLink!.invalidate()
            displayLink = nil
        }
    }
}
