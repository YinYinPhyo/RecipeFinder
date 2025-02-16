//
//  RecipeViewController2.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/1/24.
//

import UIKit


class RecipeViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    private var searchController: UISearchController!
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray // Customize the color
        return indicator
    }()
    
    var recipeCategories: [RecipeCategory] = []
    var filteredRecipes: [RecipeCategory] = []
    private var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasty Trails"
        
        setUpSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
        // Register the cell programmatically
        tableView.register(RecipeCategoryTableViewCell.self, forCellReuseIdentifier: "recipeCategoryCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.init(systemName: "line.horizontal.3.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(filterRecipes)
        )
        
        //loadRecipeCategories()
        getCategorisedRecipes()
    }
    
    private func loadRecipeCategories() {
        // Example data
//        recipeCategories = [
//            RecipeCategory(name: "Using your milk", recipes: [
//                Recipe(title: "Scrambled Eggs", imageName: "scrambled_eggs", description: "Make your own meatballs and bake in a rich tomato sauce with layers of cheesy garlic bread. A delicious twist on classic comfort food", author: "Nadiya Hussain"),
//                Recipe(title: "Perfect Oven Scrambled Eggs", imageName: "oven_scrambled_eggs", description: "Make your own meatballs and bake in a rich tomato sauce with layers of cheesy garlic bread. A delicious twist on classic comfort food", author: "Nadiya Hussain"),
//                Recipe(title: "Simple Scrambled Eggs", imageName: "simple_scrambled_eggs", description: "Make your own meatballs and bake in a rich tomato sauce with layers of cheesy garlic bread. A delicious twist on classic comfort food", author: "Nadiya Hussain")
//            ]),
//            RecipeCategory(name: "Breakfast and brunch", recipes: [
//                Recipe(title: "Fried Eggs over the Flame", imageName: "fried_eggs", description: "Make your own meatballs and bake in a rich tomato sauce with layers of cheesy garlic bread. A delicious twist on classic comfort food", author: "Nadiya Hussain"),
//                Recipe(title: "Grandma's perfect scrambled eggs", imageName: "grandma_scrambled_eggs", description: "Make your own meatballs and bake in a rich tomato sauce with layers of cheesy garlic bread. A delicious twist on classic comfort food", author: "Nadiya Hussain"),
//                Recipe(title: "Easy omelette", imageName: "easy_omelette", description: "Make your own meatballs and bake in a rich tomato sauce with layers of cheesy garlic bread. A delicious twist on classic comfort food", author: "Nadiya Hussain")
//            ])
//        ]
        tableView.reloadData()
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
        recipeCategories = []
        getCategorisedRecipes(diet: diet)
    }
    
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCategoryTableViewCell", for: indexPath) as? RecipeCategoryTableViewCell else {
            return UITableViewCell()
        }
        let category = filteredRecipes[indexPath.row]
        cell.configure(with: category)
        cell.presentationDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
        
    }
    
}

extension RecipeViewController: RecipePresentationDelegate {
    
    func presentRecipeDetail(_ recipe: Recipe) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let detailVC = storyboard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController {
                    detailVC.recipeId = recipe.id
                    
                    let navigationController = UINavigationController(rootViewController: detailVC)
                    present(navigationController, animated: true, completion: nil)
                }
            }
}

extension RecipeViewController: UISearchResultsUpdating {
    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
              searchController.searchResultsUpdater = self
              searchController.obscuresBackgroundDuringPresentation = false
              searchController.searchBar.placeholder = "Search Recipes"
              navigationItem.searchController = searchController
              navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.searchTextField.backgroundColor = .white
    }
    
    // MARK: - UISearchResultsUpdating
        func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
                // If the search text is empty, reset to the original categories
                filteredRecipes = recipeCategories
                tableView.reloadData()
                return
            }

            // Filter recipes by name within each category
            filteredRecipes = recipeCategories.compactMap { category in
                let filteredRecipes = category.recipes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
                return filteredRecipes.isEmpty ? nil : RecipeCategory(name: category.name, recipes: filteredRecipes)
            }

            tableView.reloadData()
        }
    
    private func getCategorisedRecipes(diet: String? = nil) {
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        let categories = ["breakfast", "main course", "dessert", "snack"]
        let apiManager = SpoonacularAPIManager()
        let dispatchGroup = DispatchGroup()


        for category in categories {
            dispatchGroup.enter()
            apiManager.fetchRecipes(type: category, diet: diet) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipes):
                        let recipeCategory = RecipeCategory(name: category, recipes: recipes)
                        print("category", category, recipeCategory)
                        self?.recipeCategories.append(recipeCategory)
                    case .failure(let error):
                        print(error)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.filteredRecipes = self.recipeCategories
            self.tableView.reloadData()
        }
    }
}


