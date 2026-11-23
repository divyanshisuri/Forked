// MealDBResponse.swift
// Decodes TheMealDB's JSON, which lists ingredients as strIngredient1...20 and strMeasure1...20.

import Foundation

nonisolated struct MealDBResponse: Decodable {
    let recipes: [WebRecipe]

    private struct AnyKey: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }
        init(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { nil }
    }

    private enum CodingKeys: String, CodingKey { case meals }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard var meals = try? container.nestedUnkeyedContainer(forKey: .meals) else {
            recipes = []
            return
        }
        var parsed: [WebRecipe] = []
        while !meals.isAtEnd {
            let meal = try meals.nestedContainer(keyedBy: AnyKey.self)
            var fields: [String: String] = [:]
            for key in meal.allKeys {
                if let value = try? meal.decodeIfPresent(String.self, forKey: key) {
                    fields[key.stringValue] = value
                }
            }
            if let recipe = Self.recipe(from: fields) { parsed.append(recipe) }
        }
        recipes = parsed
    }

    // PARADIGM: Functional. map, compactMap and filter turn twenty numbered fields into one ingredient list.
    static func recipe(from fields: [String: String]) -> WebRecipe? {
        guard let id = fields["idMeal"], let title = fields["strMeal"], !title.isEmpty else { return nil }
        let ingredients = (1...20).compactMap { index -> String? in
            let name = fields["strIngredient\(index)"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !name.isEmpty else { return nil }
            let measure = fields["strMeasure\(index)"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return [measure, name].filter { !$0.isEmpty }.joined(separator: " ")
                .split(separator: " ").joined(separator: " ")
        }
        return WebRecipe(
            id: id, title: title,
            category: fields["strCategory"],
            area: fields["strArea"] ?? fields["strCountry"],
            thumbnailURL: fields["strMealThumb"],
            instructions: fields["strInstructions"] ?? "",
            ingredients: ingredients
        )
    }
}
