//
//  ViewControllerVLoad.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerVLoad: ViewControllerTreatment {

    @IBOutlet weak var vloadView: UIView!
    
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let vloadTitle = NSLocalizedString("vload_title1", comment: "vload_title1")
    let vloadText = NSLocalizedString("vload_intro", comment: "vload_intro")
    
    let vloadCheck1 = NSLocalizedString("vload_list_item1", comment: "vload_list_item1")
    let vloadCheck2 = NSLocalizedString("vload_list_item2", comment: "vload_list_item2")
    let vloadCheck3 = NSLocalizedString("vload_list_item3", comment: "vload_list_item3")
    let vloadCheck3a = NSLocalizedString("vload_list_item3a", comment: "vload_list_item3a")
    let vloadCheck3b = NSLocalizedString("vload_list_item3b", comment: "vload_list_item3b")
    let vloadCheck3c = NSLocalizedString("vload_list_item3c", comment: "vload_list_item3c")
    let vloadCheck3d = NSLocalizedString("vload_list_item3d", comment: "vload_list_item3d")
    let vloadCheck3e = NSLocalizedString("vload_list_item3e", comment: "vload_list_item3e")
    let vloadCheck4 = NSLocalizedString("vload_list_item4", comment: "vload_list_item4")
    let vloadCheck4a = NSLocalizedString("vload_list_item4a", comment: "vload_list_item4a")
    let vloadCheck4b = NSLocalizedString("vload_list_item4b", comment: "vload_list_item4b")
    let vloadCheck4c = NSLocalizedString("vload_list_item4c", comment: "vload_list_item4c")
    let vloadCheck4d = NSLocalizedString("vload_list_item4d", comment: "vload_list_item4d")
    
    let shockTitle = NSLocalizedString("vload_shock_title", comment: "vload_shock_title")
    let shockText1 = NSLocalizedString("vload_shock_list_item1", comment: "vload_shock_list_item1")
    let signsText1 = NSLocalizedString("vload_shock_list_item1a", comment: "vload_shock_list_item1a")
    let signsText2 = NSLocalizedString("vload_shock_list_item1b", comment: "vload_shock_list_item1b")
    let signsText3 = NSLocalizedString("vload_shock_list_item1c", comment: "vload_shock_list_item1c")
    let signsText4 = NSLocalizedString("vload_shock_list_item1d", comment: "vload_shock_list_item1d")
    let signsText5 = NSLocalizedString("vload_shock_list_item1e", comment: "vload_shock_list_item1e")
    let signsText6 = NSLocalizedString("vload_shock_list_item1f", comment: "vload_shock_list_item1f")
    let signsText7 = NSLocalizedString("vload_shock_list_item1g", comment: "vload_shock_list_item1g")
    let signsText8 = NSLocalizedString("vload_shock_list_item1h", comment: "vload_shock_list_item1h")
    let shockText2 = NSLocalizedString("vload_shock_list_item2", comment: "vload_shock_list_item2")
    let shockText3 = NSLocalizedString("vload_shock_list_item3", comment: "vload_shock_list_item3")
    
    let respTitle = NSLocalizedString("vload_breath_title", comment: "vload_breath_title")
    let respText = NSLocalizedString("vload_breath_parag", comment: "vload_breath_parag")
    
    let anxietyTitle = NSLocalizedString("vload_anxiety_title", comment: "vload_anxiety_title")
    let anxietyText = NSLocalizedString("vload_anxiety_parag", comment: "vload_anxiety_parag")
    
    let confusionTitle = NSLocalizedString("vload_confusion_coop_title", comment: "vload_confusion_coop_title")
    let confusionText = NSLocalizedString("vload_confusion_coop_parag", comment: "vload_confusion_coop_parag")
    
    let agresionTitle = NSLocalizedString("vload_agit_noncoop_title", comment: "vload_agit_noncoop_title")
    let agressionText = NSLocalizedString("vload_agit_noncoop_parag", comment: "vload_agit_noncoop_parag")
    
    let neurologicalTitle = NSLocalizedString("vload_neuro_title", comment: "vload_neuro_title")
    let neurologicalText = NSLocalizedString("vload_neuro_parag", comment: "vload_neuro_parag")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: vloadView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: vloadTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vloadText, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vloadCheck1, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck2, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3a, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3b, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3c, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3d, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3e, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4a, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4b, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4c, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4d, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: shockTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: shockText1, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText1, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText2, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText3, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText4, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText5, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText6, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText7, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText8, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: shockText2, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: shockText3, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: respTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: respText, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: anxietyTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: anxietyText, left: xpos, top: ypos) + 2 *  itemSpacing
        
        ypos += addMainTitle(title: confusionTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: confusionText, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: agresionTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: agressionText, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: neurologicalTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: neurologicalText, left: xpos, top: ypos) +  itemSpacing
        
        return ypos
    }

}
