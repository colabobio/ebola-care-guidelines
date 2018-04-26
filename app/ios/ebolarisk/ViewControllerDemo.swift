//
//  FirstViewController.swift
//  ebolarisk
//
//  Created by Andres Colubri on 3/30/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerDemo: UIViewController, UITextFieldDelegate {

    let dataHolder = DataHolder.instance
    
    // How to handle TextFields inside ScrollViews
    // It is very important that the equal height/width constraints are set between the
    // view containing the text fields and the scroll view so the keyboard is handled properly
    // https://medium.com/rocknnull/ios-working-with-uiscrollview-uitextview-and-auto-layout-afa39fe2cac8
    // ... and scrolling when opening the keyboard so the fields are not occluded by it
    // https://medium.com/@dzungnguyen.hcm/autolayout-for-scrollview-keyboard-handling-in-ios-5a47d73fd023
    // https://stackoverflow.com/a/40249707 (works very nicely)
    
    // MARK: Properties
    @IBOutlet weak var yearsField: UITextField!
    @IBOutlet weak var monthsField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var theScrollView: UIScrollView!
    
    @IBOutlet weak var riskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        // Increase the text size in the tab items:
        let attrsNormal = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attrsNormal, for: .normal)
        
        registerSettingsBundle()
        
        // https://stackoverflow.com/questions/37770456/how-to-make-uibutton-a-circle
        // https://freakycoder.com/ios-notes-11-how-to-create-a-circle-button-with-shadow-9a9c902a3a56
        riskButton.layer.shadowColor = UIColor.black.cgColor
        riskButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        riskButton.layer.shadowRadius = 1.2
        riskButton.layer.shadowOpacity = 0.3
        riskButton.layer.masksToBounds = false
        riskButton.layer.cornerRadius = riskButton.frame.width / 2
        
        yearsField.delegate = self
        monthsField.delegate = self
        weightField.delegate = self
        self.addDoneToolbarOnNumpad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        setDebugData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerSettingsBundle() {
        let appDefaults: [String: Any] = ["show_treatments": true, "highrisk_threshold": 0.4, "min_predcontrib":0.1]
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    // MARK: Events
    
    // http://www.danieledonzelli.com/ios/uitextfield-tutorial/
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == weightField {
          textField.keyboardType = UIKeyboardType.decimalPad
        } else {
          textField.keyboardType = UIKeyboardType.numberPad
        }
        return true
    }

    // Numerical pad does not have a done button
    // https://stackoverflow.com/questions/28338981/how-to-add-done-button-to-numpad-in-ios-8-using-swift
    // https://gist.github.com/jplazcano87/8b5d3bc89c3578e45c3e
    func addDoneToolbarOnNumpad() {
        self.yearsField.inputAccessoryView = createDoneToolbar(selector: #selector(doneYearsAction))
        self.monthsField.inputAccessoryView = createDoneToolbar(selector: #selector(doneMonthsAction))
        self.weightField.inputAccessoryView = createDoneToolbar(selector: #selector(doneWeightAction))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let sval = textField.text {
            if let fval = Float(sval.trimmingCharacters(in: .whitespacesAndNewlines)) {
                if textField == yearsField {
                    dataHolder.setData(varName: "PatientAge", value: fval)
                } else if textField == monthsField {
                    dataHolder.setDataExtra(varName: "PatientAgeMonths", value: fval)
                    if !fval.isNaN {
                        dataHolder.setData(varName: "PatientAge", value: fval/12)
                    }
                } else if textField == weightField {
                    dataHolder.setDataExtra(varName: "PatientWeight", value: fval)
                }
            }
        }
    }
    
    func createDoneToolbar(selector: Selector?) -> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 320, height: 50)))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: selector)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }
    
    @objc func doneYearsAction() {
        self.yearsField.resignFirstResponder()
        self.monthsField.becomeFirstResponder()
    }
    
    @objc func doneMonthsAction() {
        self.monthsField.resignFirstResponder()
        self.weightField.becomeFirstResponder()
    }
    
    @objc func doneWeightAction() {
        self.weightField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.theScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        theScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        theScrollView.contentInset = contentInset
    }
    
    func setDebugData() {
        // Debugging values
        dataHolder.setData(varName: "PatientAge", value: 50)
        dataHolder.setDataExtra(varName: "PatientWeight", value: 65)
        
        dataHolder.setData(varName: "cycletime", value: 25)
        
        dataHolder.setData(varName: "FeverTemperature", value: 39)
        
        dataHolder.setData(varName: "Diarrhoea", value: true)
        dataHolder.setData(varName: "AstheniaWeakness", value: true)
        dataHolder.setData(varName: "Jaundice", value: true)
        dataHolder.setData(varName: "Bleeding", value: true)
        dataHolder.setData(varName: "Headache", value: true)
        dataHolder.setData(varName: "Vomit", value: true)
        dataHolder.setData(varName: "AbdominalPain", value: true)
    }
}

