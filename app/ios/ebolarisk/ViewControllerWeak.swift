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
    
    let weaknessText = "The weakness and lethargy accompanying diarrhoea; or with significant vomiting, as well as confusion, sunken eyes, wrinkled skin and a weak pulse, are indication of severe dehydration. Patient should be immediately started on active intravenous (IV) fluid resuscitation while also offered Oral Rehydration Solution (ORS)."
    
    let ivfluidText = "Give 100 ml/kg Lactated Ringer’s solution (or, if LR not available, normal saline), divided as follows:"
    
    let ivfluidAges = ["Patient age", "Infants (under 12 months)", "Older (12 months or older, including adults)"]
    let ivfluidFirst = ["First give 30 ml/kg in:", "1 hour (*)", "30 minutes (*)"]
    let ivfluidSecond = ["Then give 70 ml/kg in:", "5 hours (*)", "2 and 1/2 hour"]
    let ivfluidFootnote = "* Repeat once if radial pulse is very weak or not detectable."
    
    let recoveryText1 = "◘ Reassess the patient every 1–2 hours."
    let recoveryText2 = "◘ If hydration status is not improving, give the IV drip more rapidly."
    let recoveryText3 = "◘ Give ORS (about 5 ml/kg/hour) as soon as the patient can drink, usually after 3– 4 hours (infant) or 1–2 hours for children, adolescents, and adults."
    let recoveryText4 = "◘ Reassess an infant for 6 hours and older patient after 3 hours. Classify dehydration. Then choose the appropriate plan to continue treatment."
    
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
        
        ypos += addMainTitle(title: "Weakness and severe dehydration", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: weaknessText, left: xpos, top: ypos) + itemSpacing
        ypos += addSubTitle(title: "IV fluid resuscitation", left: xpos, top: ypos) + itemSpacing
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
