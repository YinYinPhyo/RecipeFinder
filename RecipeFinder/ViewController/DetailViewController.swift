//
//  DetailViewController.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/2/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedRecipe: Recipe?

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recipe = selectedRecipe {
                    self.title = recipe.title
            // Load the image from the URL
                        if let imageUrl = URL(string: recipe.image) {
                            loadImage(from: imageUrl)
                        }
                }
                
                tableview.delegate = self
                tableview.dataSource = self

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
               self?.imageview.image = image
           }
       }
       
       task.resume()
   }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // Only show details for one recipe
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell") as? detailViewCell else {
                fatalError("Unable to dequeue detailViewCell. Ensure the identifier and class are set correctly in the storyboard.")
            }
            
            if let recipe = selectedRecipe {
                cell.recipeTitle.text = recipe.title
                cell.recipeDescriptionTextView.text = "sample summary"
                cell.authorLabel.text = "sample author"
            }
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as? InfoTableViewCell else {return UITableViewCell()}
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 190
        } else if indexPath.row == 1 {
            return 125
        }
        return 100
    }
}
