//
//  RecipeCell.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/1/24.
//

import UIKit

class RecipeCell: UICollectionViewCell {
  
    @IBOutlet weak var recipeImageView: UIImageView!
    
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    override func awakeFromNib() {
          super.awakeFromNib()
        recipeTitleLabel.numberOfLines = 0 // Allows for multiple lines
        recipeTitleLabel.lineBreakMode = .byWordWrapping
          
      }
    
    func configure(with recipe: Recipe) {
           recipeTitleLabel.text = recipe.title
        if let imageUrl = URL(string: recipe.image) {
                   loadImage(from: imageUrl)
               }
       }
    private func loadImage(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error: Unable to convert data to image")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.recipeImageView.image = image
                }
            }
            
            task.resume()
        }
    
}
