//
//  ViewControllerHeadache.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerHeadache: ViewControllerTreatment {

    @IBOutlet weak var headacheView: UIView!
    
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let paraText = "Treat with oral administration of Paracetamol (dose by weight is 15 mg/kg):"
    let paraAges = ["Patient age", "6 months–2 years", "3–5 years", "6–9 years", "10–15 years", "Adult"]
    let paraDose = ["Paracetamol dose", "100 mg every 4–6 hours", "200 mg every 4–6 hours", "300 mg every 4–6 hours", "500 mg every 4–6 hours", "1000 mg every 4–6 hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: headacheView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: "Fever/headache", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: paraText, left: xpos, top: ypos) + itemSpacing
        ypos += create2ColumnTable(column1: paraAges, column2: paraDose, selRow: -1, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
