//
//  ViewControllerPred.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/12/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerPred: UIViewController {
    static let INT    = 0
    static let FLOAT  = 1
    static let BINARY = 2
    
    let dataHolder = DataHolder.instance

    let riskHeight = CGFloat(50)
    let marginLeft = CGFloat(20)
    let colSpacing = CGFloat(5)
    let padding = CGFloat(10)
    let barHeight = CGFloat(50)
    let varHeight = CGFloat(85)
    let margin2 = CGFloat(50)
    let rowSpacing = CGFloat(10)
    let textTab = CGFloat(20)
    
    let errorMsg1 = "Not enough information!"
    let errorMsg2 = "You need to provide at least patient's age and RT-PCR Cycle Threshold (CT) value."
    
    let varOrder = ["cycletime", "PatientAge", "FeverTemperature", "Jaundice", "Bleeding", "Headache", "Diarrhoea", "Vomit", "AbdominalPain", "AstheniaWeakness", "WellnessScale"]
    
    let varAlias = ["PCR CT", "Age", "Temperature", "Jaundice", "Bleeding", "Headache", "Diarrhoea", "Vomiting", "Abdomen pain", "Weakness", "Wellness"]
    
    let varSymptom = ["Viral load", "Age", "Fever", "Jaundice", "Bleeding", "Headache", "Diarrhoea", "Vomiting", "Abdomen pain", "Weakness", "Wellness"]
    
    let varSegues = ["Viral load":"showVLoadSegue",
                     "Age":"showAgeSegue",
                     "Fever":"showFeverSegue",
                     "Jaundice":"showJaundiceSegue",
                     "Bleeding":"showBleedingSegue",
                     "Headache":"showHeadacheSegue",
                     "Diarrhoea":"showDiarrheaSegue",
                     "Vomiting":"showVomitSegue",
                     "Abdomen pain":"showPainSegue",
                     "Weakness":"showWeakSegue"]
    
    let varTypes = [INT, INT, FLOAT, BINARY, BINARY, BINARY, BINARY, BINARY, BINARY, BINARY, INT]
    
    let binLabels = ["no", "yes"]
    
    // MARK: properties
    @IBOutlet weak var predView: UIView!
    
    required init?(coder aDecoder: NSCoder) {        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let showTreatment = UserDefaults.standard.bool(forKey: "show_treatments")
        let riskThreshold = UserDefaults.standard.float(forKey: "highrisk_threshold")
        let contribThreshold = UserDefaults.standard.float(forKey: "min_predcontrib")
        
        print("Show Treatment " + String(showTreatment))
        print("High risk threshold " + String(riskThreshold))
        print("Min pred contrib " + String(contribThreshold))
        
        // viewDidLoad() is called everytime the view is open by clicking on the RISK button. Other options for lifecycle:
        // http://matteomanferdini.com/the-common-lifecycle-of-a-view-controller/
        
        DispatchQueue.main.async {
            if let model = self.dataHolder.getSelectedModel() {
                if showTreatment {
                    self.drawPredGuide(model: model, riskThreshold: riskThreshold, contribThreshold: contribThreshold)
                } else {
                    self.drawPredCharts(model: model)
                }
            } else {
                self.drawError()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawError() {
        let w = self.view.frame.width
        let h = self.view.frame.height
        let margin = CGFloat(30.0)
        
        let font = UIFont.preferredFont(forTextStyle: .title2)
        let hBox = ceil(3 * (font.ascender + font.descender + font.leading))
        var yBox = 0.3 * h - hBox/2
        let label1 = UILabel(frame: CGRect(x: 0, y: yBox, width: w, height: hBox))
        label1.center = CGPoint(x: w/2, y: yBox + hBox/2)
        label1.textAlignment = .center
        label1.textColor = .white
        label1.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xFFD47272)
        label1.font = font
        label1.text = errorMsg1
        
        yBox += hBox + 20
        
        let label2 = UILabel(frame: CGRect(x: margin, y: yBox, width: w - 2 * margin, height: 2 * hBox))
        label2.center = CGPoint(x: w/2, y: yBox + 1 * hBox)
        label2.textAlignment = .center
        label2.textColor = Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F)
        label2.backgroundColor = .white
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        label2.font = font
        label2.text = errorMsg2
        
        self.predView.addSubview(label1)
        self.predView.addSubview(label2)
    }
    
    func drawPredCharts(model: LogRegModel) {
        let data = dataHolder.getCurrentData()
        let risk = model.eval(values: data)
        let details = model.evalDetails(values: data)

        let w = self.view.frame.width
        let marginRight = getMarginRight(risk: risk, details: details)
        
        let titleFont = UIFont.preferredFont(forTextStyle: .title1)
        var hBox = 3 * (titleFont.ascender + titleFont.descender + titleFont.leading)
        var yTop = CGFloat(0)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: yTop, width: w, height: hBox))
        titleLabel.center = CGPoint(x: w/2, y: yTop + hBox/2)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xFF00A79D)
        titleLabel.font = titleFont
        titleLabel.text = "Mortality risk of patient"
        self.predView.addSubview(titleLabel)
        yTop += hBox + 2 * padding
        
        let barWidth = w - marginLeft - marginRight;
        let riskBar = RiskBar(frame: CGRect(x: marginLeft, y: yTop, width: barWidth, height: riskHeight), risk: risk)
        self.predView.addSubview(riskBar)
        
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let riskLabel = UILabel(frame: CGRect(x: marginLeft + barWidth + colSpacing, y: yTop, width: w - (marginLeft + barWidth + colSpacing), height: riskHeight))
        riskLabel.center = CGPoint(x: (w  + marginLeft + barWidth + colSpacing)/2, y: yTop + riskHeight/2)
        riskLabel.textAlignment = .left
        riskLabel.textColor = Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F)
        riskLabel.backgroundColor = .white
        riskLabel.font = bodyFont
        riskLabel.text = String(Int(risk * 100)) + "%"
        self.predView.addSubview(riskLabel)

        yTop += riskHeight + 2 * padding;
        
        self.predView.addSubview(PredMargin(frame: CGRect(x: 0, y: yTop - riskHeight - 4 * padding, width: marginLeft, height: riskHeight + 4 * padding)))
        
        let subtitleFont = UIFont.preferredFont(forTextStyle: .title2)
        hBox = 3 * (subtitleFont.ascender + subtitleFont.descender + subtitleFont.leading)
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: yTop, width: w, height: hBox))
        subtitleLabel.center = CGPoint(x: w/2, y: yTop + hBox/2)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .white
        subtitleLabel.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xFF00A79D)
        subtitleLabel.font = subtitleFont
        subtitleLabel.text = "Contribution from each predictor"
        self.predView.addSubview(subtitleLabel)
        yTop += hBox + padding
        
        self.predView.addSubview(PredMargin(frame: CGRect(x: 0, y: yTop - padding, width: marginLeft, height: padding)))
        
        for i in 0...varOrder.count - 1 {
            let v = varOrder[i]
            if let det = details[v] {
                let type = varTypes[i]
                let alias = varAlias[i]
                let value = det[0]
                let scaledContrib = det[2]
                let scaledRange = det[3]
//                print(alias + " " + String(value) + " " + String(format: "%\(0.1)f", value))
            
                let barY = yTop + varHeight/2 - barHeight/2;
                let predBar = PredBar(frame: CGRect(x: marginLeft, y: barY, width: barWidth, height: barHeight), value: scaledContrib, range: scaledRange, height: barHeight)
                self.predView.addSubview(predBar)
                
                var valueStr: String
                if type == ViewControllerPred.BINARY {
                    valueStr = binLabels[Int(value)]
                } else if type == ViewControllerPred.INT {
                    valueStr = String(Int(value))
                } else {
                    // https://stackoverflow.com/a/24055762
                    valueStr = String(format: "%\(0.1)f", value)
                }
                let contribLabel = UILabel(frame: CGRect(x: marginLeft + barWidth + colSpacing, y: barY, width: marginRight - colSpacing, height: barHeight))
                contribLabel.center = CGPoint(x: marginLeft + barWidth + (colSpacing + marginRight)/2, y: barY + barHeight/2)
                contribLabel.textAlignment = .left
                contribLabel.textColor = Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F)
                contribLabel.backgroundColor = .white
                contribLabel.font = bodyFont
                contribLabel.text = alias + " " + valueStr
                self.predView.addSubview(contribLabel)
                
                yTop += varHeight
                self.predView.addSubview(PredMargin(frame: CGRect(x: 0, y: yTop - varHeight, width: marginLeft, height: varHeight)))
            }
        }

        let h = yTop
        let heightConstraint = NSLayoutConstraint(item: self.predView,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.notAnAttribute,
                                                  multiplier: 1,
                                                  constant: CGFloat(h))
        
        self.view.addConstraint(heightConstraint)        
        self.view.layoutIfNeeded()
    }
    
    func drawPredGuide(model: LogRegModel, riskThreshold: Float, contribThreshold: Float) {
        let data = dataHolder.getCurrentData()
        let risk = model.eval(values: data)
        let details = model.evalDetails(values: data)

        var numContrib = 0
        for i in 0...varOrder.count - 1 {
            let type = varTypes[i]
            let v = varOrder[i]
            if let det = details[v] {
                let scaledContrib = det[2]
                let scaledRange = det[3]
                let coeff0 = det[4]
                let frac = scaledContrib/scaledRange;
                if contribThreshold < frac && (type != ViewControllerPred.BINARY || coeff0 > 0) {
                    numContrib += 1
                }
            }
        }
        
        let highRisk = riskThreshold <= risk
        let riskMsg = highRisk ?
            "Based on presentation signs, symptoms, and PCR data, this patient has more than \(Int(100 * riskThreshold))% chance of dying. Reassess for emergency clinical signs, monitor input and output by the bedside, and perform priority lab testing if possible."
            :
            "Based on presentation signs, symptoms, and PCR data, this patient has less than \(Int(100 * riskThreshold))% chance of dying. Make sure the patient remains stable, by keeping him or her hydrated and taking care of any clinical signs with the appropriate procedure.";

        let w = self.view.frame.width
        let margin = CGFloat(30)
        
        let titleFont = UIFont.preferredFont(forTextStyle: .headline)
        var hBox = 4 * (titleFont.ascender + titleFont.descender + titleFont.leading)
        var yTop = CGFloat(0)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: yTop, width: w, height: hBox))
        titleLabel.center = CGPoint(x: w/2, y: yTop + hBox/2)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.backgroundColor = highRisk ? Utils.UIColorFromRGB(rgbValue: 0xFFE34242) : Utils.UIColorFromRGB(rgbValue: 0xFFEAA147)
        titleLabel.font = titleFont
        titleLabel.text = highRisk ? "HIGH RISK PATIENT" : "LOW/MEDIUM RISK PATIENT"
        self.predView.addSubview(titleLabel)
        yTop += hBox + padding;
        
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        hBox = Utils.textHeight(Text: riskMsg, usingFont: bodyFont, constrainingWidth: w - 2 * margin)
        let msgLabel = UILabel(frame: CGRect(x: margin, y: yTop, width: w - 2 * margin, height: hBox))
        msgLabel.center = CGPoint(x: w/2, y: yTop + hBox/2)
        msgLabel.textAlignment = .center
        msgLabel.textColor = Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F)
        msgLabel.backgroundColor = .white
        msgLabel.numberOfLines = 0
        msgLabel.lineBreakMode = .byWordWrapping
        msgLabel.font = bodyFont
        msgLabel.text = riskMsg
        self.predView.addSubview(msgLabel)
        yTop += hBox + padding;
        
        if numContrib == 0 {
            return
        }
        
        let subtitleFont = UIFont.preferredFont(forTextStyle: .title2)
        hBox = 3 * (subtitleFont.ascender + subtitleFont.descender + subtitleFont.leading)
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: yTop, width: w, height: hBox))
        subtitleLabel.center = CGPoint(x: w/2, y: yTop + hBox/2)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .white
        subtitleLabel.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F)
        subtitleLabel.font = titleFont
        subtitleLabel.text = highRisk ? "This elevated risk is due to:" : "This risk is due to:"
        self.predView.addSubview(subtitleLabel)
        yTop += hBox + padding
        
        for i in 0...varOrder.count - 1 {
            let type = varTypes[i]
            let v = varOrder[i]
            if let det = details[v] {
//                let value = det[0]
                let scaledContrib = det[2]
                let scaledRange = det[3]
                let coeff0 = det[4]
                let frac = scaledContrib/scaledRange
                if contribThreshold < frac && (type != ViewControllerPred.BINARY || coeff0 > 0) {
                    let label = varSymptom[i]
                    let bx = margin2
                    let by = yTop + rowSpacing
                    let bw = w - 2 * margin2
                    let bh = varHeight - 2 * rowSpacing
                    
                    let button = PredButton(frame: CGRect(x: bx, y: by, width: bw, height: bh), rgbValue: highRisk ? 0xFFE34242 : 0xFFEAA147)
                    button.backgroundColor = .white
                    button.contentHorizontalAlignment = .left
                    button.setTitle(label, for: .normal)
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, textTab, 0, 0);
                    button.setTitleColor(Utils.UIColorFromRGB(rgbValue: 0xFF6F6F6F), for: .normal)
                    button.setTitleColor(Utils.UIColorFromRGB(rgbValue: 0xFFD6D6D6), for: .highlighted)
                    button.addTarget(self, action: #selector(ViewControllerPred.buttonAction(_:)), for: .touchUpInside)

                    yTop += varHeight
                    self.predView.addSubview(button)
                }
            }
        }
        
        let h = yTop
        let heightConstraint = NSLayoutConstraint(item: self.predView,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.notAnAttribute,
                                                  multiplier: 1,
                                                  constant: CGFloat(h))
        
        self.view.addConstraint(heightConstraint)
        self.view.layoutIfNeeded()
    }
    
    // MARK: events
    
    @objc func buttonAction(_ sender: UIButton!) {
        // How we figured this out:
        // https://digitalleaves.com/define-segues-programmatically/
        // 1. Create segues manually linking the pred view controller with each one of the symptom controllers
        // 2. Solve the relationship between buttons and segues below:
        if let title = sender.currentTitle, let segue = varSegues[title] {
          self.performSegue(withIdentifier: segue, sender: nil)
        }
    }

    func getMarginRight(risk : Float, details: [String:Array<Float>]) -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let riskStr = String(Int(risk * 100)) + "%";
        var margin = colSpacing + Utils.textWidth(Text: riskStr, usingFont: font) + colSpacing
        
        for i in 0...varOrder.count - 1 {
            let v = varOrder[i]
            if let det = details[v] {
                let type = varTypes[i]
                let alias = varAlias[i]
                let value = det[0]
                var valueStr: String
                if type == ViewControllerPred.BINARY {
                    valueStr = binLabels[Int(value)]
                } else if type == ViewControllerPred.INT {
                    valueStr = String(Int(value))
                } else {
                    // https://stackoverflow.com/a/24055762
                    valueStr = String(format: "%\(0.1)f", value)
                }
                let w = colSpacing + Utils.textWidth(Text: alias + " " + valueStr, usingFont: font) + colSpacing
                if margin < w {
                    margin = w
                }
            }
        }
        return margin
    }
}



