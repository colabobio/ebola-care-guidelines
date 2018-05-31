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
    
    let bleedingTitle = NSLocalizedString("bleed_title1", comment: "bleed_title1")
    let bleedingText = NSLocalizedString("bleed_parag1", comment: "bleed_parag1")
    
    let clinicalTitle = NSLocalizedString("bleed_clinical_title", comment: "bleed_clinical_title")
    let clinical1 = NSLocalizedString("bleed_clinical_item1", comment: "bleed_clinical_item1")
    let clinical2 = NSLocalizedString("bleed_clinical_item2", comment: "bleed_clinical_item2")
    let clinical3 = NSLocalizedString("bleed_clinical_item3", comment: "bleed_clinical_item3")
    let clinical4 = NSLocalizedString("bleed_clinical_item4", comment: "bleed_clinical_item4")
    let clinical5 = NSLocalizedString("bleed_clinical_item5", comment: "bleed_clinical_item5")
    
    let labTitle = NSLocalizedString("bleed_lab_title", comment: "bleed_lab_title")
    let lab1 = NSLocalizedString("bleed_lab_item1", comment: "bleed_lab_item1")
    let lab2 = NSLocalizedString("bleed_lab_item2", comment: "bleed_lab_item2")
    let lab3 = NSLocalizedString("bleed_lab_item3", comment: "bleed_lab_item3")
    
    let vitaminKTitle = NSLocalizedString("bleed_vitk_title", comment: "bleed_vitk_title")
    let vitaminKText1 = NSLocalizedString("bleed_vitk_parag1", comment: "bleed_vitk_parag1")
    let vitaminKText2 = NSLocalizedString("bleed_vitk_parag2", comment: "bleed_vitk_parag2")
    
    let additionalTitle = NSLocalizedString("bleed_add_title", comment: "bleed_add_title")
    let additionalText = NSLocalizedString("bleed_add_parag", comment: "bleed_add_parag")
    
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
        
        ypos += addMainTitle(title: bleedingTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: bleedingText, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addSubTitle(title: clinicalTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical2, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical3, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical4, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: clinical5, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addSubTitle(title: labTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: lab1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: lab2, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: lab3, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: vitaminKTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vitaminKText1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vitaminKText2, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: additionalTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: additionalText, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
