//
//  DetailRecipe.swift
//  RecipeFinder
//
//  Created by QSCare on 12/7/24.
//

import Foundation

struct DetailRecipe: Codable {
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let sustainable: Bool
    let lowFodmap: Bool
    let weightWatcherSmartPoints: Int
    let gaps: String
    let preparationMinutes: Int?
    let cookingMinutes: Int?
    let aggregateLikes: Int
    let healthScore: Int
    let creditsText: String?
    let sourceName: String?
    let pricePerServing: Double
    let extendedIngredients: [Ingredient]
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let image: String
    let imageType: String
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let occasions: [String]
    let instructions: String
    let analyzedInstructions: [Instruction]
}
struct Instruction: Codable {
    let name: String
    let steps: [Step]
}
struct Step: Codable {
    let number: Int
    let step: String
    let ingredients: [IngredientDetails]
    let equipment: [EquipmentDetails]
}

struct IngredientDetails: Codable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String
}

struct EquipmentDetails: Codable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String
}
