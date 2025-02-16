//
//  SpoonacularAPIManager.swift
//  RecipeFinder
//
//  Created by QSCare on 12/6/24.
//

import Foundation

class SpoonacularAPIManager {
    static let shared = SpoonacularAPIManager() // Singleton instance
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
    
    
    func fetchRecipeByID(recipeId: Int, completion: @escaping (DetailRecipe?) -> Void) {
        let apiKey = "75c392a287fb4dee9c48d5f086948857"
        let urlString = "https://api.spoonacular.com/recipes/\(recipeId)/information?apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recipe: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let recipe = try JSONDecoder().decode(DetailRecipe.self, from: data)
                completion(recipe)
            } catch {
                print("Error decoding recipe: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func fetchRecipes(ingredients: [String]? = nil, type: String? = nil, diet: String? = nil, query: String? = nil, cuisine: String? = nil, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        
        let apiKey = "75c392a287fb4dee9c48d5f086948857"
        let baseUrl = "https://api.spoonacular.com/recipes/complexSearch"
        var urlComponents = URLComponents(string: baseUrl)!
        var queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
        
        // Add included ingredients if provided
        if let ingredients = ingredients, !ingredients.isEmpty {
            let ingredientString = ingredients.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "includeIngredients", value: ingredientString))
        }
        
        if let query = query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        
        if let cuisine = cuisine {
            queryItems.append(URLQueryItem(name: "cuisine", value: cuisine))
        }
        
        // Add diet if provided
        if let diet = diet {
            queryItems.append(URLQueryItem(name: "diet", value: diet))
        }
        // pass type for Recipe View Controller
        if let type = type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        
        // Add other optional parameters as needed
        queryItems.append(URLQueryItem(name: "number", value: "10")) // Fetch up to 10 recipes
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// Define the structure for the API response
struct RecipeResponse: Codable {
    let results: [Recipe]
    let totalResults: Int
}


