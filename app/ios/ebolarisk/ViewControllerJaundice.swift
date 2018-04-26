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
    
    let jaundiceText = "Jaundice is not common in EVD, but it likely indicates an acute case with damage to the parenchymal cells of liver. Confirm Hepatic/hepatocellular jaundice by urine tests (dark urine, presence of conjugated bilirubin, urobilirubin > 2 units). Follow up closely and apply appropriate treatment for other signs/symptoms."
    
    let nutritionText = "Exercise caution when feeding the patient who have no appetite. Even in critically ill patients without severe dehydration, excess energy or protein is not needed and an excess could further compromise liver and kidney function."
    
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
        
        ypos += addMainTitle(title: "Jaundice and liver damage", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: jaundiceText, left: xpos, top: ypos) + 2 * itemSpacing

        ypos += addMainTitle(title: "Nutrition recommendations", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: nutritionText, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
