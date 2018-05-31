//
//  ViewControllerDiarrhea.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerDiarrhea: ViewControllerTreatment {

    @IBOutlet weak var diarrheaView: UIView!
    
    let dataHolder = DataHolder.instance
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let dehyraTitle = NSLocalizedString("diarr_title1", comment: "diarr_title1")
    let dehydraText = NSLocalizedString("diarr_parag1", comment: "diarr_parag1")
    
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
    
    let zincTitle = NSLocalizedString("diarr_zinc_title", comment: "diarr_zinc_title")
    let zincText = NSLocalizedString("diarr_zinc_parag", comment: "diarr_zinc_parag")
    let zincAges = [NSLocalizedString("diarr_zinc_table_col1_row0", comment: "table_item"),
                    NSLocalizedString("diarr_zinc_table_col1_row1", comment: "table_item"),
                    NSLocalizedString("diarr_zinc_table_col1_row2", comment: "table_item")]
    let zincAmount = [NSLocalizedString("diarr_zinc_table_col1_row0", comment: "table_item"),
                      NSLocalizedString("diarr_zinc_table_col1_row1", comment: "table_item"),
                      NSLocalizedString("diarr_zinc_table_col1_row2", comment: "table_item")]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: diarrheaView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let data = dataHolder.getCurrentData()
        let extra = dataHolder.getExtraData()
        var ageYears = Float(0)
        var ageMonths = Float(0)
        var weight = Float(0)
        if let years = data["PatientAge"] {
            ageYears = years
        }
        if let months = data["PatientAgeMonths"] {
            ageMonths = months
        }
        if let kg = extra["PatientWeight"] {
            weight = kg
        }
        
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: dehyraTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: dehydraText, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: orsTitle, left: xpos, top: ypos) + itemSpacing
        var row = getOSRow(ageYears: ageYears, ageMonths: ageMonths, weight: weight)
        ypos += create3ColumnDoubleEntryTable(column1: orsAges, column2: orsAmount, column3: orsWeights, selRow: row, left: xpos, top: ypos) + itemSpacing

        ypos += addTextParagraph(text: orsText1, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText2, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText3, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: zincTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: zincText, left: xpos, top: ypos) + itemSpacing
        row = getZincRow(ageYears: ageYears, ageMonths: ageYears)
        ypos += create2ColumnTable(column1: zincAges, column2: zincAmount, selRow: row, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
    
    func getOSRow(ageYears: Float, ageMonths: Float, weight: Float) -> Int {
        if 0 < weight {
            if weight < 5 {
                return 1
            } else if 5 <= weight && weight < 8 {
                return 2
            } else if 8 <= weight && weight < 11 {
                return 3
            } else if 11 <= weight && weight < 16 {
                return 4
            } else if 16 <= weight && weight < 30 {
                return 5
            } else {
                return 6
            }
        } else if 0 < ageMonths {
            if ageMonths < 4 {
                return 1
            } else if 4 <= ageMonths && ageMonths < 12 {
                return 2
            } else if 12 <= ageMonths && ageMonths < 24 {
                return 3
            } else if 12 * 2 <= ageMonths && ageMonths < 12 * 5 {
                return 4
            } else if 12 * 5 <= ageMonths && ageMonths < 12 * 16 {
                return 5
            } else {
                return 6
            }
        } else if 0 < ageYears {
            if 1 <= ageYears && ageYears < 2 {
                return 3
            } else if 2 <= ageYears && ageYears < 5 {
                return 4
            } else if 5 <= ageYears && ageYears < 16 {
                return 5
            } else if 16 <= ageYears {
                return 6
            }
        }
        return -1
    }
    
    func getZincRow(ageYears: Float, ageMonths: Float) -> Int {
        if 0 < ageMonths {
            if ageMonths <= 6 {
                return 1
            } else {
                return 2
            }
        } else if 0 < ageYears {
            return 2
        }
        return -1
    }
}
