//
//  PredButton.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/12/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

// https://www.raywenderlich.com/162315/core-graphics-tutorial-part-1-getting-started

@IBDesignable
class PredBar: UIView {
    var contribValue: Float
    var contribRange: Float
    var barHeight: CGFloat
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, value: Float, range: Float, height: CGFloat) {
        contribValue = value
        contribRange = range
        barHeight = height
        super.init(frame: frame)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let fillColor = Utils.UIColorFromRGB(rgbValue: 0xFFA0A0A0)
        let strokeColor = Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F)
        
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: 0, y: 0))
        backPath.addLine(to: CGPoint(x: rect.width, y: 0))
        backPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        backPath.addLine(to: CGPoint(x: 0, y: rect.height))
        backPath.close()
        UIColor.white.setFill()
        backPath.fill()
        
        let xc = CGFloat(contribValue) * rect.width
        let squarePath = UIBezierPath()
        squarePath.move(to: CGPoint(x: 0, y: 0))
        squarePath.addLine(to: CGPoint(x: xc, y: 0))
        squarePath.addLine(to: CGPoint(x: xc, y: rect.height))
        squarePath.addLine(to: CGPoint(x: 0, y: rect.height))
        squarePath.close()
        fillColor.setFill()
        squarePath.fill()
        
        let xr = CGFloat(contribRange) * rect.width
        let lineHPath = UIBezierPath()
        lineHPath.lineWidth = 2
        lineHPath.move(to: CGPoint(x: 0, y: rect.height/2))
        lineHPath.addLine(to: CGPoint(x: xr, y: rect.height/2))
        strokeColor.setStroke()
        lineHPath.stroke()
        
        let lineVPath = UIBezierPath()
        lineVPath.lineWidth = 2
        lineVPath.move(to: CGPoint(x: xr - 1, y: rect.height/2 - barHeight/4))
        lineVPath.addLine(to: CGPoint(x: xr - 1, y: rect.height/2 + barHeight/4))        
        strokeColor.setStroke()
        lineVPath.stroke()
    }
}
