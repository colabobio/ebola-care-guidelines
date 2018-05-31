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

    let painTitle = NSLocalizedString("pain_title1", comment: "pain_title1")
    let painText = NSLocalizedString("pain_parag1", comment: "pain_parag1")
    let omepraAges = [NSLocalizedString("vomit_omeprazole_table_col1_row0", comment: "table_item"),
                      NSLocalizedString("vomit_omeprazole_table_col1_row1", comment: "table_item"),
                      NSLocalizedString("vomit_omeprazole_table_col1_row2", comment: "table_item"),
                      NSLocalizedString("vomit_omeprazole_table_col1_row3", comment: "table_item")]
    let omepraDose = [NSLocalizedString("vomit_omeprazole_table_col2_row0", comment: "table_item"),
                      NSLocalizedString("vomit_omeprazole_table_col2_row1", comment: "table_item"),
                      NSLocalizedString("vomit_omeprazole_table_col2_row2", comment: "table_item"),
                      NSLocalizedString("vomit_omeprazole_table_col2_row3", comment: "table_item")]
    
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
        
        ypos += addMainTitle(title: painTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: painText, left: xpos, top: ypos) + itemSpacing
        ypos += create2ColumnTable(column1: omepraAges, column2: omepraDose, selRow: -1, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
