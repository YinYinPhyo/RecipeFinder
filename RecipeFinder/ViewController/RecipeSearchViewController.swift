//
//  RecipeSearchViewController.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/9/24.
//

import UIKit

class RecipeSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var searchController: UISearchController!
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray // Customize the color
        return indicator
    }()
    
    var recipes: [Recipe] = []
    var filteredRecipes: [Recipe] = []
    
    var currentParameter: String?
    var currentSearch: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.init(systemName: "line.horizontal.3.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(filterRecipes)
        )
        
        setUpSearchBar()
        
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
        
    }
    
    func loadRecipes(parameter: String, text: String) {
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        let apiManager = SpoonacularAPIManager()
        if parameter == "cuisine" {
            print("in cuisine type")
            apiManager.fetchRecipes(cuisine: text) { [weak self] result in
                DispatchQueue.main.async {
                    
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                    switch result {
                    case .success(let recipes):
                        self?.recipes = recipes
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        self?.showError(error.localizedDescription)
                    }
                }
            }
        } else {
            apiManager.fetchRecipes(query: text) { [weak self] result in
                print("in query type")
                DispatchQueue.main.async {
                    
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                    switch result {
                    case .success(let recipes):
                        self?.recipes = recipes
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        self?.showError(error.localizedDescription)
                    }
                }
            }
        }
        
        
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @objc private func filterRecipes() {
        let actionSheet = UIAlertController(title: "Filter Recipes", message: "Select a dietary option", preferredStyle: .actionSheet)
        
        // Add options for dietary filters
        let veganAction = UIAlertAction(title: "Vegan", style: .default) { [weak self] _ in
            self?.applyDietaryFilter("vegan")
        }
        
        let glutenFreeAction = UIAlertAction(title: "Gluten Free", style: .default) { [weak self] _ in
            self?.applyDietaryFilter("Gluten Free")
        }
        
        let dairyFreeAction = UIAlertAction(title: "Ovo-Vegetarian", style: .default) { [weak self] _ in
            self?.applyDietaryFilter("OvonVegetarian")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add actions to the sheet
        actionSheet.addAction(veganAction)
        actionSheet.addAction(glutenFreeAction)
        actionSheet.addAction(dairyFreeAction)
        actionSheet.addAction(cancelAction)
        
        // Present the sheet
        present(actionSheet, animated: true)
    }
    
    private func applyDietaryFilter(_ diet: String) {
        
        guard let param = currentParameter, let text = currentSearch else {
            showAlert(title: "Error", message: "Search is empty")
            return
        }
        loadRecipes(parameter: param, text: text)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

extension RecipeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesViewCell", for: indexPath) as? FavoritesCollectionViewCell else {
            fatalError("Unable to dequeue RecipeCell")
        }
        
        let recipe = recipes[indexPath.item]
        cell.configure(with: recipe, isFavorite: false) // Use the existing configure method from RecipeCell
        return cell
    }
    
    
}

extension RecipeSearchViewController: UISearchBarDelegate {
    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Recipe name/Cuisine"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.searchTextField.backgroundColor = .white
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        let cuisineTypes = [
            "african",
            "asian",
            "american",
            "british",
            "cajun",
            "caribbean",
            "chinese",
            "eastern european",
            "european",
            "french",
            "german",
            "greek",
            "indian",
            "irish",
            "italian",
            "japanese",
            "jewish",
            "korean",
            "latin american",
            "mediterranean",
            "mexican",
            "middle eastern",
            "nordic",
            "southern",
            "spanish",
            "thai",
            "vietnamese"
        ]
        
        var parameter = ""
        
        if cuisineTypes.contains(searchText.lowercased()) {
            parameter = "cuisine"
        } else {
            parameter = "query"
        }
        
        currentSearch = searchText.lowercased()
        currentParameter = parameter
        loadRecipes(parameter: parameter, text: searchText.lowercased())
        
        searchBar.resignFirstResponder()
    }
    
}

extension RecipeSearchViewController: UICollectionViewDelegateFlowLayout {
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
            print("Select \(recipes[indexPath.item])")
            let selectedRecipe = recipes[indexPath.item]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use the appropriate storyboard name
            let detailVC = storyboard.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
            
            let navigationController = UINavigationController(rootViewController: detailVC)
            
            
            detailVC.recipeId = selectedRecipe.id
            present(navigationController, animated: true, completion: nil)
        }
    }
}



