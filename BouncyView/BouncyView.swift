//
//  BouncyView.swift
//  BouncyView
//
//  Created by Arkadiusz on 26-06-14.
//  Copyright (c) 2014 Arkadiusz Holko. All rights reserved.
//

import UIKit
import CoreGraphics

class BouncyView: UIView {

    var sideToCenterDelta: Float = 0.0
    let fillColor = UIColor(red: 0, green: 0.722, blue: 1, alpha: 1) // blue color

    override func drawRect(rect: CGRect) {
        let yOffset: Float = 20.0
        let width = CGRectGetWidth(rect)
        let height = CGRectGetHeight(rect)

        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0.0, y: yOffset))
        path.addQuadCurveToPoint(CGPoint(x: width, y: yOffset),
            controlPoint:CGPoint(x: width / 2.0, y: yOffset + sideToCenterDelta))
        path.addLineToPoint(CGPoint(x: width, y: height))
        path.addLineToPoint(CGPoint(x: 0.0, y: height))
        path.closePath()

        let context = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path.CGPath)
        fillColor.set()
        CGContextFillPath(context)
    }
}
