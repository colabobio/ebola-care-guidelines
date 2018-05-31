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
    
    let paraTitle = "Fever/headache"
    let paraText = "Treat with oral administration of Paracetamol (dose by weight is 15 mg/kg):"
    let paracetamolAges = [NSLocalizedString("fever_para_table_col1_row0", comment: "table_item"),
                           NSLocalizedString("fever_para_table_col1_row1", comment: "table_item"),
                           NSLocalizedString("fever_para_table_col1_row2", comment: "table_item"),
                           NSLocalizedString("fever_para_table_col1_row3", comment: "table_item"),
                           NSLocalizedString("fever_para_table_col1_row4", comment: "table_item"),
                           NSLocalizedString("fever_para_table_col1_row5", comment: "table_item")]
    let paracetamolDoses = [NSLocalizedString("fever_para_table_col2_row0", comment: "table_item"),
                            NSLocalizedString("fever_para_table_col2_row1", comment: "table_item"),
                            NSLocalizedString("fever_para_table_col2_row2", comment: "table_item"),
                            NSLocalizedString("fever_para_table_col2_row3", comment: "table_item"),
                            NSLocalizedString("fever_para_table_col2_row4", comment: "table_item"),
                            NSLocalizedString("fever_para_table_col2_row5", comment: "table_item")]
    
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
        
        ypos += addMainTitle(title: paraTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: paraText, left: xpos, top: ypos) + itemSpacing
        ypos += create2ColumnTable(column1: paracetamolAges, column2: paracetamolDoses, selRow: -1, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
