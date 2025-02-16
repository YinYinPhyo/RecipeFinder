import UIKit

class PantryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // UI Components
    
    private let navBarContainer: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor(hex: "#020058") // Matches the navigation bar background color
           return view
       }()
    
    private let ingredientTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add Ingredient"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
                textField.backgroundColor = .white
                textField.setLeftPaddingPoints(10)

        // Create the add button with an image
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        addButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        // Add the button as the right view of the text field
        textField.rightView = addButton
        textField.rightViewMode = .always
        return textField
    }()

    private var ingredientsCollectionView: UICollectionView!
    private var recipesCollectionView: UICollectionView!

    // Data Source
    private var ingredients: [String] = []
    private var recipes: [Recipe] = [] // Store found recipes here

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Pantry"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.init(systemName: "line.horizontal.3.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(filterRecipes)
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchIngredients)
        )
        
        setupUI()
    }
    
  

    private func setupUI() {
        // TextField Layout
        
        navBarContainer.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(navBarContainer)
        ingredientTextField.translatesAutoresizingMaskIntoConstraints = false

        navBarContainer.addSubview(ingredientTextField)

        // CollectionView for Ingredients Setup
        let ingredientsLayout = UICollectionViewFlowLayout()
        ingredientsLayout.minimumLineSpacing = 5
        ingredientsLayout.minimumInteritemSpacing = 5
        let width1 = (view.frame.width - 30) / 3
        ingredientsLayout.itemSize = CGSize(width: width1, height: 40)
        ingredientsLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ingredientsLayout)
        ingredientsCollectionView.backgroundColor = .white
        ingredientsCollectionView.layer.cornerRadius = 5
        
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.register(IngredientCell.self, forCellWithReuseIdentifier: "IngredientCell")

        view.addSubview(ingredientsCollectionView)

        // CollectionView for Recipes Setup
        let recipesLayout = UICollectionViewFlowLayout()
        recipesLayout.minimumLineSpacing = 10
        recipesLayout.minimumInteritemSpacing = 10
        recipesLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let width = (view.frame.width - 30) / 2 // Two items per row
        recipesLayout.itemSize = CGSize(width: width, height: 200)

        recipesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recipesLayout)
        recipesCollectionView.backgroundColor = .white
        recipesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        
        let nib = UINib(nibName: "FavoritesCollectionViewCell", bundle: nil)
        recipesCollectionView.register(nib, forCellWithReuseIdentifier: "favoritesViewCell")

        view.addSubview(recipesCollectionView)

        NSLayoutConstraint.activate([
            
            navBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                        navBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        navBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        navBarContainer.heightAnchor.constraint(equalToConstant: 60),
            
            ingredientTextField.leadingAnchor.constraint(equalTo: navBarContainer.leadingAnchor, constant: 10),
                        ingredientTextField.centerYAnchor.constraint(equalTo: navBarContainer.centerYAnchor),
                        ingredientTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                        ingredientTextField.heightAnchor.constraint(equalToConstant: 40),

            ingredientsCollectionView.topAnchor.constraint(equalTo: navBarContainer.bottomAnchor, constant: 10),
                        ingredientsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                        ingredientsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                        ingredientsCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
             recipesCollectionView.topAnchor.constraint(equalTo: ingredientsCollectionView.bottomAnchor, constant: 20),
             recipesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             recipesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])
    }

    @objc private func addIngredient() {
        guard let text = ingredientTextField.text, !text.isEmpty else { return }
        ingredients.append(text)
        ingredientTextField.text = ""
        ingredientsCollectionView.reloadData()
    }

    @objc private func searchIngredients() {
        print("Search button tapped! Implement your search functionality here.")
        guard !ingredients.isEmpty else {
            showAlert(title: "Error", message: "Please add at least one ingredient.")
            return
        }

        let ingredientNames = ingredients.compactMap { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard !ingredientNames.isEmpty else {
            showAlert(title: "Error", message: "All ingredients are invalid or empty.")
            return
        }

        let apiManager = SpoonacularAPIManager()
        apiManager.searchRecipes(with: ingredientNames) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes // Store the found recipes
                    self?.recipesCollectionView.reloadData() // Reload recipes view
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
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
       // recipesCollectionView.reloadData()
        
        let ingredientNames = ingredients.compactMap { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard !ingredientNames.isEmpty else {
            showAlert(title: "Error", message: "All ingredients are invalid or empty.")
            return
        }
        
      
        let apiManager = SpoonacularAPIManager()
        apiManager.fetchRecipes(ingredients: ingredientNames, diet: diet) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes // Store the found recipes
                    self?.recipesCollectionView.reloadData() // Reload recipes view
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }



    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    

    // MARK: - Collection View DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ingredientsCollectionView {
            return ingredients.count
        } else if collectionView == recipesCollectionView {
            return recipes.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ingredientsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
            cell.configure(with: ingredients[indexPath.item]) { [weak self] in
                self?.ingredients.remove(at: indexPath.item)
                self?.ingredientsCollectionView.reloadData()
            }
            return cell
        } else if collectionView == recipesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesViewCell", for: indexPath) as! FavoritesCollectionViewCell
            let recipe = recipes[indexPath.item]
            cell.configure(with: recipe) // Implement this in RecipeCell
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recipesCollectionView {
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

// MARK: - Ingredient Cell
class IngredientCell: UICollectionViewCell {
    private let label = UILabel()
    private let deleteButton = UIButton(type: .system)
    private var deleteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(hex: "#020058").withAlphaComponent(0.6)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("✕", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        contentView.addSubview(label)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with ingredient: String, deleteAction: @escaping () -> Void) {
        label.text = ingredient
        self.deleteAction = deleteAction
    }
    
    @objc private func deleteTapped() {
        deleteAction?()
    }
}
