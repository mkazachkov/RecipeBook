//
//  Recipe.swift
//  RecipeBook
//
//  Created by Mikhail on 11/28/20.
//

import Foundation

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let readyInMinutes: Int
    let servings: Int
}
