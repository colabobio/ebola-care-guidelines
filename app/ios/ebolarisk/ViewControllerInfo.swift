//
//  ViewControllerInfo.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/24/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerInfo: UIViewController {

    let titleFont = UIFont.boldSystemFont(ofSize: 17)
    let infoFont = UIFont.systemFont(ofSize: 14)
    let warnFont = UIFont.boldSystemFont(ofSize: 17)
    let contactFont = UIFont.systemFont(ofSize: 13)
    let titlePaddingY = CGFloat(12)
    let leftMargin = CGFloat(8)
    let topMargin = CGFloat(70)
    let itemSpacing = CGFloat(10)
    let warnPaddingY = CGFloat(10)
    
    let titleMsg = "Important information"
    let infoMsg = "Ebola RISK is a proof-of-concept app designed to illustrate how Machine Learning models for clinical prognosis could inform patient care and management. It offers treatment options compiled from WHO\'s guidelines for hemorrhagic fever patients, prioritized by predicted mortality risk."
    let warnMsg = "Because it is a research prototype, this app should NOT be used to make treatment decisions on actual patients."
    let preprintMsg = "Get the preprint of the article describing the derivation and validation of the models from:"
    let preprintURL = "http://biorxiv.org/cgi/content/short/294587v3"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.drawInfo()
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawInfo() {
        let xpos = leftMargin
        var ypos = topMargin

        ypos += addTitle(title: titleMsg, left: xpos, top: ypos) + itemSpacing
        ypos += addInfoMsg(text: infoMsg, left: xpos, top: ypos) + itemSpacing
        ypos += addWarnMsg(text: warnMsg, left: xpos, top: ypos) + itemSpacing
        ypos += addPreprintMsg(text: preprintMsg, left: xpos, top: ypos) + itemSpacing
        ypos += addPreprintURL(url: preprintURL, left: xpos, top: ypos)
    }
    
    func addTitle(title: String, left: CGFloat, top: CGFloat) -> CGFloat {
        let w = ceil(view.frame.width - 2 * left)
        let h = ceil(Utils.textHeight(Text: title, usingFont: titleFont, constrainingWidth: w) + 2 * titlePaddingY)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = titleFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: 0xFF000000)
        label.backgroundColor = .white
        label.text = title
        view.addSubview(label)
        return h
    }
    
    func addInfoMsg(text: String, left: CGFloat, top: CGFloat) -> CGFloat {
        let color: UInt = 0xFF000000
        let w = ceil(view.frame.width - 2 * left)
        let h = ceil(Utils.textHeight(Text: text, usingFont: infoFont, constrainingWidth: w))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = infoFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: color)
        label.backgroundColor = .white
        label.text = text
        view.addSubview(label)
        return h
    }
    
    func addWarnMsg(text: String, left: CGFloat, top: CGFloat) -> CGFloat {
        let color: UInt = 0xFFFFFFFF
        let w = ceil(view.frame.width)
        let h = ceil(Utils.textHeight(Text: text, usingFont: warnFont, constrainingWidth: w) + 2 * warnPaddingY)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: w/2, y: top + h/2)
        label.font = warnFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: color)
        label.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xFFD47272)
        label.text = text
        view.addSubview(label)
        return h
    }
    
    func addPreprintMsg(text: String, left: CGFloat, top: CGFloat) -> CGFloat {
        let color: UInt = 0xFF000000
        let w = ceil(view.frame.width - 2 * left)
        let h = ceil(Utils.textHeight(Text: text, usingFont: contactFont, constrainingWidth: w))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = contactFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: color)
        label.backgroundColor = .white
        label.text = text
        view.addSubview(label)
        return h
    }
    
    
    func addPreprintURL(url: String, left: CGFloat, top: CGFloat) -> CGFloat {
        let w = ceil(view.frame.width - 2 * left)
        let h = ceil(Utils.textHeight(Text: url, usingFont: contactFont, constrainingWidth: w))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        label.center = CGPoint(x: left + w/2, y: top + h/2)
        label.font = contactFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Utils.UIColorFromRGB(rgbValue: 0xFFDC27A8)
        label.backgroundColor = .white
        label.text = url
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerInfo.tapFunction(sender:)))
        label.addGestureRecognizer(tap)
        view.addSubview(label)
        return h
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        guard let url = URL(string: preprintURL) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
