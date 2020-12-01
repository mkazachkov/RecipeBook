# RecipeBook
RecipeBook is a food app that can help you find recipes online and keep the list of favorite recipes offline.

# Features
* **Search for the recipe by title.** On the left tab of main screen you can enter any title into the search bar and get a list of recipes according to your input.
* **Open the list of favorites recipes.** Right tab contains the list of favorite recipes.
* **Open detailed instructions for the recipe.** Screen with detailed instructions is opened by click on the recipe either in search results list or in favorites list.
* **Add a recipe to favorites.** You can toggle :star: button on the recipe screen at the top bar to add a recipe to Favorites list and keep its details and steps offline.
* **Remove a recipe from favorites.** If you no longer want to keep a recipe at your favorites list you can toggle :star: button at the top bar on the recipe screen to remove it from the list.

# Frameworks and External APIs
Search results list is fulfilled with the recipes from [Spoonacular Food API](https://spoonacular.com/food-api).
Favorites list is persisted on the device using Core Data.

# Installation
The app is not intended to use as a library, so clone, build and run normally using Xcode 11 and Swift 5 :-)
