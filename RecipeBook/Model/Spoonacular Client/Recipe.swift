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
        var steps: [Step] = []
    }
    
    init(from recipeData: RecipeData) {
        self.title = recipeData.title!
        self.readyInMinutes = Int(recipeData.readyTime)
        self.servings = Int(recipeData.servings)
        self.imageData = recipeData.image
        var analyzedInstruction = AnalyzedInstruction()
        let steps = recipeData.steps?.map { stepData -> Step in
            Step(from: stepData as! StepData)
        }.sorted(by: { (step1, step2) -> Bool in
            step1.number < step2.number
        })
        analyzedInstruction.steps.append(contentsOf: steps!)
        self.analyzedInstructions.append(analyzedInstruction)
    }

    var title: String
    var image: String?
    var imageType: String?
    var readyInMinutes: Int
    var servings: Int
    var analyzedInstructions: [AnalyzedInstruction] = []
    
    private enum CodingKeys: String, CodingKey {
        case title, image, imageType, readyInMinutes, servings, analyzedInstructions
    }
    
    // ------------------------------------------------------------------------
    // MARK: - local properties
    var isFavorite: Bool?
    var imageData: Data?
}
