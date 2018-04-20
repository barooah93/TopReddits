//
//  FavoriteEntrySingleton.swift
//  freeza
//
//  Created by Brandon Barooah on 4/19/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import UIKit

// I'm creating a singleton here to keep independence of the TopEntriesVC and FavoriteEntriesVC
class FavoriteEntrySingleton: NSObject {
    
    static let sharedInstance = FavoriteEntrySingleton()

    private var favoriteEntries = [EntryViewModel]()
    
    func getFavoriteEntries () -> [EntryViewModel] {
        return favoriteEntries
    }
    
    func setFavoriteEntries(entries: [EntryViewModel]) {
        self.favoriteEntries = entries
    }
    
    func addFavorite(entry: EntryViewModel) {
        self.favoriteEntries.append(entry)
    }
    
    func removeFavorite(byId id:String?){
        guard let id = id, id != "" else {return}
        self.favoriteEntries = self.favoriteEntries.filter {$0.id != id}
    }
    
    func addOrRemoveFavorite(_ entry:EntryViewModel){
        if self.favoriteEntries.contains(where: {$0.id == entry.id}) {
            self.removeFavorite(byId: entry.id)
        } else {
            self.addFavorite(entry: entry)
        }
    }
}
