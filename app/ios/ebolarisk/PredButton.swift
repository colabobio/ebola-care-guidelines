//
//  PredButton.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/18/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

@IBDesignable
class PredButton: UIButton {
    var crossColorRGBValue: UInt
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, rgbValue: UInt) {
        crossColorRGBValue = rgbValue
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        let crossSize = CGFloat(30)
        let textTab = CGFloat(20)
        let crossColor = Utils.UIColorFromRGB(rgbValue: crossColorRGBValue)
        let strokeColor = Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F)
        
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: 0, y: 0))
        backPath.addLine(to: CGPoint(x: rect.width, y: 0))
        backPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        backPath.addLine(to: CGPoint(x: 0, y: rect.height))
        backPath.addLine(to: CGPoint(x: 0, y: 0))
        strokeColor.setStroke()
        backPath.stroke()
        
        // Draw cross
        var x0 = rect.width - crossSize - textTab
        var y0 = rect.height/2 - crossSize/4
        var x1 = x0 + crossSize
        var y1 = y0 + crossSize/2
        let HPath = UIBezierPath()
        HPath.move(to: CGPoint(x: x0, y: y0))
        HPath.addLine(to: CGPoint(x: x1, y: y0))
        HPath.addLine(to: CGPoint(x: x1, y: y1))
        HPath.addLine(to: CGPoint(x: x0, y: y1))
        HPath.addLine(to: CGPoint(x: x0, y: y0))
        crossColor.setFill()
        HPath.fill()
        
        x0 = rect.width - crossSize - textTab + crossSize/4
        y0 = rect.height/2 - crossSize/2
        x1 = x0 + crossSize/2
        y1 = y0 + crossSize
        let VPath = UIBezierPath()
        VPath.move(to: CGPoint(x: x0, y: y0))
        VPath.addLine(to: CGPoint(x: x1, y: y0))
        VPath.addLine(to: CGPoint(x: x1, y: y1))
        VPath.addLine(to: CGPoint(x: x0, y: y1))
        VPath.addLine(to: CGPoint(x: x0, y: y0))
        crossColor.setFill()
        VPath.fill()
    }
}
