//
//  CompactViewController.swift
//  The Daily Quote
//
//  Created by Donny Wals on 01/10/2016.
//  Copyright © 2016 Donny Wals. All rights reserved.
//

import UIKit

class CompactViewController: UIViewController {
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var creatorLabel: UILabel!
    
    var delegate: QuoteSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quote = Quote.current
        
        quoteLabel.text = quote.text
        creatorLabel.text = quote.creator
    }
    
    @IBAction func shareTapped() {
        delegate?.shareQuote(Quote.current)
    }
}
