//: Playground - noun: a place where people can play

import UIKit

let urlString = "https://www.familymoviesapp.com/familymember/dylan/?q=hello&hello=world"
let url = URL(string: urlString)!

let scheme = url.scheme
let host = url.host
let pathComponents = url.pathComponents
print(pathComponents)

print(url.query)

extension URL {
    var queryDict: [String: String]? {
        guard let pairs = query?.components(separatedBy: "&")
            else { return nil }
        
        var dict = [String: String]()
        
        for pair in pairs {
            let components = pair.components(separatedBy: "=")
            dict[components[0]] = components[1]
        }
        
        return dict
    }
}

SecRequestSharedWebCredential(nil, nil) { credentialsArray, error in
    guard let credentials = credentialsArray as? [AnyObject],
        let credentialEntry = credentials.first
        else { return }
    
    let userName = credentialEntry[kSecAttrAccount as String]
    let password = credentialEntry[kSecSharedPassword as String]
    
    // log in with fetched credentials
}

SecAddSharedWebCredential("www.familymoviesapp.com" as CFString,
                          "TheUser" as CFString,
                          "ThePassword" as CFString?) { error in
                            
                            // handle errors if desired
}

