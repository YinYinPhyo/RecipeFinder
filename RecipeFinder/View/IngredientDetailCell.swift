//
//  IngredientDetailCell.swift
//  RecipeFinder
//
//  Created by QSCare on 12/8/24.
//

import UIKit

class IngredientDetailCell: UICollectionViewCell {
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientImageView.layer.cornerRadius = 8
        ingredientImageView.clipsToBounds = true
    }

    func configure(with ingredient: Ingredient) {
        ingredientTitleLabel.text = ingredient.name
        
        // Load the image asynchronously
        if let imageUrl = URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(ingredient.image)") {
            loadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.ingredientImageView.image = image
                }
            }
        }
    }

    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
