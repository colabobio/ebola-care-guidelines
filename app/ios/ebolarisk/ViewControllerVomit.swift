//
//  ViewControllerVomit.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerVomit: ViewControllerTreatment {

    @IBOutlet weak var vomitView: UIView!
    
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let vomitTitle = NSLocalizedString("vomit_title1", comment: "vomit_title1")
    let vomitText = NSLocalizedString("vomit_parag1", comment: "vomit_parag1")
    let ondanAges = [NSLocalizedString("vomit_ondansetron_table_col1_row0", comment: "table_item"),
                     NSLocalizedString("vomit_ondansetron_table_col1_row1", comment: "table_item"),
                     NSLocalizedString("vomit_ondansetron_table_col1_row2", comment: "table_item")]
    let ondanDose = [NSLocalizedString("vomit_ondansetron_table_col2_row0", comment: "table_item"),
                     NSLocalizedString("vomit_ondansetron_table_col2_row1", comment: "table_item"),
                     NSLocalizedString("vomit_ondansetron_table_col2_row2", comment: "table_item")]

    let dehydraTitle = NSLocalizedString("vomit_dehydration_title", comment: "vomit_dehydration_title")
    let dehydraText = NSLocalizedString("vomit_dehydration_parag", comment: "vomit_dehydration_parag")
    
    let orsTitle = NSLocalizedString("diarr_ors_table_title", comment: "diarr_ors_table_title")
    
    let orsAges = [NSLocalizedString("diarr_ors_table_col1_row0", comment: "table_item"),
                   NSLocalizedString("diarr_ors_table_col1_row1", comment: "table_item"),
                   NSLocalizedString("diarr_ors_table_col1_row2", comment: "table_item"),
                   NSLocalizedString("diarr_ors_table_col1_row3", comment: "table_item"),
                   NSLocalizedString("diarr_ors_table_col1_row4", comment: "table_item"),
                   NSLocalizedString("diarr_ors_table_col1_row5", comment: "table_item"),
                   NSLocalizedString("diarr_ors_table_col1_row6", comment: "table_item")]
    let orsAmount = [NSLocalizedString("diarr_ors_table_col2_row0", comment: "table_item"),
                     NSLocalizedString("diarr_ors_table_col2_row1", comment: "table_item"),
                     NSLocalizedString("diarr_ors_table_col2_row2", comment: "table_item"),
                     NSLocalizedString("diarr_ors_table_col2_row3", comment: "table_item"),
                     NSLocalizedString("diarr_ors_table_col2_row4", comment: "table_item"),
                     NSLocalizedString("diarr_ors_table_col2_row5", comment: "table_item"),
                     NSLocalizedString("diarr_ors_table_col2_row6", comment: "table_item")]
    let orsWeights = [NSLocalizedString("diarr_ors_table_col3_row0", comment: "table_item"),
                      NSLocalizedString("diarr_ors_table_col3_row1", comment: "table_item"),
                      NSLocalizedString("diarr_ors_table_col3_row2", comment: "table_item"),
                      NSLocalizedString("diarr_ors_table_col3_row3", comment: "table_item"),
                      NSLocalizedString("diarr_ors_table_col3_row4", comment: "table_item"),
                      NSLocalizedString("diarr_ors_table_col3_row5", comment: "table_item"),
                      NSLocalizedString("diarr_ors_table_col3_row6", comment: "table_item")]
    
    let orsText1 = NSLocalizedString("diarr_note1", comment: "diarr_note1")
    let orsText2 = NSLocalizedString("diarr_note2", comment: "diarr_note2")
    let orsText3 = NSLocalizedString("diarr_note3", comment: "diarr_note3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: vomitView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: vomitTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vomitText, left: xpos, top: ypos) + itemSpacing
        ypos += create2ColumnTable(column1: ondanAges, column2: ondanDose, selRow: -1, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: dehydraTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: dehydraText, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: orsTitle, left: xpos, top: ypos) + itemSpacing
        ypos += create3ColumnDoubleEntryTable(column1: orsAges, column2: orsAmount, column3: orsWeights, selRow: -1, left: xpos, top: ypos) + itemSpacing
        
        ypos += addTextParagraph(text: orsText1, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText2, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText3, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
