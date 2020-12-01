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
        recipeTitle.text = recipe.title
        if let imageData = recipe.imageData {
            recipeImage.image = UIImage(data: imageData)
        } else {
            setImage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            recipe.isFavorite = result.first != nil
        }
        updateFavoriteState()
    }
    
    fileprivate func setImage() {
        self.recipeImage.contentMode = .scaleAspectFit
        self.recipeImage.image = UIImage(named: "food-placeholder")
        SpoonacularClient.getImage(url: recipe.image!) { (data, error) in
            guard let data = data else {
                return
            }
            self.recipe.imageData = data
            self.recipeImage.contentMode = .scaleAspectFill
            self.recipeImage.image = UIImage(data: data)
        }
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
            stepData.number = NSNumber(value: step.number)
            stepData.title = step.step
            if let time = step.length?.number {
                stepData.time = NSNumber(value: time)
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
