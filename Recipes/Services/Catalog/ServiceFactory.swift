

import Foundation

final class ServiceFactory: ServicesCatalog {
    var api: APIServiceInterface { RecipeAPIService(session: URLSession.shared) }
}
