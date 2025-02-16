//
//  Ingredient.swift
//  RecipeFinder
//
//  Created by YIN YIN PHYO on 12/6/24.
//

// Ingredient.swift
import Foundation

//struct Ingredient {
//    let id: Int
//    let name: String
//    let amount: Double
//    let unit: String
//}
struct Ingredient: Codable {
    let id: Int
    let aisle: String
    let image: String
    let consistency: String
    let name: String
    let nameClean: String
    let original: String
    let originalName: String
    let amount: Double
    let unit: String
    let meta: [String]
    let measures: Measures
}
struct Measures: Codable {
    let us: Measure
    let metric: Measure
}

struct Measure: Codable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}
