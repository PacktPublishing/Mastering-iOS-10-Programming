//
//  TodayViewController.swift
//  The Daily Quote Widget
//
//  Created by Donny Wals on 21-09-16.
//  Copyright © 2016 Donny Wals. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var quoteCreator: UILabel!
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        let currentText = quoteLabel.text
        updateWidget()
        let newText = quoteLabel.text
        
        if currentText == newText {
            completionHandler(NCUpdateResult.noData)
        } else {
            completionHandler(NCUpdateResult.newData)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWidget()
    }

    func updateWidget() {
        let quote = Quote.current
        quoteLabel.text = quote.text
        quoteCreator.text = quote.creator
    }
    
}
