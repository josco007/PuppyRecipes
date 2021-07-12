
import Foundation
import VIPER

final class RecipesListInteractor: InteractorInterface {

    weak var presenter: RecipesListPresenterInteractorInterface!

    private var lastPageLoaded = 0
    private var recipes: [ModelRecipe] = []
    private var ingredients: String = ""

    private let api: APIServiceInterface


    private var presentingFavoriteList: Bool = false
    private var favorites: [ModelRecipe] = []

    init(api: APIServiceInterface = ServiceFactory().api) {
        self.api = api
    }
    

}

extension RecipesListInteractor: RecipesListInteractorPresenterInterface {

    func loadInitialData() {
       
    }


    private func selectedList() -> [ModelRecipe] {

        return presentingFavoriteList ? favorites : recipes
    }

    func openDetails(for recipe: ModelRecipe) {
        guard let url = URL(string: recipe.href) else { return }

        // This will always return the saved version of the recipe page at the moment that it was saved
        if recipe.favorited, let data = recipe.webContent {
            presenter.openDetailsFrom(data: data, baseURL: url, title: recipe.title)
            return
        }

        presenter.openDetailsFrom(url: url, title: recipe.title)
    }

    private func refreshData(recipe: ModelRecipe) {
        if let index = recipes.firstIndex(of: recipe) {
            recipes[index].favorited = !recipe.favorited
        }

    }

    private func curatedIngredients(_ ingredients: String) -> String {
        var ingredientsWithoutSpaces = ingredients.replacingOccurrences(of: ", ", with: ",")

        if ingredientsWithoutSpaces.last == "," {
            _ = ingredientsWithoutSpaces.removeLast()
        }
        return ingredientsWithoutSpaces
    }

    func searchByIngredients(_ ingredients: String) -> Bool {
        let newIngredientsList = curatedIngredients(ingredients)

        guard self.ingredients != newIngredientsList else { return false }
        self.ingredients = newIngredientsList

        prepareForNewSearch()

        return true
    }

    private func prepareForNewSearch() {
        lastPageLoaded = 0
        recipes = []
    }

    private func handleResponse(result: Result<[RecipeData], Error>) {

        switch result {
        case .success(let newRecipes):
            lastPageLoaded = lastPageLoaded + 1
            print("Fetched page \(lastPageLoaded) for ingredients: \(ingredients)")

            recipes.append(contentsOf: prepareData(newRecipes))
            presenter.recipeFetchedSuccess(recipes: recipes)
        case .failure(let error):
            presenter.recipeFetchFailed(error: error)
        }
    }

    private func prepareData(_ newRecipes: [RecipeData]) -> [ModelRecipe] {
        return newRecipes
            .map { ModelRecipe(data: $0) }
            .filter { !recipes.contains($0) }
            .map {
                if let indexInFavorites = favorites.firstIndex(of: $0) {
                    return favorites[indexInFavorites]
                }

                var recipe = $0
                recipe.title = recipe.title.trimmingCharacters(in: .whitespacesAndNewlines)
                recipe.ingredients = recipe.ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
                return recipe
        }
    }

    func fetchRecipes() {
        guard !presentingFavoriteList else {
            //Block fetching when displaying only favorites
            return
        }
        api.fetchRecipes(ingredients: ingredients, page: (lastPageLoaded + 1).description, completionHandler: handleResponse)
    }
}
