//
//  ResultRecipeCell.swift
//  RecipeFinder
//
//  Created by QSCare on 12/6/24.
//
import UIKit

class ResultRecipeCell: UICollectionViewCell {
    
    private let recipeImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Cell background and styling
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        // Configure recipe image view
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.contentMode = .scaleAspectFit
        recipeImageView.clipsToBounds = true
        contentView.addSubview(recipeImageView)
        
        // Configure name label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2 // Adjust number of lines if you want the title to wrap
        contentView.addSubview(nameLabel)
        
        // Set up the layout constraints
        NSLayoutConstraint.activate([
            // Image view constraints: Set a fixed width and height for the image (400x400)
           
            // Set width to 400
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            recipeImageView.heightAnchor.constraint(equalToConstant: 300), // Set height to 400
            
            // Name label constraints (below the image)
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8), // 8pt space between image and label
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) // Padding at the bottom
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure the cell with recipe data
    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.title // Assuming `title` is a property of your `Recipe` model
        
        // Check if image is not empty
        if !recipe.image.isEmpty, let url = URL(string: recipe.image) {
            loadImage(from: url)
        }
    }
    
    // Helper function to load the image from a URL
    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            }
        }
    }
}


