//
//  SearchViewController.swift
//  RecipeBook
//
//  Created by Mikhail on 11/26/20.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searhBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noRecipesLabel: UILabel!
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noRecipesLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipeController = segue.destination as! RecipeViewController
        let recipe = recipes[tableView.indexPathForSelectedRow!.row]
        recipeController.recipe = recipe
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 0 else {
            return
        }
        self.noRecipesLabel.isHidden = true
        self.recipes = []
        tableView.reloadData()
        activityIndicator.startAnimating()
        SpoonacularClient.complexSearch(query: text) { (recipes, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                self.presentErrorAlert(message: error.localizedDescription)
                return
            }
            self.recipes = recipes
            self.tableView.reloadData()
            self.noRecipesLabel.isHidden = self.recipes.count > 0
        }
    }
    
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Search Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = recipes.count
        return count
    }
    
    fileprivate func setImageForCell(_ recipe: Recipe, _ cell: RecipeCell) {
        if let imageData = recipe.imageData {
            cell.foodImage.image = UIImage(data: imageData)!
        } else {
            SpoonacularClient.getImage(url: recipe.image!) { (data, error) in
                guard let data = data else {
                    return
                }
                recipe.imageData = data
                cell.foodImage.image = UIImage(data: data)!
                cell.setNeedsLayout()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.recipeTitle.text = recipe.title
        cell.recipeTitle.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        cell.recipeTime.text = String(recipe.readyInMinutes)
        cell.servings.text = String(recipe.servings)
        cell.foodImage.image = UIImage(named: "food-placeholder")
        setImageForCell(recipe, cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRecipe", sender: nil)
    }
}
