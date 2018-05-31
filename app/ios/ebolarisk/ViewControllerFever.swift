//
//  ViewControllerFever.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/18/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerFever: ViewControllerTreatment  {

    // At the end I created the tables by hand using UIViews, but for programatically-generated tables using Table View Controller
    // the following video tutorial is useful:
    // https://www.youtube.com/watch?v=EVJiprvRLoo
    // https://stackoverflow.com/questions/37395560/ios-swift-programmatic-equivalent-of-android-tablelayout-tablerow
    
    @IBOutlet weak var feverView: UIView!

    let dataHolder = DataHolder.instance
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let feverTitle = NSLocalizedString("fever_title1", comment: "fever_title1")
    let feverText = NSLocalizedString("fever_parag1", comment: "fever_parag1")
    
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
    
    let malariaTitle = NSLocalizedString("fever_antimalarial_title", comment: "fever_antimalarial_title")
    let malariaText = NSLocalizedString("fever_antimalarial_parag", comment: "fever_antimalarial_parag")
    let asaqTitle = NSLocalizedString("fever_antimalarial_ASAQ_title", comment: "fever_antimalarial_ASAQ_title")
    let asaqText = NSLocalizedString("fever_antimalarial_ASAQ_dose", comment: "fever_antimalarial_ASAQ_dose")
    let asaqAges = [NSLocalizedString("fever_antimalarial_ASAQ_table_col1_row0", comment: "table_item"),
                    NSLocalizedString("fever_antimalarial_ASAQ_table_col1_row1", comment: "table_item"),
                    NSLocalizedString("fever_antimalarial_ASAQ_table_col1_row2", comment: "table_item"),
                    NSLocalizedString("fever_antimalarial_ASAQ_table_col1_row3", comment: "table_item"),
                    NSLocalizedString("fever_antimalarial_ASAQ_table_col1_row4", comment: "table_item")]
    let asaqDoses = [NSLocalizedString("fever_antimalarial_ASAQ_table_col2_row0", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_ASAQ_table_col2_row1", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_ASAQ_table_col2_row2", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_ASAQ_table_col2_row3", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_ASAQ_table_col2_row4", comment: "table_item")]
    let asaqWeights = [NSLocalizedString("fever_antimalarial_ASAQ_table_col3_row0", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_ASAQ_table_col3_row1", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_ASAQ_table_col3_row2", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_ASAQ_table_col3_row3", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_ASAQ_table_col3_row4", comment: "table_item")]
    
    let alTitle = NSLocalizedString("fever_antimalarial_AL_title", comment: "fever_antimalarial_AL_title")
    let alText = NSLocalizedString("fever_antimalarial_AL_dose", comment: "fever_antimalarial_AL_dose")
    let alAges = [NSLocalizedString("fever_antimalarial_AL_table_col1_row0", comment: "table_item"),
                  NSLocalizedString("fever_antimalarial_AL_table_col1_row1", comment: "table_item"),
                  NSLocalizedString("fever_antimalarial_AL_table_col1_row2", comment: "table_item"),
                  NSLocalizedString("fever_antimalarial_AL_table_col1_row3", comment: "table_item"),
                  NSLocalizedString("fever_antimalarial_AL_table_col1_row4", comment: "table_item")]
    let alDoses = [NSLocalizedString("fever_antimalarial_AL_table_col2_row0", comment: "table_item"),
                   NSLocalizedString("fever_antimalarial_AL_table_col2_row1", comment: "table_item"),
                   NSLocalizedString("fever_antimalarial_AL_table_col2_row2", comment: "table_item"),
                   NSLocalizedString("fever_antimalarial_AL_table_col2_row3", comment: "table_item"),
                   NSLocalizedString("fever_antimalarial_AL_table_col2_row4", comment: "table_item")]
    let alWeights = [NSLocalizedString("fever_antimalarial_AL_table_col3_row0", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_AL_table_col3_row1", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_AL_table_col3_row2", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_AL_table_col3_row3", comment: "table_item"),
                     NSLocalizedString("fever_antimalarial_AL_table_col3_row4", comment: "table_item")]

    let dhppqpTitle = NSLocalizedString("fever_antimalarial_DHPPQP_title", comment: "fever_antimalarial_DHPPQP_title")
    let dhppqpText = NSLocalizedString("fever_antimalarial_DHPPQP_dose", comment: "fever_antimalarial_DHPPQP_dose")
    let dhppqpWeights = [NSLocalizedString("fever_antimalarial_DHPPQP_table_col1_row0", comment: "table_item"),
                         NSLocalizedString("fever_antimalarial_DHPPQP_table_col1_row1", comment: "table_item"),
                         NSLocalizedString("fever_antimalarial_DHPPQP_table_col1_row2", comment: "table_item"),
                         NSLocalizedString("fever_antimalarial_DHPPQP_table_col1_row3", comment: "table_item"),
                         NSLocalizedString("fever_antimalarial_DHPPQP_table_col1_row4", comment: "table_item"),
                         NSLocalizedString("fever_antimalarial_DHPPQP_table_col1_row5", comment: "table_item"),
                         NSLocalizedString("fever_antimalarial_DHPPQP_table_col1_row6", comment: "table_item")]
    let dhppqpDoses = [NSLocalizedString("fever_antimalarial_DHPPQP_table_col2_row0", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_DHPPQP_table_col2_row1", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_DHPPQP_table_col2_row2", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_DHPPQP_table_col2_row3", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_DHPPQP_table_col2_row4", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_DHPPQP_table_col2_row5", comment: "table_item"),
                       NSLocalizedString("fever_antimalarial_DHPPQP_table_col2_row6", comment: "table_item")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: self.feverView)
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
        
        ypos += addMainTitle(title: feverTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: feverText, left: xpos, top: ypos) + itemSpacing
        var row = getParacetamolRow(ageYears: ageYears, ageMonths: ageMonths)
        ypos += create2ColumnTable(column1: paracetamolAges, column2: paracetamolDoses, selRow: row, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: malariaTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: malariaText, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: asaqTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: asaqText, left: xpos, top: ypos) + itemSpacing
        row = getASAQRow(ageYears: ageYears, ageMonths: ageMonths, weight: weight)
        ypos += create3ColumnDoubleEntryTable(column1: asaqAges, column2: asaqDoses, column3: asaqWeights, selRow: row, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: alTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: alText, left: xpos, top: ypos) + itemSpacing
        row = getALRow(ageYears: ageYears, ageMonths: ageMonths, weight: weight)
        ypos += create3ColumnDoubleEntryTable(column1: alAges, column2: alDoses, column3: alWeights, selRow: row, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: dhppqpTitle, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: dhppqpText, left: xpos, top: ypos) + itemSpacing
        row = getDHPPQPRow(weight: weight)
        ypos += create2ColumnTable(column1: dhppqpWeights, column2: dhppqpDoses, selRow: row, left: xpos, top: ypos) + itemSpacing

        return ypos
    }
    
    func getParacetamolRow(ageYears: Float, ageMonths: Float) -> Int {
        if 0 < ageMonths {
            if 6 <= ageMonths && ageMonths < 2 * 12 {
                return 1
            } else if 12 * 2 <= ageMonths && ageMonths < 12 * 6 {
                return 2
            } else if 12 * 6 <= ageMonths && ageMonths < 12 * 10 {
                return 3
            } else if 12 * 10 <= ageMonths && ageMonths < 12 * 16 {
                return 4
            } else if 12 * 16 <= ageMonths {
                return 5
            }
        } else if 0 < ageYears {
            if 0.5 <= ageYears && ageYears < 2 {
                return 1
            } else if 2 <= ageYears && ageYears < 6 {
                return 2
            } else if 6 <= ageYears && ageYears < 10 {
                return 3
            } else if 10 <= ageYears && ageYears < 16 {
                return 4
            } else if 16 <= ageYears {
                return 5
            }
        }
        return -1
    }
    
    func getASAQRow(ageYears: Float, ageMonths: Float, weight: Float) -> Int {
        if 0 < weight {
            if 5 <= weight && weight < 9 {
                return 1
            } else if 9 <= weight && weight < 19 {
                return 2
            } else if 19 <= weight && weight < 35 {
                return 3
            } else if 35 <= weight {
                return 4
            }
        } else if (0 < ageMonths) {
            if 2 <= ageMonths && ageMonths < 12 {
                return 1
            } else if 12 <= ageMonths && ageMonths < 12 * 6 {
                return 2
            } else if 12 * 6 <= ageMonths && ageMonths < 12 * 14 {
                return 3
            } else if 12 * 14 <= ageMonths {
                return 4
            }
        } else if (0 < ageYears) {
            if (1 <= ageYears && ageYears < 6) {
                return 2
            } else if (6 <= ageYears && ageYears < 14) {
                return 3
            } else if (14 <= ageYears) {
                return 4
            }
        }
        return -1
    }
    
    func getALRow(ageYears: Float, ageMonths: Float, weight: Float) -> Int {
        if 0 < weight {
            if (5 <= weight && weight < 15) {
                return 1
            } else if (15 <= weight && weight < 25) {
                return 2
            } else if (25 <= weight && weight < 35) {
                return 3
            } else if (35 <= weight) {
                return 4
            }
        } else if (0 < ageMonths) {
            if (2 <= ageMonths && ageMonths < 24) {
                return 1
            } else if (2 * 12 <= ageMonths && ageMonths < 12 * 8) {
                return 2
            } else if (12 * 8 <= ageMonths && ageMonths < 12 * 14) {
                return 3
            } else if (12 * 14 <= ageMonths) {
                return 4
            }
        } else if (0 < ageYears) {
            if (1 <= ageYears && ageYears < 2) {
                return 1
            } else if (2 <= ageYears && ageYears < 8) {
                return 2
            } else if (8 <= ageYears && ageYears < 14) {
                return 3
            } else if (14 <= ageYears) {
                return 4
            }
        }
        return -1
    }
    
    func getDHPPQPRow(weight: Float) -> Int {
        if (0 < weight) {
            if (11 <= weight && weight < 17) {
                return 1
            } else if (17 <= weight && weight < 25) {
                return 2
            } else if (25 <= weight && weight < 36) {
                return 3
            } else if (36 <= weight && weight < 60) {
                return 4
            } else if (60 <= weight && weight < 80) {
                return 5
            } else {
                return 6
            }
        }
        return -1
    }
}
