//
//  SpoonacularAPIManager.swift
//  RecipeFinder
//
//  Created by QSCare on 12/6/24.
//

import Foundation

class SpoonacularAPIManager {
    private let apiKey = "75c392a287fb4dee9c48d5f086948857"
    private let baseURL = "https://api.spoonacular.com/recipes/findByIngredients"

    // Function to search for recipes by ingredients
    func searchRecipes(with ingredients: [String], completion: @escaping (Result<[Recipe], Error>) -> Void) {
        // Join ingredients into a comma-separated string
        let ingredientList = ingredients.joined(separator: ",")
        
        // Build the URL with the ingredients list
        guard let url = URL(string: "\(baseURL)?apiKey=\(apiKey)&ingredients=\(ingredientList)&number=10") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            
            return
        }
        print("Url \(url)")
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if data is received
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }
            
            // Decode the JSON data into Recipe objects
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
}

