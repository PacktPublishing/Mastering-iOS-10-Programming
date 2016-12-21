//
//  ViewController.swift
//  SiriKitMessaging
//
//  Created by Donny Wals on 08/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        INPreferences.requestSiriAuthorization { status in
            print(status)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

