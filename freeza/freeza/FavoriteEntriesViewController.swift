//
//  FavoriteEntriesViewController.swift
//  freeza
//
//  Created by Brandon Barooah on 4/19/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import UIKit

class FavoriteEntriesViewController: UITableViewController {

    static let showImageSegueIdentifier = "showImageSegue"

    var viewModel = FavoriteEntriesViewModel()
    var urlToDisplay: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.configureViews()
        self.loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload views every time we come back to the screen
        self.loadFavorites()
    }
    
    // Function to handle when segue is about to occur
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Make sure the identifier matches the one we expect to happen
        if segue.identifier == FavoriteEntriesViewController.showImageSegueIdentifier {
            
            if let urlViewController = segue.destination as? URLViewController {
                
                urlViewController.url = self.urlToDisplay
            }
        }
    }
    
    func configureViews(){
        
        func configureTableView() {
            // Configure tableview for dynamic cell heights
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 110.0
            self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of extra lines below at bottom of table
        }
        
        configureTableView()
    }
    
    func loadFavorites() {
        // Loads data, and reloads table for updates
        self.viewModel.getFavorites {
            self.tableView.reloadData()
        }
    }

}

extension FavoriteEntriesViewController { // Tableview datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favoriteTableViewCell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.cellId, for: indexPath as IndexPath) as! FavoriteTableViewCell
        
        // Set cell data, and assign self as its delegate for message passing
        favoriteTableViewCell.entry = self.viewModel.favorites[indexPath.row]
        favoriteTableViewCell.delegate = self
        
        return favoriteTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.urlToDisplay = self.viewModel.favorites[indexPath.row].url
        self.performSegue(withIdentifier: FavoriteEntriesViewController.showImageSegueIdentifier, sender: self)
    }
    
}

extension FavoriteEntriesViewController : EntryTableViewCellDelegate {
    // Called when thumbnail is pressed on cell
    func presentImage(withURL url: URL) {
        self.urlToDisplay = url
        self.performSegue(withIdentifier: FavoriteEntriesViewController.showImageSegueIdentifier, sender: self)
    }
}
