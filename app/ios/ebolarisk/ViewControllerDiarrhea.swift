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
    
    let dehydraText = "Patient is at risk of dehydration, the most frequent and important cause of further deterioration. The WHO Oral Rehydration Solution (ORS) is best suited for treating dehydration."
    
    let orsAges = ["Patient age", "Less than 4 months", "4-11 months", "12-23 months", "2-4 years", "5-15 years", "15 years and older"]
    let orsAmount = ["ORS amount", "200-400 ml", "400-600 ml", "600-800 ml", "800-1200 ml", "1200-2200 ml", "2200-2400 ml"]
    let orsWeights = ["Patient weight", "Less than 5 kg", "5-7.9 kg", "8-10.9 kg", "11-15.9 kg", "16-29.9 kg", "30 kg or more"]
    
    let orsText1 = "◘ Reassess the patient’s condition after four hours, and provide more ORS as detailed above if dehydration persists."
    let orsText2 = "◘ If a patient (child or adult) has no diarrhoea or dehydration, and finds it difficult to drink ORS, use flavoured ORS."
    let orsText3 = "◘ Do not use sports drinks, or sugary drinks such as fruit flavoured and fizzy commercial drinks, as they can worsen diarrhoea."
    
    let zincText = "Give the patient Zinc sulphate, especially children:"
    let zincAges = ["Patient age", "Under 6 months", "Over 6 months"]
    let zincAmount = ["Zinc dose", "10 mg per day for 10-14 days", "20 mg per day for 10-14 days"]

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
        
        ypos += addMainTitle(title: "Diarrhoea and dehydration", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: dehydraText, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: "ORS amount to be given in first 4 hours", left: xpos, top: ypos) + itemSpacing
        var row = getOSRow(ageYears: ageYears, ageMonths: ageMonths, weight: weight)
        ypos += create3ColumnDoubleEntryTable(column1: orsAges, column2: orsAmount, column3: orsWeights, selRow: row, left: xpos, top: ypos) + itemSpacing

        ypos += addTextParagraph(text: orsText1, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText2, left: xpos, top: ypos) + itemSpacing/2
        ypos += addTextParagraph(text: orsText3, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: "Zinc treatment", left: xpos, top: ypos) + itemSpacing
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
