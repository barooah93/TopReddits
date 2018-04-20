//
//  UserPreferencesSingleton.swift
//  freeza
//
//  Created by Brandon Barooah on 4/20/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import UIKit

class UserPreferencesSingleton: NSObject {
    
    static var safeContentKey = "safeContentPreference"
    
    static func getSafeContentPreference() -> Bool {
        return UserDefaults.standard.bool(forKey: safeContentKey)
    }
    
    static func setSafeContentPreference(flag: Bool) {
        return UserDefaults.standard.set(flag, forKey: safeContentKey)
    }
    
    static func inverseSafeContentPreference() -> Bool{
        let flag = UserDefaults.standard.bool(forKey: safeContentKey)
        UserDefaults.standard.set(!flag, forKey: safeContentKey)
        return !flag
    }
    
}
