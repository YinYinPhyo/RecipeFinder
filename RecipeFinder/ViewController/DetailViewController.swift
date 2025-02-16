//
//  DetailViewController.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/2/24.
//

import UIKit

/// <#Description#>
class DetailViewController: UIViewController {
    
    //    var selectedRecipe: Recipe?
    var recipeId: Int? // Recipe ID passed from SearchResultRecipeVC
    var selectedRecipeDetail: DetailRecipe? // Holds the fetched recipe details
    
    
    @IBOutlet weak var instructionTV: UITextView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var summaryTV: UITextView!
    @IBOutlet weak var readyInMinutes: UILabel!
    @IBOutlet weak var servingsLbl: UILabel!
    @IBOutlet weak var healthScore: UILabel!
    @IBOutlet weak var veganLbl: UILabel!
    @IBOutlet weak var glutenLbl: UILabel!
    @IBOutlet weak var dairyFreeLbl: UILabel!
    
    @IBOutlet weak var IngredientItemVC: UICollectionView!
    
    // Add a loading spinner
        private var activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.hidesWhenStopped = true
            indicator.color = .gray // Customize the color
            return indicator
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator() // Setup the progress view
        startLoading() // Start the loading indicator
        // Clear the UI components initially
        clearUIComponents()
        
        IngredientItemVC.delegate = self
        IngredientItemVC.dataSource = self
            
        // Configure the layout for two columns
            if let layout = IngredientItemVC.collectionViewLayout as? UICollectionViewFlowLayout {
                let totalSpacing = layout.minimumInteritemSpacing * 1 // Space between columns
                let horizontalInsets = layout.sectionInset.left + layout.sectionInset.right
                let collectionViewWidth = IngredientItemVC.bounds.width
                
                // Calculate the width for each cell
                let cellWidth = (collectionViewWidth - totalSpacing - horizontalInsets) / 2
                layout.itemSize = CGSize(width: cellWidth, height: 200) // Adjust the height as needed
                layout.scrollDirection = .vertical // Change direction to vertical for a grid
            }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"), // "xmark" represents a close button symbol
            style: .plain,
            target: self,
            action: #selector(dismissDetailView)
        )
        
        let isAlreadyFavorite = FavoritesManager.shared.isFavoriteById(id: recipeId ?? 0)
        
        let image = isAlreadyFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image, // "heart" represents the Add to Favorites symbol
            style: .plain,
            target: self,
            action: #selector(toggleFavoriteStatus)
        )

        
        // Fetch the recipe details
        if let recipeId = recipeId {
            SpoonacularAPIManager.shared.fetchRecipeByID(recipeId: recipeId) { [weak self] recipeDetail in
                DispatchQueue.main.async {
                    self?.selectedRecipeDetail = recipeDetail
                    self?.stopLoading() // Stop the loading indicator when data is fetched
                    self?.updateUI()
                    self?.IngredientItemVC.reloadData()

                }
            }
        }
        
    }
    private func clearUIComponents() {
        recipeTitle.text = ""
        summaryTV.text = nil
        instructionTV.text = nil
        readyInMinutes.text = ""
        servingsLbl.text = ""
        healthScore.text = ""
        veganLbl.text = ""
        glutenLbl.text = ""
        dairyFreeLbl.text = ""
//        recipeImage.image = UIImage(named: "placeholder") // Add a placeholder image to your assets
    }

    private func setupActivityIndicator() {
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(activityIndicator)
           NSLayoutConstraint.activate([
               activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
       }
       
       private func startLoading() {
           activityIndicator.startAnimating()
           view.isUserInteractionEnabled = false // Disable user interaction while loading
       }
       
       private func stopLoading() {
           activityIndicator.stopAnimating()
           view.isUserInteractionEnabled = true // Re-enable user interaction
       }
    
    @objc private func dismissDetailView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func toggleFavoriteStatus() {
            guard let recipeDetail = selectedRecipeDetail else {
                print("No recipe details available.")
                return
            }

            let isFavorite = FavoritesManager.shared.isFavoriteById(id: recipeDetail.id)

            if isFavorite {
                FavoritesManager.shared.removeFavorite(by: recipeDetail.id)
                print("Recipe removed from favorites: \(recipeDetail.title)")
            } else {
                // Convert `DetailRecipe` to `Recipe` for storage
                let favoriteRecipe = Recipe(
                    id: recipeDetail.id,
                    title: recipeDetail.title,
                    image: recipeDetail.image,
                    imageType: "", // Replace with the actual type if needed
                    usedIngredientCount: 0, // Replace with actual values if available
                    missedIngredientCount: 0, // Replace with actual values if available
                    missedIngredients: [] // Replace with actual values if available
                )
                FavoritesManager.shared.addFavorite(favoriteRecipe)
                print("Recipe added to favorites: \(recipeDetail.title)")
            }

            updateFavoriteButton() // Update the UI after toggling
        }

        /// Updates the heart icon based on favorite status
        private func updateFavoriteButton() {
            guard let recipeId = recipeId else { return }
            let isFavorite = FavoritesManager.shared.isFavoriteById(id: recipeId)

            let image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            self.navigationItem.rightBarButtonItem?.image = image
        }
    // Update UI elements with fetched recipe details
    private func updateUI() {
        guard let recipe = selectedRecipeDetail else { return }
        
        self.title = "Recipe Details"
        
        // Load and display the recipe image
        if let imageUrl = URL(string: recipe.image) {
            loadImage(from: imageUrl)
        }
        recipeTitle.text = recipe.title

 
        let htmlString = recipe.summary
        let data = htmlString.data(using: .utf8)!
            if let attributedString = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            ) {
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                
                // Define the font size and apply it to the entire text
                mutableAttributedString.addAttribute(
                    .font,
                    value: UIFont.systemFont(ofSize: 14), // Replace 18 with your desired font size
                    range: NSRange(location: 0, length: mutableAttributedString.length)
                )
                
                summaryTV.attributedText = mutableAttributedString
            }
        // Adjust the UITextView height dynamically
        adjustUITextViewHeight(textView: summaryTV)
       
        readyInMinutes.text = "Ready in \(recipe.readyInMinutes) Minutes"
        servingsLbl.text = "Servings: \(recipe.servings)"
        healthScore.text = "Health Score: \(recipe.healthScore)"
        if recipe.vegan {
           veganLbl.text = "This is Vegan!"
        } else {
           veganLbl.text = "This is not Vegan!"
        }
        if recipe.glutenFree {
            glutenLbl.text = "Gluten Free"
        }else{
            glutenLbl.text = "No Gluten Free"
        }
        
        if recipe.dairyFree {
            dairyFreeLbl.text = "Dairy Free"
        }else{
            dairyFreeLbl.text = "No Dairy Free"
        }
        
        // Instruction
        let htmlString1 = recipe.instructions
        let data1 = htmlString1.data(using: .utf8)!
            if let attributedString1 = try? NSAttributedString(
                data: data1,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            ) {
                let mutableAttributedString1 = NSMutableAttributedString(attributedString: attributedString1)
                
                // Define the font size and apply it to the entire text
                mutableAttributedString1.addAttribute(
                    .font,
                    value: UIFont.systemFont(ofSize: 14), // Replace 18 with your desired font size
                    range: NSRange(location: 0, length: mutableAttributedString1.length)
                )
                
                instructionTV.attributedText = mutableAttributedString1
            }
       
        // Adjust the UITextView height dynamically
        adjustUITextViewHeight(textView: instructionTV)
        
        IngredientItemVC.reloadData()
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
                self?.recipeImage.image = image
            }
        }
        
        task.resume()
    }
}

func adjustUITextViewHeight(textView: UITextView) {
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.sizeToFit()
    textView.isScrollEnabled = false

    // Update the height constraint
    if let heightConstraint = textView.constraints.first(where: { $0.firstAttribute == .height }) {
        heightConstraint.constant = textView.contentSize.height
    } else {
        textView.heightAnchor.constraint(equalToConstant: textView.contentSize.height).isActive = true
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedRecipeDetail?.extendedIngredients.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientDetailCell", for: indexPath) as? IngredientDetailCell,
              let ingredient = selectedRecipeDetail?.extendedIngredients[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: ingredient)
        return cell
    }
}









