//
//  ViewControllerBleed.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerBleed: ViewControllerTreatment {

    @IBOutlet weak var bleedView: UIView!
    
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let bleedingText = "Transfusion of fresh whole blood or red blood cell components should be considered, guided by clinical and ideally laboratory indicators:"
    let clinical1 = "  ◘ severe pallor"
    let clinical2 = "  ◘ fast pulse rate"
    let clinical3 = "  ◘ difficult breathing"
    let clinical4 = "  ◘ confusion"
    let clinical5 = "  ◘ restlessness"
    
    let lab1 = "  ◘ Hgb ≤ 5 g/dl"
    let lab2 = "  ◘ hematocrit ≤ 15"
    let lab3 = "  ◘ INR ≥ 1.2"
    
    let vitaminKText1 = "Many malnourished or ill patients with diminished oral intake, and those treated with antibiotics, have mild vitamin K deficiency which may lead to elevations in INR/PPT and predispose to bleeding."
    let vitaminKText2 = "Many malnourished or ill patients with diminished oral intake, and those treated with antibiotics, have mild vitamin K deficiency which may lead to elevations in INR/PPT and predispose to bleeding."
    
    let additionalText = "Other medications to prevent or treat bleeding such as antifibrinolytics (IV tranexamic acid) may be reasonable based on extrapolation of evidence from other patient populations but direct evidence in patients with Ebola is lacking."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: bleedView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: "Bleeding", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: bleedingText, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addSubTitle(title: "Clinical indicators", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical2, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical3, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical4, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical5, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addSubTitle(title: "Laboratory indicators", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: lab1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: lab2, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: lab3, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: "Vitamin K deficiency", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vitaminKText1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vitaminKText2, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: "Additional treatment", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: additionalText, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
