//
//  Step.swift
//  RecipeBook
//
//  Created by Mikhail on 11/29/20.
//

import Foundation

struct Step: Codable {
    struct Length: Codable {
        let number: Int
        let unit: String
    }
    
    let number: Int
    let step: String
    let length: Length?
}
