//
//  RecipeViewController.swift
//  RecipeBook
//
//  Created by Mikhail on 11/29/20.
//

import UIKit

class RecipeViewController: UIViewController {

    var recipe: Recipe!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var stepTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepTitle.text = recipe.title
        SpoonacularClient.getImage(url: recipe.image) { (data, error) in
            guard let data = data else {
                return
            }
            self.recipeImage.image = UIImage(data: data)!
        }
    }
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.analyzedInstructions.first?.steps.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell") as! StepCell
        let step = recipe.analyzedInstructions.first!.steps[indexPath.row]
        cell.stepLabel.text = "Step \(step.number)"
        cell.stepTextView.text = step.step
        return cell
    }
}
