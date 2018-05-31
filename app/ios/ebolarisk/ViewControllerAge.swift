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
    
    let ageTitle = NSLocalizedString("age_title1", comment: "age_title1")
    let ageText = NSLocalizedString("age_parag1", comment: "age_parag1")
    let hypoglycemiaTitle = NSLocalizedString("age_title2", comment: "age_title2")
    let hypoglycemiaText = NSLocalizedString("age_parag2", comment: "age_parag2")
    let recomm1 = NSLocalizedString("age_item1", comment: "age_item1")
    let recomm2 = NSLocalizedString("age_item2", comment: "age_item2")
    let recomm3 = NSLocalizedString("age_item3", comment: "age_item3")
    
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
        
        ypos += addMainTitle(title: ageTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: ageText, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: hypoglycemiaTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: hypoglycemiaText, left: xpos, top: ypos) +  itemSpacing        
        ypos += addTextParagraph(text: recomm1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recomm2, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recomm3, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
