//
//  FavoritesViewController.swift
//  RecipeBook
//
//  Created by Mikhail on 11/30/20.
//

import UIKit
import CoreData

class FavoritesViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<RecipeData>!
    
    fileprivate func setUpFetchResultsController() {
        let fetchRequest: NSFetchRequest<RecipeData> = RecipeData.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "recipes")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("the fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if fetchedResultsController == nil {
            setUpFetchResultsController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fetchedResultsController == nil {
            setUpFetchResultsController()
        }
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        let recipeData = fetchedResultsController.object(at: indexPath)
        cell.recipeTitle.text = recipeData.title
        cell.recipeTitle.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        cell.recipeTime.text = String(recipeData.readyTime)
        cell.servings.text = String(recipeData.servings)
        if let imageData = recipeData.image {
            cell.foodImage.image = UIImage(data: imageData)!
        }
        return cell
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRecipe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipeController = segue.destination as! RecipeViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let recipeData = fetchedResultsController.object(at: indexPath)
            recipeController.recipe = Recipe(from: recipeData)
        }
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
