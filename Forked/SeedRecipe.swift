// SeedRecipe.swift
// The shape of one sample recipe in the seed catalog.

import Foundation

struct SeedRecipe {
    let title: String
    let photo: String
    let cookTime: Int
    let servings: Int
    let tags: [String]
    let ingredients: [String]
    let steps: [String]
    let ratings: [Int]
    var parent: String? = nil
    var forkNote: String? = nil

    var imageURL: String { "https://images.unsplash.com/photo-\(photo)?w=800&q=80" }
}
