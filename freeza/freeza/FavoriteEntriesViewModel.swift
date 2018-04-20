//
//  FavoriteEntriesViewModel.swift
//  freeza
//
//  Created by Brandon Barooah on 4/19/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import UIKit

class FavoriteEntriesViewModel: NSObject {

    var favorites = [EntryViewModel]()
    
    // Gets favorite entries from the singleton
    func getFavorites(completionHandler: @escaping ()->()){
        self.favorites = FavoriteEntrySingleton.sharedInstance.getFavoriteEntries()
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}
