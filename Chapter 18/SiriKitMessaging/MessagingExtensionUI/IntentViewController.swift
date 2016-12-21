//
//  IntentViewController.swift
//  MessagingExtensionUI
//
//  Created by Donny Wals on 08/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling, INUIHostedViewSiriProviding {
    
    @IBOutlet var recipientGroupLabel: UILabel!
    @IBOutlet var messageContentLabel: UILabel!
    
    var displaysMessage = true
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configure(with interaction: INInteraction!, context: INUIHostedViewContext, completion: ((CGSize) -> Void)!) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        
        guard let messageIntent = interaction.intent as? INSendMessageIntent
            else { return }
        
        recipientGroupLabel.text = messageIntent.groupName
        messageContentLabel.text = messageIntent.content
        
        let viewWidth = extensionContext?.hostedViewMaximumAllowedSize.width ?? 0
        completion(CGSize(width: viewWidth, height: 100))
    }
}
