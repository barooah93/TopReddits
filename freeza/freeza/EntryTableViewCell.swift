import UIKit

protocol EntryTableViewCellDelegate {
    
    func presentImage(withURL url: URL)
    func addOrRemoveFavorite(_ entryViewModel: EntryViewModel?)
}
extension EntryTableViewCellDelegate {
    // Optional methods
    func addOrRemoveFavorite(_ entryViewModel: EntryViewModel?){}
}
class EntryTableViewCell: UITableViewCell {

    static let cellId = "EntryTableViewCell"
    
    var entry: EntryViewModel? {
        
        didSet {
            
            self.configureForEntry()
        }
    }
    
    var delegate: EntryTableViewCellDelegate?
    
    @IBOutlet private weak var thumbnailButton: UIButton!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var entryTitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.configureViews()
    }
    
    @IBAction func thumbnailButtonTapped(_ sender: AnyObject) {
        
        if let imageURL = self.entry?.imageURL {
            
            self.delegate?.presentImage(withURL: imageURL)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        // Favorite button is tapped
        self.entry?.setFavorite()
        self.favoriteButton.setImage(self.entry?.favoriteImage, for: .normal)
        self.delegate?.addOrRemoveFavorite(self.entry)
    }
    
    private func configureViews() {
        
        func configureThumbnailImageView() {
        
            self.thumbnailButton.layer.borderColor = UIColor.black.cgColor
            self.thumbnailButton.layer.borderWidth = 1
        }
        
        func configureCommentsCountLabel() {
            
            self.commentsCountLabel.layer.cornerRadius = self.commentsCountLabel.bounds.size.height / 2
        }
        
        configureThumbnailImageView()
        configureCommentsCountLabel()
    }
    
    private func configureForEntry() {
        
        guard let entry = self.entry else {
            
            return
        }
        
        self.thumbnailButton.setImage(entry.thumbnail, for: [])
        self.authorLabel.text = entry.author
        self.commentsCountLabel.text = entry.commentsCount
        self.ageLabel.text = entry.age
        self.entryTitleLabel.text = entry.title
        self.favoriteButton.setImage(self.entry?.favoriteImage, for: .normal)
        entry.loadThumbnail { [weak self] in
            
            self?.thumbnailButton.setImage(entry.thumbnail, for: [])
        }
    }
}
