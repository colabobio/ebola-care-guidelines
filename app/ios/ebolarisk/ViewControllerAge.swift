//
//  ViewControllerAge.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/18/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerAge: ViewControllerTreatment {
    
    @IBOutlet weak var ageView: UIView!
    
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let ageText = "These patients are at increased risk. Follow very closely, reassessing for emergency clinical signs, making sure to avoid dehydration and maintaining electrolyte as well as blood pressure levels. Follow all procedures carefully, keeping doses within the corresponding age range."
    let hypoglycemiaText = "Although not commonly seen among adult patients, hypoglycemia may accompany dehydration and may result in seizures, coma and death. Small children, critically ill adults, and elderly or severely malnourished patients are especially at risk."
    let recomm1 = "  ◘ When hypoglycaemia is suspected, check glucose with bedside glucometer. Replete as needed."
    let recomm2 = "  ◘ Ampoules of D50 can be added to bags of Lactated Ringer\'s or Normal saline to provide some glucose."
    let recomm3 = "  ◘ If measurement is not possible, give glucose empirically if the patient develops lethargy, seizure or coma."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: ageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: "Children and elderly patients", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: ageText, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: "Hypoglycemia", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: hypoglycemiaText, left: xpos, top: ypos) +  itemSpacing        
        ypos += addTextParagraph(text: recomm1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recomm2, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recomm3, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
