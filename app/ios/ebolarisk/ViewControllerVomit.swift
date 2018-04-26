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
    
    let vomitText = "Nausea and vomiting can be managed with Ondansetron:"
    let ondanAges = ["Patient age", "4-12 years", "Adult"]
    let ondanDose = ["Daily dose", "4 mg two times a day", "8 mg two times a day"]

    let dehydraText = "Patient is at risk of dehydration, the most frequent and important cause of further deterioration. The WHO Oral Rehydration Solution (ORS) is best suited for treating dehydration."
    
    let orsAges = ["Patient age", "Less than 4 months", "4-11 months", "12-23 months", "2-4 years", "5-15 years", "15 years and older"]
    let orsAmount = ["ORS amount", "200-400 ml", "400-600 ml", "600-800 ml", "800-1200 ml", "1200-2200 ml", "2200-2400 ml"]
    let orsWeights = ["Patient weight", "Less than 5 kg", "5-7.9 kg", "8-10.9 kg", "11-15.9 kg", "16-29.9 kg", "30 kg or more"]
    
    let orsText1 = "◘ Reassess the patient’s condition after four hours, and provide more ORS as detailed above if dehydration persists."
    let orsText2 = "◘ If a patient (child or adult) has no diarrhoea or dehydration, and finds it difficult to drink ORS, use flavoured ORS."
    let orsText3 = "◘ Do not use sports drinks, or sugary drinks such as fruit flavoured and fizzy commercial drinks, as they can worsen diarrhoea."
    
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
        
        ypos += addMainTitle(title: "Nausea and Vomiting", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vomitText, left: xpos, top: ypos) + itemSpacing
        ypos += create2ColumnTable(column1: ondanAges, column2: ondanDose, selRow: -1, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: "Dehydration", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: dehydraText, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: "ORS amount to be given in first 4 hours", left: xpos, top: ypos) + itemSpacing
        ypos += create3ColumnDoubleEntryTable(column1: orsAges, column2: orsAmount, column3: orsWeights, selRow: -1, left: xpos, top: ypos) + itemSpacing
        
        ypos += addTextParagraph(text: orsText1, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText2, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText3, left: xpos, top: ypos) + itemSpacing
        
        return ypos
    }
}
