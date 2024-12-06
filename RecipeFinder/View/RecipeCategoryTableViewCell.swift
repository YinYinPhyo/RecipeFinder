import UIKit

protocol RecipePresentationDelegate: AnyObject {
    func presentRecipeDetail(_ recipe: Recipe)
}

class RecipeCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var presentationDelegate: RecipePresentationDelegate?
    
    private var recipes: [Recipe] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                   layout.scrollDirection = .horizontal
                    layout.minimumLineSpacing = 5
                    layout.minimumInteritemSpacing = 5
               }
    }
    
    func configure(with recipes: [Recipe]) {
        self.recipes = recipes
        collectionView.reloadData()
    }
}

extension RecipeCategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? RecipeCell else {
            return UICollectionViewCell()
        }
        let recipe = recipes[indexPath.item]
        cell.configure(with: recipe)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentationDelegate?.presentRecipeDetail(recipes[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2 // 3 cells per row, adjust as needed
        return CGSize(width: width, height: collectionView.frame.height) // Square cells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

