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

    var viewModel = TopEntriesViewModel()
    var urlToDisplay: URL?
    var safeContentButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set proper text for safe content bar button item
        let newFlag = UserPreferencesSingleton.getSafeContentPreference()
        self.safeContentButtonItem?.title = newFlag ? "Safe" : "NSFW"
        
        // Reload views every time we come back to the screen
        self.tableView.reloadData()
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
        
        func configureNavBar() {
            let safeText = UserPreferencesSingleton.getSafeContentPreference() ? "Safe" : "NSFW"
            self.safeContentButtonItem = UIBarButtonItem(title: safeText, style: .plain, target: self, action: #selector(safeContentBarButtonSelected))
            
            self.navigationItem.rightBarButtonItem = safeContentButtonItem!
        }
        
        func configureTableView() {
            // Configure tableview for dynamic cell heights
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 110.0
            self.tableView.tableFooterView = UIView(frame: CGRect.zero) // Get rid of extra lines below at bottom of table
        }
        
        configureNavBar()
        configureTableView()
    }
    
    @objc private func safeContentBarButtonSelected(){
        let newFlag = UserPreferencesSingleton.inverseSafeContentPreference()
        
        self.safeContentButtonItem?.title = newFlag ? "Safe" : "NSFW"
    }

}

extension FavoriteEntriesViewController { // Tableview datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.getFavorites().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favoriteTableViewCell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.cellId, for: indexPath as IndexPath) as! FavoriteTableViewCell
        
        // Set cell data, and assign self as its delegate for message passing
        favoriteTableViewCell.entry = self.viewModel.getFavorites()[indexPath.row]
        favoriteTableViewCell.delegate = self
        
        return favoriteTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentImage(entry: self.viewModel.favorites[indexPath.row])
    }
    
}

extension FavoriteEntriesViewController : EntryTableViewCellDelegate {
    // Called when thumbnail is pressed on cell
    func presentImage(entry: EntryViewModel?) {
        guard let entry = entry else {return}
        
        // Check if safe content is on
        if (UserPreferencesSingleton.getSafeContentPreference() && !entry.isContentSafe) {
            let alertController = UIAlertController(title: "Error", message: "The \"SAFE\" setting is currently turned on, blocking any NSFW content from being viewed further", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Turn Off", style: .default, handler: { [weak self] (alert) in
                self?.safeContentBarButtonSelected()
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        self.urlToDisplay = entry.url
        self.performSegue(withIdentifier: FavoriteEntriesViewController.showImageSegueIdentifier, sender: self)
    }
}
