import Foundation
import UIKit

class TopEntriesViewController: UITableViewController {

    static let showImageSegueIdentifier = "showImageSegue"
    let viewModel = TopEntriesViewModel(withClient: RedditClient())
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var safeContentButtonItem: UIBarButtonItem?
    let errorLabel = UILabel()
    let tableFooterView = UIView()
    let moreButton = UIButton(type: .system)
    var urlToDisplay: URL?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureViews()
        self.loadEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set proper text for safe content bar button item
        let newFlag = UserPreferencesSingleton.getSafeContentPreference()
        self.safeContentButtonItem?.title = newFlag ? "Safe" : "NSFW"
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { [weak self] (context) in
            
            self?.configureErrorLabelFrame()
            
            }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == TopEntriesViewController.showImageSegueIdentifier {
            
            if let urlViewController = segue.destination as? URLViewController {
                
                urlViewController.url = self.urlToDisplay
            }
        }
    }

    @objc func retryFromErrorToolbar() {
        
        self.loadEntries()
        self.dismissErrorToolbar()
    }
    
    @objc func dismissErrorToolbar() {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc func moreButtonTapped() {
        
        self.moreButton.isEnabled = false
        self.loadEntries()
    }
    
    private func loadEntries() {

        self.activityIndicatorView.startAnimating()
        self.viewModel.loadEntries {
            
            self.entriesReloaded()
        }
    }
    
    private func configureViews() {

        func configureNavBar() {
            let activityInd = UIBarButtonItem(customView: self.activityIndicatorView)
            let safeText = UserPreferencesSingleton.getSafeContentPreference() ? "Safe" : "NSFW"
            self.safeContentButtonItem = UIBarButtonItem(title: safeText, style: .plain, target: self, action: #selector(safeContentBarButtonSelected))
            self.navigationItem.rightBarButtonItems = [ safeContentButtonItem!, activityInd]
        }

        func configureTableView() {
            
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 110.0

            self.tableFooterView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80)
            self.tableFooterView.addSubview(self.moreButton)
            
            self.moreButton.frame = self.tableFooterView.bounds
            self.moreButton.setTitle("More...", for: [])
            self.moreButton.setTitle("Loading...", for: .disabled)
            self.moreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.moreButton.addTarget(self, action: #selector(TopEntriesViewController.moreButtonTapped), for: .touchUpInside)
        }
        
        func configureToolbar() {

            self.configureErrorLabelFrame()

            let errorItem = UIBarButtonItem(customView: self.errorLabel)
            let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let retryItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(TopEntriesViewController.retryFromErrorToolbar))
            let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            let closeItem = UIBarButtonItem(image: UIImage(named: "close-button"), style: .plain, target: self, action: #selector(TopEntriesViewController.dismissErrorToolbar))
            
            fixedSpaceItem.width = 12
            
            self.toolbarItems = [errorItem, flexSpaceItem, retryItem, fixedSpaceItem, closeItem]
        }
        
        configureNavBar()
        configureTableView()
        configureToolbar()
    }
    
    private func configureErrorLabelFrame() {
        
        self.errorLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 92, height: 22)
    }

    private func entriesReloaded() {
        
        self.activityIndicatorView.stopAnimating()
        self.tableView.reloadData()
        
        self.tableView.tableFooterView = self.tableFooterView
        self.moreButton.isEnabled = true
        
        if self.viewModel.hasError {

            self.errorLabel.text = self.viewModel.errorMessage
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    @objc private func safeContentBarButtonSelected(){
        let newFlag = UserPreferencesSingleton.inverseSafeContentPreference()
        
        self.safeContentButtonItem?.title = newFlag ? "Safe" : "NSFW"
    }
    
}

extension TopEntriesViewController { // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entryTableViewCell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.cellId, for: indexPath as IndexPath) as! EntryTableViewCell
        
        entryTableViewCell.entry = self.viewModel.entries[indexPath.row]
        entryTableViewCell.delegate = self
        
        return entryTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentImage(entry: self.viewModel.entries[indexPath.row])
    }
}

extension TopEntriesViewController: EntryTableViewCellDelegate {
    
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
        self.performSegue(withIdentifier: TopEntriesViewController.showImageSegueIdentifier, sender: self)
    }
    
    func addOrRemoveFavorite(_ entryViewModel: EntryViewModel?) {
        guard let entry = entryViewModel else {return}
        FavoriteEntrySingleton.sharedInstance.addOrRemoveFavorite(entry)
    }
}
