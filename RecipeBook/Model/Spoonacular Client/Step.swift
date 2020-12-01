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
    
    init(from stepData: StepData) {
        self.number = stepData.number!.intValue
        self.step = stepData.title!
        if let time = stepData.time, let unit = stepData.timeUnit {
            self.length = Length(number: time.intValue, unit: unit)
        } else {
            self.length = nil
        }
    }
    
    let number: Int
    let step: String
    let length: Length?
}
