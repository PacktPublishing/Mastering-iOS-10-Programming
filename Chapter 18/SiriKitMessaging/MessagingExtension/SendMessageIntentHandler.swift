//
//  SendMessageIntentHandler.swift
//  SiriKitMessaging
//
//  Created by Donny Wals on 09/10/2016.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import Intents

class SendMessageIntentHandler: NSObject, INSendMessageIntentHandling {
    
    let supportedGroups = ["neighbors", "coworkers", "developers"]
    
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        /*
         * Actual implementation for classes below is missing. Included solely to illustrate how to implement this method.
        guard let groupName = intent.groupName,
            let message = intent.content else {
                
                completion(INSendMessageIntentResponse(code: .failure, userActivity: nil))
        }
        
        MessagingApi.sendMessage(message, toGroup: groupName) { success in
            if success {
                completion(INSendMessageIntentResponse(code: .success, userActivity: nil)
            } else {
                completion(INSendMessageIntentResponse(code: .failure, userActivity: nil)
            }
        }
        */
        
        // Used so Siri will think we sent the message
        completion(INSendMessageIntentResponse(code: .success, userActivity: nil))
    }
    
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        /*
        * Commented out to indicate missing implementations for User and MessagingApi
        * Included as an example of possible confirmation steps
 
        guard let user = User.current(), user.isLoggedIn else {
            completion(INSendMessageIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil))
            return
        }
        
        guard MessagingApi.isAvailable else {
            completion(INSendMessageIntentResponse(code: .failureMessageServiceNotAvailable, userActivity: nil))
            return
        }
        */
        
        completion(INSendMessageIntentResponse(code: .ready, userActivity: nil))
    }

    func resolveGroupName(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        
        guard let givenGroupName = intent.groupName else {
            completion(.needsValue())
            return
        }
        
        let matchingGroups = supportedGroups.filter{ group in
            return group.contains(givenGroupName.lowercased())
        }
        
        switch matchingGroups.count {
        case 0:
            completion(.needsValue())
        case 1:
            completion(.success(with: matchingGroups.first!))
        default:
            completion(.disambiguation(with: matchingGroups))
        }
    }
}
