//
//  PredMargin.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/18/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import Foundation

@IBDesignable
class PredMargin: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let strokeColor = Utils.UIColorFromRGB(rgbValue: 0xFFC9C9C9)
        
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: 0, y: 0))
        backPath.addLine(to: CGPoint(x: rect.width, y: 0))
        backPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        backPath.addLine(to: CGPoint(x: 0, y: rect.height))
        backPath.close()
        UIColor.white.setFill()
        backPath.fill()
        
        let lineVPath = UIBezierPath()
        lineVPath.lineWidth = 2
        lineVPath.move(to: CGPoint(x: rect.width - 1, y: 0))
        lineVPath.addLine(to: CGPoint(x: rect.width - 1, y: rect.height))
        strokeColor.setStroke()
        lineVPath.stroke()
    }
}
