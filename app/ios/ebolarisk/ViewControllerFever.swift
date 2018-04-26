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
    
    let feverText = "Treat with oral administration of Paracetamol (dose by weight is 15 mg/kg):"
    let malariaText = "All patients presenting to the emergency center with fever should also be given malaria treatment with Artesunate plus amodiaquine (AS+AQ) OR Artemether-lumefantrine (AL) OR Dihydroartemisinin plus piperaquine (DHP+PQP)."
    
    let paracetamolAges = ["Patient age", "6-24 months", "3-5 years", "6-9 years", "10-15 years", "Adult"]
    let paracetamolDoses = ["Paracetamol dose", "100 mg every 4-6 hours", "200 mg every 4-6 hours", "300 mg every 4-6 hours", "500 mg every 4-6 hours", "1000 mg every 4-6 hours"]
    
    let asaqText = "Fixed dose combination (50 mg + 153 mg/tablet)."
    let asaqAges = ["Patient age", "2-11 months", "1-5 years", "6-13 years", "≥14 years"]
    let asaqDoses = ["Daily dose", "1/2 tablet for 3 days", "1 tablet for 3 days", "2 tablets for 3 days", "2 tablets for 3 days"]
    let asaqWeights = ["Patient weight", "5-9 kg", "9-18 kg", "19-35 kg", "≥35 kg"]
    
    let alText = "Fixed dose combination (20+ 120 mg/tablet)."
    let alAges = ["Patient age", "2-24 months", "25 months - 7 years", "8-13 years", "≥14 years"]
    let alDoses = ["Daily dose", "1 tablet twice for 3 days", "2 tablets twice for 3 days", "3 tablets twice for 3 days", "4 tablets twice for 3 days"]
    let alWeights = ["Patient weight", "5-15 kg", "15-25 kg", "26-35 kg", "≥35 kg"]

    let dhppqpText = "Fixed dose combination (40 mg + 320 mg/tablet)."
    let dhppqpWeights = ["Patient weight", "11-16 kg", "17-24 kg", "25-35 kg", "36-59 kg", "60-79 kg", "≥80 kg"]
    let dhppqpDoses = ["Daily dose", "1 tablet for 3 days", "1.5 tablets for 3 days", "2 tablets for 3 days", "3 tablets for 3 days", "4 tablets for 3 days", "5 tablets for 3 days"]
    
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
        
        ypos += addMainTitle(title: "Fever/headache", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: feverText, left: xpos, top: ypos) + itemSpacing
        var row = getParacetamolRow(ageYears: ageYears, ageMonths: ageMonths)
        ypos += create2ColumnTable(column1: paracetamolAges, column2: paracetamolDoses, selRow: row, left: xpos, top: ypos) + 2 * itemSpacing
        
        ypos += addMainTitle(title: "Malaria treatment", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: malariaText, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: "Artesunate plus amodiaquine (AS+AQ)", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: asaqText, left: xpos, top: ypos) + itemSpacing
        row = getASAQRow(ageYears: ageYears, ageMonths: ageMonths, weight: weight)
        ypos += create3ColumnDoubleEntryTable(column1: asaqAges, column2: asaqDoses, column3: asaqWeights, selRow: row, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: "Artemether-lumefantrine (AL)", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: alText, left: xpos, top: ypos) + itemSpacing
        row = getALRow(ageYears: ageYears, ageMonths: ageMonths, weight: weight)
        ypos += create3ColumnDoubleEntryTable(column1: alAges, column2: alDoses, column3: alWeights, selRow: row, left: xpos, top: ypos) + itemSpacing
        
        ypos += addSubTitle(title: "Dihydroartemisinin plus piperaquine (DHP+PQP)", left: xpos, top: ypos) + itemSpacing
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
