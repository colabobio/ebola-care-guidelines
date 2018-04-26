//
//  SecondViewController.swift
//  ebolarisk
//
//  Created by Andres Colubri on 3/30/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class ViewControllerVitals: UIViewController, UITextFieldDelegate {

    let dataHolder = DataHolder.instance
    
    // MARK: Properties
    @IBOutlet weak var tempField: UITextField!
    @IBOutlet weak var riskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        riskButton.layer.shadowColor = UIColor.black.cgColor
        riskButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        riskButton.layer.shadowRadius = 1.2
        riskButton.layer.shadowOpacity = 0.3
        riskButton.layer.masksToBounds = false
        riskButton.layer.cornerRadius = riskButton.frame.width / 2
        
        self.tempField.delegate = self
        addDoneToolbarOnNumpad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Events

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.keyboardType = UIKeyboardType.decimalPad
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let sval = textField.text {
            if let fval = Float(sval.trimmingCharacters(in: .whitespacesAndNewlines)) {
                dataHolder.setData(varName: "FeverTemperature", value: fval)
            }
        }
    }

    func addDoneToolbarOnNumpad() {
        self.tempField.inputAccessoryView = createDoneToolbar(selector: #selector(doneTempAction))
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

    @objc func doneTempAction() {
        self.tempField.resignFirstResponder()
    }
}

