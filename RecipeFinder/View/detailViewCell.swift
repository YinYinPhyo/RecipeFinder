//
//  detailViewCell.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/2/24.
//

import UIKit

class detailViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recipeTitle: UILabel!
    
    
    @IBOutlet weak var recipeDescriptionTextView: UITextView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
