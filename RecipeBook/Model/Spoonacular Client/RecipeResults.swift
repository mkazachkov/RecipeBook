//
//  RecipeResults.swift
//  RecipeBook
//
//  Created by Mikhail on 11/28/20.
//

import Foundation

struct RecipeResults: Codable {
    let results: [Recipe]
    let offset: Int
    let number: Int
    let totalResults: Int
}
