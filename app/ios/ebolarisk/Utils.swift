//
//  Utils.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/21/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import Foundation

class Utils {
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func textWidth(Text str: String, usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = (str as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
    
    static func textHeight(Text str: String, usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = (str as NSString).size(withAttributes: fontAttributes)
        return size.height
    }
    
    static func textSize(Text str: String, usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedStringKey.font: font]
        return (str as NSString).size(withAttributes: fontAttributes)
    }
    
    static func textHeight(Text str: String, usingFont font: UIFont, constrainingWidth width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = str
        label.sizeToFit()
        return label.frame.height
    }
}
