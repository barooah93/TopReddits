//
//  FavoriteEntrySingletonTests.swift
//  freezaTests
//
//  Created by Brandon Barooah on 4/21/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import XCTest
@testable import freeza

class FavoriteEntrySingletonTests: XCTestCase {
    
    let id = "TEST_ID"
    let title = "TEST_TITLE"
    let author = "TEST_AUTHOR"
    let creation = NSDate()
    let thumbnailURL = URL(string: "http://mysite.com/thumb.jpg")!
    let commentsCount = 200
    let nsfw = 1
    
    var entries = [EntryViewModel]()
    
    override func setUp() {
        super.setUp()
        
          let dictionary  = [
                "id": id as AnyObject,
                "title": title as AnyObject,
                "author": author as AnyObject,
                "created_utc": creation.timeIntervalSince1970 as AnyObject,
                "thumbnail": thumbnailURL.absoluteString as AnyObject,
                "num_comments": commentsCount as AnyObject,
                "over_18": nsfw as AnyObject
        ]
        
        let entryModel = EntryModel(withDictionary: dictionary)
        let entryViewModel = EntryViewModel(withModel: entryModel)
        entries.append(entryViewModel)
    }
    
    func testSettingAndRemovingFavoriteEntries() {
        
        FavoriteEntrySingleton.sharedInstance.setFavoriteEntries(entries: entries)
        let retrievedEntries = FavoriteEntrySingleton.sharedInstance.getFavoriteEntries()
        
        XCTAssertTrue(retrievedEntries.count == 1)
        XCTAssertEqual(retrievedEntries.first?.id, entries.first?.id)
        
        FavoriteEntrySingleton.sharedInstance.removeFavorite(byId: entries.first?.id)
        
        XCTAssertTrue(FavoriteEntrySingleton.sharedInstance.getFavoriteEntries().count == 0)
        
    }
    
    func testAddingAndRemovingFavoriteEntry() {
        
        FavoriteEntrySingleton.sharedInstance.addFavorite(entry: entries.first!)
        let retrievedEntries = FavoriteEntrySingleton.sharedInstance.getFavoriteEntries()
        
        XCTAssertEqual(retrievedEntries.count, 1)
        XCTAssertEqual(retrievedEntries.first?.id, entries.first?.id)
        
        FavoriteEntrySingleton.sharedInstance.removeFavorite(byId: entries.first?.id)
        
        XCTAssertTrue(FavoriteEntrySingleton.sharedInstance.getFavoriteEntries().count == 0)
    }
    
    func testAddingOrRemovingFavoriteEntry() {
        
        // First call should add entry
        FavoriteEntrySingleton.sharedInstance.addOrRemoveFavorite(entries.first!)
        let retrievedEntries = FavoriteEntrySingleton.sharedInstance.getFavoriteEntries()
        
        XCTAssertEqual(retrievedEntries.count, 1)
        XCTAssertEqual(retrievedEntries.first?.id, entries.first?.id)
        
        FavoriteEntrySingleton.sharedInstance.addOrRemoveFavorite(entries.first!)
        
        XCTAssertTrue(FavoriteEntrySingleton.sharedInstance.getFavoriteEntries().count == 0)
    }
    
    
}
