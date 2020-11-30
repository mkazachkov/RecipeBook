//
//  RecipeViewController.swift
//  RecipeBook
//
//  Created by Mikhail on 11/29/20.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {

    var recipe: Recipe!
    let fetchRequest: NSFetchRequest<RecipeData> = RecipeData.fetchRequest()
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequest.predicate = NSPredicate(format: "title == %@", recipe.title)
        
        if recipe.isFavorite == nil {
            if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
                print("found \(result.count) recipes with such title")
                recipe.isFavorite = result.first != nil
            }
        }
        
        recipeTitle.text = recipe.title
        recipeImage.image = UIImage(data: recipe.imageData!)
        updateFavoriteState()
    }
    
    func updateFavoriteState() {
        if recipe.isFavorite! {
            addToFavoritesButton.tintColor = .systemYellow
        } else {
            addToFavoritesButton.tintColor = .lightGray
        }
    }
    
    fileprivate func saveNewRecipe() {
        let recipeData = RecipeData(context: DataController.shared.viewContext)
        recipeData.title = recipe.title
        recipeData.image = recipe.imageData
        recipeData.readyTime = Int32(recipe.readyInMinutes)
        recipeData.servings = Int32(recipe.servings)
        
        recipe.analyzedInstructions.first?.steps.forEach({ (step) in
            let stepData = StepData(context: DataController.shared.viewContext)
            stepData.title = step.step
            if let time = step.length?.number {
                stepData.time = Int32(time)
            }
            stepData.timeUnit = step.length?.unit
            recipeData.addToSteps(stepData)
        })
        try? DataController.shared.viewContext.save()
    }
    
    fileprivate func deleteRecipe() {
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            result.forEach(DataController.shared.viewContext.delete(_:))
        }
        try? DataController.shared.viewContext.save()
    }
    
    @IBAction func toggleFavorites(_ sender: Any) {
        if recipe.isFavorite! {
            deleteRecipe()
            recipe.isFavorite = false
        } else {
            saveNewRecipe()
            recipe.isFavorite = true
        }
        updateFavoriteState()
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
        if let length = step.length {
            cell.timerImage.isHidden = false
            cell.lengthLabel.isHidden = false
            cell.lengthLabel.text = "\(length.number) \(length.unit)"
        } else {
            cell.timerImage.isHidden = true
            cell.lengthLabel.isHidden = true
        }
        return cell
    }
}
