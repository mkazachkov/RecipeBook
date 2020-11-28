//
//  RecipeCell.swift
//  RecipeBook
//
//  Created by Mikhail on 11/28/20.
//

import Foundation
import UIKit

class RecipeCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var recipeTitle: UITextView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var servings: UILabel!
}
