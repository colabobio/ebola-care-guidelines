//
//  ThirdViewController.swift
//  ebolarisk
//
//  Created by Andres Colubri on 3/30/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerClinical: UIViewController, BEMCheckBoxDelegate {

    let dataHolder = DataHolder.instance
    
    // Radio boxes from:
    // https://github.com/Boris-Em/BEMCheckBox
    var diarrhoeaGroup: BEMCheckBoxGroup?
    @IBOutlet weak var diarrhoeaYes: BEMCheckBox!
    @IBOutlet weak var diarrhoeaNo: BEMCheckBox!
    @IBOutlet weak var diarrhoeaDontknow: BEMCheckBox!
    
    var weaknessGroup: BEMCheckBoxGroup?
    @IBOutlet weak var weaknessYes: BEMCheckBox!
    @IBOutlet weak var weaknessNo: BEMCheckBox!
    @IBOutlet weak var weaknessDontknow: BEMCheckBox!
    
    var jaundiceGroup: BEMCheckBoxGroup?
    @IBOutlet weak var jaundiceYes: BEMCheckBox!
    @IBOutlet weak var jaundiceNo: BEMCheckBox!
    @IBOutlet weak var jaundiceDontknow: BEMCheckBox!
    
    var bleedingGroup: BEMCheckBoxGroup?
    @IBOutlet weak var bleedingYes: BEMCheckBox!
    @IBOutlet weak var bleedingNo: BEMCheckBox!
    @IBOutlet weak var bleedingDontknow: BEMCheckBox!
    
    var headacheGroup: BEMCheckBoxGroup?
    @IBOutlet weak var headacheYes: BEMCheckBox!
    @IBOutlet weak var headacheNo: BEMCheckBox!
    @IBOutlet weak var headacheDontknow: BEMCheckBox!
    
    var vomitingGroup: BEMCheckBoxGroup?
    @IBOutlet weak var vomitingYes: BEMCheckBox!
    @IBOutlet weak var vomitingNo: BEMCheckBox!
    @IBOutlet weak var vomitingDontknow: BEMCheckBox!
    
    var painGroup: BEMCheckBoxGroup?
    @IBOutlet weak var painYes: BEMCheckBox!
    @IBOutlet weak var painNo: BEMCheckBox!
    @IBOutlet weak var painDontknow: BEMCheckBox!
    
    @IBOutlet weak var riskButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        riskButton.layer.shadowColor = UIColor.black.cgColor
        riskButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        riskButton.layer.shadowRadius = 1.2
        riskButton.layer.shadowOpacity = 0.3
        riskButton.layer.masksToBounds = false
        riskButton.layer.cornerRadius = riskButton.frame.width / 2

        self.diarrhoeaGroup = BEMCheckBoxGroup(checkBoxes: [self.diarrhoeaYes, self.diarrhoeaNo, self.diarrhoeaDontknow])
        self.diarrhoeaGroup?.selectedCheckBox = self.diarrhoeaDontknow;
        self.diarrhoeaGroup?.mustHaveSelection = true
        
        self.weaknessGroup = BEMCheckBoxGroup(checkBoxes: [self.weaknessYes, self.weaknessNo, self.weaknessDontknow])
        self.weaknessGroup?.selectedCheckBox = self.weaknessDontknow;
        self.weaknessGroup?.mustHaveSelection = true

        self.jaundiceGroup = BEMCheckBoxGroup(checkBoxes: [self.jaundiceYes, self.jaundiceNo, self.jaundiceDontknow])
        self.jaundiceGroup?.selectedCheckBox = self.jaundiceDontknow;
        self.jaundiceGroup?.mustHaveSelection = true
        
        self.bleedingGroup = BEMCheckBoxGroup(checkBoxes: [self.bleedingYes, self.bleedingNo, self.bleedingDontknow])
        self.bleedingGroup?.selectedCheckBox = self.bleedingDontknow;
        self.bleedingGroup?.mustHaveSelection = true

        self.headacheGroup = BEMCheckBoxGroup(checkBoxes: [self.headacheYes, self.headacheNo, self.headacheDontknow])
        self.headacheGroup?.selectedCheckBox = self.headacheDontknow;
        self.headacheGroup?.mustHaveSelection = true
        
        self.vomitingGroup = BEMCheckBoxGroup(checkBoxes: [self.vomitingYes, self.vomitingNo, self.vomitingDontknow])
        self.vomitingGroup?.selectedCheckBox = self.vomitingDontknow;
        self.vomitingGroup?.mustHaveSelection = true
        
        self.painGroup = BEMCheckBoxGroup(checkBoxes: [self.painYes, self.painNo, self.painDontknow])
        self.painGroup?.selectedCheckBox = self.painDontknow;
        self.painGroup?.mustHaveSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: properties

    @IBAction func tapDiarrhoeaYes(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Diarrhoea", value: true)
    }
    
    @IBAction func tapDiarrhoeaNo(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Diarrhoea", value: false)
    }
    
    @IBAction func tapDiarrhoeaDontknow(_ sender: BEMCheckBox) {
        dataHolder.remData(varName: "Diarrhoea")
    }
    
    @IBAction func tapWeaknessYes(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "AstheniaWeakness", value: true)
    }
    
    @IBAction func tapWeaknessNo(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "AstheniaWeakness", value: false)
    }
    
    @IBAction func tapWeaknessDontknow(_ sender: BEMCheckBox) {
        dataHolder.remData(varName: "AstheniaWeakness")
    }
    
    @IBAction func tapJaundiceYes(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Jaundice", value: true)
    }
    
    @IBAction func tapJaundiceNo(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Jaundice", value: false)
    }
    
    @IBAction func tapJaundiceDontknow(_ sender: BEMCheckBox) {
        dataHolder.remData(varName: "Jaundice")
    }
    
    @IBAction func tapBleedingYes(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Bleeding", value: true)
    }
    
    @IBAction func tapBleedingNo(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Bleeding", value: false)
    }
    
    @IBAction func tapBleedingDontknow(_ sender: BEMCheckBox) {
        dataHolder.remData(varName: "Bleeding")
    }
    
    @IBAction func tapHeadacheYes(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Headache", value: true)
    }
    
    @IBAction func tapHeadacheNo(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Headache", value: false)
    }
    
    @IBAction func tapHeadacheDontknow(_ sender: BEMCheckBox) {
        dataHolder.remData(varName: "Headache")
    }
    
    @IBAction func tapVomitingYes(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Vomit", value: true)
    }
    
    @IBAction func tapVomitingNo(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "Vomit", value: false)
    }
    
    @IBAction func tapVomitingDontknow(_ sender: BEMCheckBox) {
        dataHolder.remData(varName: "Vomit")
    }
    
    @IBAction func tapPainYes(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "AbdominalPain", value: true)
    }
    
    @IBAction func tapPainNo(_ sender: BEMCheckBox) {
        dataHolder.setData(varName: "AbdominalPain", value: false)
    }
    
    @IBAction func tapPainDontknow(_ sender: BEMCheckBox) {
        dataHolder.remData(varName: "AbdominalPain")
    }
}
