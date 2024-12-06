//
//  RecipeViewController2.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/1/24.
//

import UIKit


class RecipeViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    var recipeCategories: [RecipeCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasty Trails"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        tableView.delegate = self
        tableView.dataSource = self
        // Register the cell programmatically
        tableView.register(RecipeCategoryTableViewCell.self, forCellReuseIdentifier: "recipeCategoryCell")
        
        loadRecipeCategories()
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
    
    @objc private func searchButtonTapped() {
        // Action for the search button
        print("Search button tapped")
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCategoryTableViewCell", for: indexPath) as? RecipeCategoryTableViewCell else {
            return UITableViewCell()
        }
        let category = recipeCategories[indexPath.row]
        cell.configure(with: category.recipes)
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
                    detailVC.selectedRecipe = recipe
                    
                    let navigationController = UINavigationController(rootViewController: detailVC)
                    
                    detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(
                        title: "Done",
                        style: .plain,
                        target: self,
                        action: #selector(dismissDetailView)
                    )
                    detailVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
                        title: "Add to Favorites",
                        style: .plain,
                        target: self,
                        action: #selector(addToFavorites)
                    )
                    
                    present(navigationController, animated: true, completion: nil)
                }
            }
            
            @objc private func dismissDetailView() {
                dismiss(animated: true, completion: nil)
            }
            
            @objc private func addToFavorites() {
                // Add logic to handle adding to favorites
                print("Recipe added to favorites!")
            }
}


