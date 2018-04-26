//
//  ViewControllerPain.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerPain: ViewControllerTreatment {

    @IBOutlet weak var painView: UIView!

    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)

    let painText = "Treat with oral administration of Omeprazole, once a day before food:"
    let omepraAges = ["Patient age", "6 months–2 years", "2–12 years", "Adult"]
    let omepraDose = ["Omeprazole dose", "10 mg", "10 mg", "20 mg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: painView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: "Abdominal/epigastric pain", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: painText, left: xpos, top: ypos) + itemSpacing
        ypos += create2ColumnTable(column1: omepraAges, column2: omepraDose, selRow: -1, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
