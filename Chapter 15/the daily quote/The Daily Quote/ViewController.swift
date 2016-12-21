//
//  ViewController.swift
//  The Daily Quote
//
//  Created by Donny Wals on 20-09-16.
//  Copyright © 2016 Donny Wals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var quoteCreator: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quote = Quote.current
        quoteLabel.text = quote.text
        quoteCreator.text = quote.creator
    }
    
    
    
}

