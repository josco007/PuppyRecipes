
import Foundation

struct RecipeEnvelope: Codable {
    var title: String
    var version: Float
    var href: String
    var results: [RecipeData]
}
