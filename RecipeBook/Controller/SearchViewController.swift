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
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 0 else {
            return
        }
        SpoonacularClient.complexSearh(query: text) { (recipes, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.recipes = recipes
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipeController = segue.destination as! RecipeViewController
        let recipe = recipes[tableView.indexPathForSelectedRow!.row]
        recipeController.recipe = recipe
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.recipeTitle.text = recipe.title
        cell.recipeTitle.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        cell.recipeTime.text = String(recipe.readyInMinutes)
        cell.servings.text = String(recipe.servings)
        SpoonacularClient.getImage(url: recipe.image) { (data, error) in
            guard let data = data else {
                return
            }
            recipe.imageData = data
            cell.foodImage.image = UIImage(data: data)!
            cell.setNeedsLayout()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRecipe", sender: nil)
    }
}
