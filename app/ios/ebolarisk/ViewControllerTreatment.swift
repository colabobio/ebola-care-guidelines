//
//  Layout.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerTreatment: UIViewController {    
    let titleFont = UIFont.boldSystemFont(ofSize: 17)
    let subtitleFont = UIFont.boldSystemFont(ofSize: 14)
    let bodyFont = UIFont.systemFont(ofSize: 14)
    let footnoteFont = UIFont.systemFont(ofSize: 12)
    let tableFont = UIFont.systemFont(ofSize: 14)

    let titlePaddingY = CGFloat(12)
    
    let minCellWidth = CGFloat(50)
    let maxCellWidth = CGFloat(100)
    let cellPaddingY = CGFloat(12)
    let cellPaddingX = CGFloat(5)
    let cellSpacing = CGFloat(2)
    
    var containerView: UIView

    required init?(coder aDecoder: NSCoder) {
        containerView = UIView()
        super.init(coder: aDecoder)
    }
    
    func initView(container: UIView) {
        containerView = container
        DispatchQueue.main.async {
            let h = self.createLayout()
            self.addHeightConstrain(height: h)
            self.view.layoutIfNeeded()
        }
    }
    
    func createLayout() -> CGFloat {
        return 0
    }
    
    func addHeightConstrain(height: CGFloat) {
        // Setting the height constrain to enable scrolling
        let heightConstraint = NSLayoutConstraint(item: containerView,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.notAnAttribute,
                                                  multiplier: 1,
                                                  constant: CGFloat(height))
        view.addConstraint(heightConstraint)
    }
        
    func addMainTitle(title: String, left: CGFloat, top: CGFloat) -> CGFloat {
        return addTitle(title: title, left: left, top: top, font: titleFont, color: 0xFF000000)
    }
    
    func addSubTitle(title: String, left: CGFloat, top: CGFloat) -> CGFloat {
        return addTitle(title: title, left: left, top: top, font: subtitleFont, color: 0xFF000000)
    }
    
    func addTitle(title: String, left: CGFloat, top: CGFloat, font: UIFont, color: UInt) -> CGFloat {
        let w = ceil(view.frame.width - 2 * left)
        let h = ceil(Utils.textHeight(Text: title, usingFont: bodyFont, constrainingWidth: w) + 2 * titlePaddingY)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = font
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: color)
        label.backgroundColor = .white
        label.text = title
        containerView.addSubview(label)
        return h
    }
    
    func addFootNote(text: String, left: CGFloat, top: CGFloat) -> CGFloat {
        let w = ceil(view.frame.width - 2 * left)
        let h = ceil(Utils.textHeight(Text: text, usingFont: bodyFont, constrainingWidth: w))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = footnoteFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: 0xFF000000)
        label.backgroundColor = .white
        label.text = text
        containerView.addSubview(label)
        return h
    }
    
    func addTextParagraph(text: String, left: CGFloat, top: CGFloat) -> CGFloat {
        let color: UInt = 0xFF000000
        let w = ceil(view.frame.width - 2 * left)
        let h = ceil(Utils.textHeight(Text: text, usingFont: bodyFont, constrainingWidth: w))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = bodyFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: color)
        label.backgroundColor = .white
        label.text = text
        containerView.addSubview(label)
        return h
    }
    
    func create2ColumnTable(column1: [String], column2: [String], selRow: Int, left: CGFloat, top: CGFloat) -> CGFloat {
        let nrows = column1.count
        let w = ceil(view.frame.width - 2 * left)
        var y = top
        
        // The maximum width is determined from the label column only, the rest of the space is allocated to the data column
        var labelw = CGFloat(0)
        for r in 0...nrows - 1 {
            let label = column1[r]
            let size = Utils.textSize(Text: label, usingFont: tableFont)
            let w = min(maxCellWidth, ceil(size.width) + 2 * cellPaddingX)
            labelw = max(labelw, max(minCellWidth, w))
        }
        
        for r in 0...nrows - 1 {
            let label = column1[r]
            let value = column2[r]
            let valuew = w - labelw - cellSpacing
            let labelh = ceil(Utils.textHeight(Text: label, usingFont: tableFont, constrainingWidth: labelw) + 2 * cellPaddingY)
            let valueh = ceil(Utils.textHeight(Text: value, usingFont: tableFont, constrainingWidth: valuew) + 2 * cellPaddingY)
            let maxh = max(labelh, valueh)
            var x = left
            let textColLabel = UInt(0xFFFFFFFF as UInt32)
            var backColLabel = UInt(0xFF000000 as UInt32)
            var textcolValue = UInt(0xFF000000 as UInt32)
            var backColValue = UInt(0xFFFFFFFF as UInt32)
            if r == 0 {
                backColLabel = UInt(0xff6b6b6b as UInt32)
                backColValue = UInt(0xff6b6b6b as UInt32)
                textcolValue = UInt(0xFFFFFFFF as UInt32)
            } else {
                backColLabel = UInt(0xff949494 as UInt32)
            }
            if r == selRow {
                backColLabel = UInt(0xFFFF4081 as UInt32)
                backColValue = UInt(0xFFFF4081 as UInt32)
                textcolValue = UInt(0xFFFFFFFF as UInt32)
            }
            addTextCell(text: label, left: x, top: y, width: labelw, height: maxh, textColor: textColLabel, cellColor: backColLabel)
            x += labelw + cellSpacing
            addTextCell(text: value, left: x, top: y, width: valuew, height: maxh, textColor: textcolValue, cellColor: backColValue)
            y += maxh + cellSpacing
        }
        
        return y - top
    }
    
    func create3ColumnTable(column1: [String], column2: [String], column3: [String], selRow: Int, left: CGFloat, top: CGFloat) -> CGFloat {
        let nrows = column1.count
        let w = ceil(view.frame.width - 2 * left)
        var y = top
        
        // The maximum width is determined from the label columns only, the rest of the space is allocated to the data column
        var labelw1 = CGFloat(0)
        for r in 0...nrows - 1 {
            let label1 = column1[r]
            let size1 = Utils.textSize(Text: label1, usingFont: tableFont)
            let w1 = min(maxCellWidth, ceil(size1.width) + 2 * cellPaddingX)
            labelw1 = max(labelw1, max(minCellWidth, w1))
        }
        
        for r in 0...nrows - 1 {
            let label1 = column1[r]
            let value1 = column2[r]
            let value2 = column3[r]
            let valuew = (w - labelw1 - 2 * cellSpacing)/2
            let labelh1 = ceil(Utils.textHeight(Text: label1, usingFont: tableFont, constrainingWidth: labelw1) + 2 * cellPaddingY)
            let valueh1 = ceil(Utils.textHeight(Text: value1, usingFont: tableFont, constrainingWidth: valuew) + 2 * cellPaddingY)
            let labelh2 = ceil(Utils.textHeight(Text: value2, usingFont: tableFont, constrainingWidth: valuew) + 2 * cellPaddingY)
            let maxh = max(labelh1, valueh1, labelh2)
            var x = left
            let textColLabel = UInt(0xFFFFFFFF as UInt32)
            var backColLabel = UInt(0xFF000000 as UInt32)
            var textcolValue = UInt(0xFF000000 as UInt32)
            var backColValue = UInt(0xFFFFFFFF as UInt32)
            if r == 0 {
                backColLabel = UInt(0xff6b6b6b as UInt32)
                backColValue = UInt(0xff6b6b6b as UInt32)
                textcolValue = UInt(0xFFFFFFFF as UInt32)
            } else {
                backColLabel = UInt(0xff949494 as UInt32)
            }
            if r == selRow {
                backColLabel = UInt(0xFFFF4081 as UInt32)
                backColValue = UInt(0xFFFF4081 as UInt32)
                textcolValue = UInt(0xFFFFFFFF as UInt32)
            }
            addTextCell(text: label1, left: x, top: y, width: labelw1, height: maxh, textColor: textColLabel, cellColor: backColLabel)
            x += labelw1 + cellSpacing
            addTextCell(text: value1, left: x, top: y, width: valuew, height: maxh, textColor: textcolValue, cellColor: backColValue)
            x += valuew + cellSpacing
            addTextCell(text: value2, left: x, top: y, width: valuew, height: maxh, textColor: textcolValue, cellColor: backColValue)
            y += maxh + cellSpacing
        }
        
        return y - top
    }
    
    func create3ColumnDoubleEntryTable(column1: [String], column2: [String], column3: [String], selRow: Int, left: CGFloat, top: CGFloat) -> CGFloat {
        let nrows = column1.count
        let w = ceil(view.frame.width - 2 * left)
        var y = top
        
        // The maximum width is determined from the label columns only, the rest of the space is allocated to the data column
        var labelw1 = CGFloat(0)
        var labelw2 = CGFloat(0)
        for r in 0...nrows - 1 {
            let label1 = column1[r]
            let label2 = column3[r]
            let size1 = Utils.textSize(Text: label1, usingFont: tableFont)
            let size2 = Utils.textSize(Text: label2, usingFont: tableFont)
            let w1 = min(maxCellWidth, ceil(size1.width) + 2 * cellPaddingX)
            let w2 = min(maxCellWidth, ceil(size2.width) + 2 * cellPaddingX)
            labelw1 = max(labelw1, max(minCellWidth, w1))
            labelw2 = max(labelw2, max(minCellWidth, w2))
        }
        
        for r in 0...nrows - 1 {
            let label1 = column1[r]
            let value = column2[r]
            let label2 = column3[r]
            let valuew = w - labelw1 - labelw2 - 2 * cellSpacing
            let labelh1 = ceil(Utils.textHeight(Text: label1, usingFont: tableFont, constrainingWidth: labelw1) + 2 * cellPaddingY)
            let valueh = ceil(Utils.textHeight(Text: value, usingFont: tableFont, constrainingWidth: valuew) + 2 * cellPaddingY)
            let labelh2 = ceil(Utils.textHeight(Text: label2, usingFont: tableFont, constrainingWidth: labelw2) + 2 * cellPaddingY)
            let maxh = max(labelh1, valueh, labelh2)
            var x = left
            let textColLabel = UInt(0xFFFFFFFF as UInt32)
            var backColLabel = UInt(0xFF000000 as UInt32)
            var textcolValue = UInt(0xFF000000 as UInt32)
            var backColValue = UInt(0xFFFFFFFF as UInt32)
            if r == 0 {
                backColLabel = UInt(0xff6b6b6b as UInt32)
                backColValue = UInt(0xff6b6b6b as UInt32)
                textcolValue = UInt(0xFFFFFFFF as UInt32)
            } else {
                backColLabel = UInt(0xff949494 as UInt32)
            }
            if r == selRow {
                backColLabel = UInt(0xFFFF4081 as UInt32)
                backColValue = UInt(0xFFFF4081 as UInt32)
                textcolValue = UInt(0xFFFFFFFF as UInt32)
            }
            addTextCell(text: label1, left: x, top: y, width: labelw1, height: maxh, textColor: textColLabel, cellColor: backColLabel)
            x += labelw1 + cellSpacing
            addTextCell(text: value, left: x, top: y, width: valuew, height: maxh, textColor: textcolValue, cellColor: backColValue)
            x += valuew + cellSpacing
            addTextCell(text: label2, left: x, top: y, width: labelw2, height: maxh, textColor: textColLabel, cellColor: backColLabel)
            y += maxh + cellSpacing
        }
        
        return y - top
    }
    
    func addTextCell(text: String, left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat, textColor: UInt, cellColor: UInt) {
        let w = ceil(width)
        let h = ceil(height)
        let label = CellLabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.leftTextInset = cellPaddingX
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = tableFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: textColor)
        label.backgroundColor = Utils.UIColorFromRGB(rgbValue: cellColor)
        label.text = text
        containerView.addSubview(label)
    }
}
