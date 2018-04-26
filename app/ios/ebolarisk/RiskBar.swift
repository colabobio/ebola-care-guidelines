//
//  RiskBar.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/17/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

// https://www.raywenderlich.com/162315/core-graphics-tutorial-part-1-getting-started

@IBDesignable
class RiskBar: UIView {
    var riskScore: Float
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, risk: Float) {
        riskScore = risk
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        let startColor: UIColor = Utils.UIColorFromRGB(rgbValue: 0xFFADADAD)
        let endColor: UIColor = Utils.UIColorFromRGB(rgbValue: 0xFFAD2D21)
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: bounds.width, y: 0)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        let xr = CGFloat(riskScore) * rect.width
        let lineVPath = UIBezierPath()
        lineVPath.lineWidth = 2
        lineVPath.move(to: CGPoint(x: xr, y: 0))
        lineVPath.addLine(to: CGPoint(x: xr, y: rect.height))
        UIColor.black.setStroke()
        lineVPath.stroke()
    }
}
