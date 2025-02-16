//
//  FavoritesViewController.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/6/24.
//

import UIKit

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteRecipes: [Recipe] = []
    private var noFavoritesLabel: UILabel! // Declare the label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        setupNoFavoritesLabel() // Add the label programmatically
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        
        let nib = UINib(nibName: "FavoritesCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "favoritesViewCell")
        
        updateNoFavoritesLabelVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteRecipes = FavoritesManager.shared.getFavorites()
        updateNoFavoritesLabelVisibility()
        collectionView.reloadData()
    }
    
    func removeFromFavorites(_ recipe: Recipe) {
        FavoritesManager.shared.removeFavorite(by: recipe.id)
        favoriteRecipes.removeAll { $0.id == recipe.id }
        collectionView.reloadData()
        updateNoFavoritesLabelVisibility()
    }
    
    private func setupNoFavoritesLabel() {
           // Initialize the label
           noFavoritesLabel = UILabel()
           noFavoritesLabel.text = "There is no favorite items now!"
           noFavoritesLabel.textColor = .gray
           noFavoritesLabel.textAlignment = .center
           noFavoritesLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
           noFavoritesLabel.numberOfLines = 0
           
           // Add to the view and set constraints
           noFavoritesLabel.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(noFavoritesLabel)
           
           NSLayoutConstraint.activate([
               noFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               noFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               noFavoritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               noFavoritesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
           ])
       }
       
       private func updateNoFavoritesLabelVisibility() {
           noFavoritesLabel.isHidden = !favoriteRecipes.isEmpty
       }
    
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesViewCell", for: indexPath) as? FavoritesCollectionViewCell else {
            fatalError("Unable to dequeue RecipeCell")
        }
        
        let recipe = favoriteRecipes[indexPath.item]
        cell.configure(with: recipe, isFavorite: true) // Use the existing configure method from RecipeCell
        cell.onFavoriteToggle = { [weak self] in
                   self?.removeFromFavorites(recipe)
            
            
               }
        
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    // Adjust cell size for two per row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 0 // Total padding between cells
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - padding) / 2 // 2 items per row
        return CGSize(width: itemWidth-8 , height: itemWidth) // Adjust height for image and label
    }
    
    // Spacing between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0// Space between rows
    }
    
    // Spacing between columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // Space between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView {
            print("Select \(favoriteRecipes[indexPath.item])")
            let selectedRecipe = favoriteRecipes[indexPath.item]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use the appropriate storyboard name
            let detailVC = storyboard.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
            
            let navigationController = UINavigationController(rootViewController: detailVC)
            
            
            detailVC.recipeId = selectedRecipe.id
            present(navigationController, animated: true, completion: nil)
        }
    }
}


