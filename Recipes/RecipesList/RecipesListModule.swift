
import Foundation
import VIPER
import UIKit

// MARK: - router

protocol RecipesListRouterPresenterInterface: RouterPresenterInterface {
    func pushToDetailScreen(using url: URL, title: String)
    func pushToDetailScreen(data: Data, baseURL: URL, title: String)
}

// MARK: - presenter

protocol RecipesListPresenterRouterInterface: PresenterRouterInterface {

}

protocol RecipesListPresenterInteractorInterface: PresenterInteractorInterface {
    func recipeFetchedSuccess(recipes:Array<ModelRecipe>)
    func recipeFetchFailed(error: Error)
    func openDetailsFrom(data: Data, baseURL: URL, title: String)
    func openDetailsFrom(url: URL, title: String)
}

protocol RecipesListPresenterViewInterface: PresenterViewInterface {
    func start()
    func fetchMore()
    func openDetail(recipe: ModelRecipe)
    func ingredientsChanged(_ ingredients: String)
}

// MARK: - interactor

protocol RecipesListInteractorPresenterInterface: InteractorPresenterInterface {
    func fetchRecipes()
    func searchByIngredients(_ ingredients: String) -> Bool
    func openDetails(for recipe: ModelRecipe)
    func loadInitialData()
}

// MARK: - view

protocol RecipesListViewPresenterInterface: ViewPresenterInterface {
    func showRecipes(recipes:Array<ModelRecipe>)
    func showError()
}


// MARK: - module builder

final class RecipesListModule: ModuleInterface {

    typealias View = RecipesListView
    typealias Presenter = RecipesListPresenter
    typealias Router = RecipesListRouter
    typealias Interactor = RecipesListInteractor

    func build() -> UIViewController {
        let view = View()
        let interactor = Interactor()
        let presenter = Presenter()
        let router = Router()

        self.assemble(view: view, presenter: presenter, router: router, interactor: interactor)

        router.viewController = view

        return view
    }
}
