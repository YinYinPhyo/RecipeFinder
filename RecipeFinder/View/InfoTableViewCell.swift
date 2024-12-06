//
//  InfoTableViewCell.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/2/24.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var preparationTime: UILabel!
    
    
    @IBOutlet weak var cookingTimeLabel: UILabel!
    
    
    @IBOutlet weak var difficultyLevelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
