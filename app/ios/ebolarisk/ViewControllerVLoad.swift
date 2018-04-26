//
//  ViewControllerVLoad.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/22/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerVLoad: ViewControllerTreatment {

    @IBOutlet weak var vloadView: UIView!
    
    let itemSpacing = CGFloat(8)
    let margin = CGFloat(8)
    
    let vloadText = "High viral load is the most direct indication of a severe case. It is important to regularly:"
    
    let vloadCheck1 = "◘ Reassess for emergency clinical signs and use the Ebola-simplified Quick Check or another triage/severity score and the ETAT for children."
    let vloadCheck2 = "◘ Monitor input and output (when possible) and record at the bedside. When impractical to document separately (in several buckets), the total volume of urine, vomit and stool collected in a bedside bucket may be qualitatively or quantitatively estimated based on volume measures marked on the outside of the bucket."
    let vloadCheck3 = "◘ Priority lab testing for ill patients:"
    let vloadCheck3a = "   ○ electrolytes- K, Na, HCO3"
    let vloadCheck3b = "   ○ glucose"
    let vloadCheck3c = "   ○ creatinine"
    let vloadCheck3d = "   ○ lactate"
    let vloadCheck3e = "   ○ for women of childbearing age: pregnancy test"
    let vloadCheck4 = "◘ Second priority:"
    let vloadCheck4a = "   ○ magnesium"
    let vloadCheck4b = "   ○ haemoglobin or hematocrit"
    let vloadCheck4c = "   ○ platelet count"
    let vloadCheck4d = "   ○ INR and PTT"
    
    let shockText1 = "◘ General signs of shock (poor perfusion):"
    let signsText1 = "   ○ Fast, weak pulse"
    let signsText2 = "   ○ Pallor or cold extremities"
    let signsText3 = "   ○ Prolonged capillary refill (>3 seconds)"
    let signsText4 = "   ○ Dizziness or inability to stand"
    let signsText5 = "   ○ Decreased urine output (≤30 ml/hour)"
    let signsText6 = "   ○ Difficulty breathing"
    let signsText7 = "   ○ Impaired consciousness, lethargy, agitation, confusion"
    let signsText8 = "   ○ Low BP (SBP≤90 in adults; check SBP by age/weight of child)"
    let shockText2 = "◘ Call for help from the most experienced clinician available when an Ebola patient develops shock."
    let shockText3 = "◘ EVD patients can be in shock from hypovolaemic from GI loss (most common in the 2014- 2015 outbreak), septic shock or haemorrhagic shock (uncommon) or a combination of these."
    
    let respText = "Oxygen: titrate to Sp02≥90%. If SpO2<90%, start adult on 5 litres/minute (nasal prongs); start child at 1–2 litres/minute (nasal prongs). In the acute phase of shock (first 24 hours) in children, where there is impaired oxygen delivery, also give oxygen if SpO2<94%. Evaluate for pneumonia, wheezing, fluid overload, congestive heart failure and manage accordingly. (Do not share nasal prongs–dispose of them once used by a patient.)"
    let anxietyText = "Provide psychological support. Depression, associated with feelings of hopelessness and/or suicidal thoughts, may be present. See section 10.11 (Mental health problems) in the IMAI District Clinician Manual for their management. Diazepam – adults: 5–15 mg/day in 3 divided doses may be considered in severe cases."
    let confusionText = "Reason with the patient in a calm and non-aggressive fashion. Keep lights on at night. Consider diazepam 5 mg at night (adult)."
    let agressionText = "Give sedation: haloperidol 2.5 to 5 mg IM (depending on size of adult). Approach patient with caution, call for assistance, and give treatment only if safe to do so."
    let neurologicalText = "This includes peripheral neuropathy, cranial nerve palsies, encephalopathy, aphonia, cardiac failure. Consider thiamine deficiency (beriberi) and give vitamin B1: 50 mg IM or IV daily for several days."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(container: vloadView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createLayout() -> CGFloat {
        let xpos = margin
        var ypos = itemSpacing
        
        ypos += addMainTitle(title: "High viral load and severely ill patients", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vloadText, left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: vloadCheck1, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck2, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3a, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3b, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3c, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3d, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck3e, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4a, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4b, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4c, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: vloadCheck4d, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: "Shock", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: shockText1, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText1, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText2, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText3, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText4, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText5, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText6, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText7, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: signsText8, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: shockText2, left: xpos, top: ypos) +  itemSpacing
        ypos += addTextParagraph(text: shockText3, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: "Difficulty breathing/respiratory distress", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: respText, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: "Anxiety", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: anxietyText, left: xpos, top: ypos) + 2 *  itemSpacing
        
        ypos += addMainTitle(title: "Confusion in cooperative patient", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: confusionText, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: "Agitation, confusion and aggression in non-cooperative adult patient", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: agressionText, left: xpos, top: ypos) +  2 * itemSpacing
        
        ypos += addMainTitle(title: "Unexplained neurological symptoms", left: xpos, top: ypos) + itemSpacing
        ypos += addTextParagraph(text: neurologicalText, left: xpos, top: ypos) +  itemSpacing
        
        return ypos
    }

}
