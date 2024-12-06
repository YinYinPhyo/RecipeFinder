import UIKit

class PantryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // UI Components
    private let ingredientTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add Ingredient"
        textField.borderStyle = .roundedRect
        
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
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(searchIngredients), for: .touchUpInside)
        return button
    }()
    
    private var searchIngredientVC: UICollectionView!
    
    // Data Source
    private var ingredients: [String] = []
    private var recipes: [Recipe] = [] // Store found recipes here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // TextField Layout
        ingredientTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ingredientTextField)
        view.addSubview(searchButton)
        
        // CollectionView Setup
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = (view.frame.width - 30) / 3 // Adjust to your requirement
        layout.itemSize = CGSize(width: width, height: 40)
        
        searchIngredientVC = UICollectionView(frame: .zero, collectionViewLayout: layout)
        searchIngredientVC.backgroundColor = .white
        searchIngredientVC.translatesAutoresizingMaskIntoConstraints = false
        searchIngredientVC.dataSource = self
        searchIngredientVC.delegate = self
        searchIngredientVC.register(IngredientCell.self, forCellWithReuseIdentifier: "IngredientCell")
        
        view.addSubview(searchIngredientVC)
        
        // Constraints
        NSLayoutConstraint.activate([
            ingredientTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ingredientTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            ingredientTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -60),
            ingredientTextField.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchButton.centerYAnchor.constraint(equalTo: ingredientTextField.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchIngredientVC.topAnchor.constraint(equalTo: ingredientTextField.bottomAnchor, constant: 20),
            searchIngredientVC.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchIngredientVC.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchIngredientVC.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func addIngredient() {
        guard let text = ingredientTextField.text, !text.isEmpty else { return }
        ingredients.append(text)
        ingredientTextField.text = ""
        searchIngredientVC.reloadData()
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
                    self?.showSearchResultsPopup() // Show the pop-up with recipes
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    // Show searched result Recipes in another VC
    private func showSearchResultsPopup() {
        // Initialize the SearchResultRecipeVC and pass the recipes data
        let searchResultVC = SearchResultRecipeVC()
        searchResultVC.recipes = recipes
        
        // Present the SearchResultRecipeVC modally
        searchResultVC.modalPresentationStyle = .overCurrentContext // Makes it appear as a pop-up
        searchResultVC.modalTransitionStyle = .crossDissolve // Smooth transition animation
        present(searchResultVC, animated: true)
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
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
        cell.configure(with: ingredients[indexPath.item]) { [weak self] in
            self?.ingredients.remove(at: indexPath.item)
            self?.searchIngredientVC.reloadData()
        }
        return cell
    }
}

// MARK: - Ingredient Cell
class IngredientCell: UICollectionViewCell {
    private let label = UILabel()
    private let deleteButton = UIButton(type: .system)
    private var deleteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
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

