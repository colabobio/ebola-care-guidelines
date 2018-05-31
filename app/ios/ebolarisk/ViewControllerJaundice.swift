//
//  ViewControllerJaundice.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerJaundice: ViewControllerTreatment {

    @IBOutlet weak var jaundiceView: UIView!
    
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let jaundiceTitle = NSLocalizedString("jaundice_title1", comment: "jaundice_title1")
    let jaundiceText = NSLocalizedString("jaundice_parag1", comment: "jaundice_parag1")
    
    let nutritionTitle = NSLocalizedString("jaundice_title2", comment: "jaundice_title2")
    let nutritionText = NSLocalizedString("jaundice_parag2", comment: "jaundice_parag2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: jaundiceView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: jaundiceTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: jaundiceText, left: xpos, top: ypos) + 2 * itemSpacing

        ypos += addMainTitle(title: nutritionTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: nutritionText, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
