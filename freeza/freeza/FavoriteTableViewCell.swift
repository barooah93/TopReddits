//
//  FavoriteTableViewCell.swift
//  freeza
//
//  Created by Brandon Barooah on 4/19/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    static let cellId = "FavoriteTableViewCell"
    
    var entry: EntryViewModel? {
        
        didSet {
            
            self.configureForEntry()
        }
    }
    
    var delegate : EntryTableViewCellDelegate? // Reusing delegate protocol
    
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.configureViews()
    }
    
    private func configureViews() {
        
        func configureCommentsCountLabel() {
            
            self.countLabel.layer.cornerRadius = self.countLabel.bounds.size.height / 2
        }
        
        configureCommentsCountLabel()
    }
    
    func configureForEntry(){
        
        guard let entry = self.entry else {
            
            return
        }
        
        self.thumbnailButton.setImage(entry.thumbnail, for: [])
        self.authorLabel.text = entry.author
        self.countLabel.text = entry.commentsCount
        self.ageLabel.text = entry.age
        self.titleLabel.text = entry.title
    }

    @IBAction func thumbnailButtonTapped(_ sender: Any) {
        
        if let imageURL = self.entry?.imageURL {
            
            self.delegate?.presentImage(withURL: imageURL)
        }
    }
}
