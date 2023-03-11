import Foundation

struct IngredientData: Codable {
    let ingredients: [Ingredient]
}

struct Ingredient: Codable {
    let name: String
    let amount: Amount
}

struct Amount: Codable {
    let metric: Metric
    let us: Metric
}

struct Metric: Codable {
    let value: Double
    let unit: String
}
