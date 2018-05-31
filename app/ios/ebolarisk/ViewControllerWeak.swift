//
//  ViewControllerWeak.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerWeak: ViewControllerTreatment {

    @IBOutlet weak var weakView: UIView!
    
    let dataHolder = DataHolder.instance
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let weaknessTitle = NSLocalizedString("weak_title1", comment: "weak_title1")
    let weaknessText = NSLocalizedString("weak_parag1", comment: "weak_parag1")
    
    let ivfluidTitle = NSLocalizedString("weak_iv_title", comment: "weak_iv_title")
    let ivfluidText = NSLocalizedString("weak_iv_parag", comment: "weak_iv_parag")
    
    let ivfluidAges = [NSLocalizedString("weak_iv_table_col1_row0", comment: "table_item"),
                       NSLocalizedString("weak_iv_table_col1_row1", comment: "table_item"),
                       NSLocalizedString("weak_iv_table_col1_row2", comment: "diarr_title1")]
    let ivfluidFirst = [NSLocalizedString("weak_iv_table_col2_row0", comment: "table_item"),
                        NSLocalizedString("weak_iv_table_col2_row1", comment: "table_item"),
                        NSLocalizedString("weak_iv_table_col2_row2", comment: "table_item")]
    let ivfluidSecond = [NSLocalizedString("weak_iv_table_col3_row0", comment: "table_item"),
                         NSLocalizedString("weak_iv_table_col3_row1", comment: "table_item"),
                         NSLocalizedString("weak_iv_table_col3_row2", comment: "table_item")]
    let ivfluidFootnote = NSLocalizedString("weak_iv_table_footnote", comment: "weak_iv_table_footnote")
    
    let recoveryText1 = NSLocalizedString("weak_iv_note1", comment: "weak_iv_note1")
    let recoveryText2 = NSLocalizedString("weak_iv_note2", comment: "weak_iv_note2")
    let recoveryText3 = NSLocalizedString("weak_iv_note3", comment: "weak_iv_note3")
    let recoveryText4 = NSLocalizedString("weak_iv_note4", comment: "weak_iv_note4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: weakView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let data = dataHolder.getCurrentData()
        var ageYears = Float(0)
        var ageMonths = Float(0)
        if let years = data["PatientAge"] {
            ageYears = years
        }
        if let months = data["PatientAgeMonths"] {
            ageMonths = months
        }
        
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: weaknessTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: weaknessText, left: xpos, top: ypos) + itemSpacing
        ypos += addSubTitle(title: ivfluidTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: ivfluidText, left: xpos, top: ypos) + itemSpacing
        let row = getIVFluidRow(ageYears: ageYears, ageMonths: ageMonths)
        ypos += create3ColumnTable(column1: ivfluidAges, column2: ivfluidFirst, column3: ivfluidSecond, selRow: row, left: xpos, top: ypos) + itemSpacing/2
        ypos += addFootNote(text: ivfluidFootnote, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recoveryText1, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recoveryText2, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recoveryText3, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: recoveryText4, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
    
    func getIVFluidRow(ageYears: Float, ageMonths: Float) -> Int {
        if 0 < ageMonths {
            if ageMonths <= 1 {
                return 1
            } else {
                return 2
            }
        } else if 0 < ageYears {
            if ageYears < 1 {
                return 1
            } else {
                return 2
            }
        }
        return -1
    }
}
