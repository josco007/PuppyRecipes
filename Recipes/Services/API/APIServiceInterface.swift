

import Foundation

typealias APIResponse = (Result<[RecipeData], Error>) -> Void
protocol APIServiceInterface {
    func fetchRecipes(ingredients: String, page: String, completionHandler: @escaping APIResponse)
}
