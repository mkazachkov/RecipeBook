//
//  Recipe.swift
//  RecipeBook
//
//  Created by Mikhail on 11/28/20.
//

import Foundation
import UIKit

class Recipe: Codable {
    struct AnalyzedInstruction: Codable {
        let steps: [Step]
    }
    
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let readyInMinutes: Int
    let servings: Int
    let analyzedInstructions: [AnalyzedInstruction]
    
    private enum CodingKeys: String, CodingKey {
        case id, title, image, imageType, readyInMinutes, servings, analyzedInstructions
    }
    
    // ------------------------------------------------------------------------
    // MARK: - local properties
    var isFavorite: Bool?
    var imageData: Data?
}
