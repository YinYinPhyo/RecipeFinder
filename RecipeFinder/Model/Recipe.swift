//
//  Recipe.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/1/24.
//

//import Foundation
//
//struct Recipe {
//    let title: String
//    let imageName: String
//    let description: String
//    let author: String
//}
//
struct RecipeCategory {
    let name: String
    let recipes: [Recipe]
}

import Foundation

// Define the model for Missed Ingredient
struct MissedIngredient: Codable {
    let id: Int
    let amount: Double
    let unit: String
    let unitLong: String
    let unitShort: String
    let aisle: String
    let name: String
    let original: String
    let originalName: String
    let meta: [String]
    let image: String
}

// Define the model for Recipe
/// <#Description#>
struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let usedIngredientCount: Int?
    let missedIngredientCount: Int?
    let missedIngredients: [MissedIngredient]?
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
}

