//
//  TabController.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/24/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openSettings(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
    }
}
