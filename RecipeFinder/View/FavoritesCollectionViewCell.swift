//
//  FavoritesCollectionViewCell.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/6/24.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var favoritesName: UILabel!
    @IBOutlet weak var favoritesImage: UIImageView!
    
    var onFavoriteToggle: (() -> Void)?
    
    override func awakeFromNib() {
            super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

            favoritesName.numberOfLines = 0
            favoritesName.lineBreakMode = .byWordWrapping
            
            // Ensure the image view adjusts the image correctly
            //favoritesImage.contentMode = .scaleAspectFill
            favoritesImage.clipsToBounds = true // Prevents image overflow
        }
        
        func configure(with recipe: Recipe, isFavorite: Bool = false) {
            favoritesName.text = recipe.title
            if let imageUrl = URL(string: recipe.image) {
                loadImage(from: imageUrl)
            }
            
            if isFavorite {
                let heartImage = UIImage(systemName: "heart.fill")
                heartButton.setImage(heartImage, for: .normal)
            } else {
                heartButton.isHidden = true
            }
        }
    
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        onFavoriteToggle?() // Trigger the callback when tapped
    }
        
        private func loadImage(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error: Unable to convert data to image")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.favoritesImage.image = image
                }
            }
            task.resume()
        }

}
