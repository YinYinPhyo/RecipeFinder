//
//  FavoriitesManager.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 12/7/24.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}

    private var favorites: [Recipe] = []

    func addFavorite(_ recipe: Recipe) {
        if !favorites.contains(where: { $0.id == recipe.id }) {
            favorites.append(recipe)
        }
    }
    
    func isFavorite(recipe: Recipe) -> Bool {
            return favorites.contains { $0.id == recipe.id }
        }
    
    func isFavoriteById(id: Int) -> Bool {
            return favorites.contains { $0.id == id }
        }
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    func removeFavorite(by id: Int) {
        favorites.removeAll { $0.id == id }
    }

    func getFavorites() -> [Recipe] {
        return favorites
    }
}
