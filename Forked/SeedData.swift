import Foundation
import SwiftData

enum SeedData {
    static func seedIfNeeded(context: ModelContext) {
        let existing = try? context.fetchCount(FetchDescriptor<Recipe>())
        guard existing == 0 else { return }

        let margherita = Recipe(
            title: "Classic Margherita Pizza",
            ingredients: ["Pizza dough", "San Marzano tomatoes", "Fresh mozzarella", "Basil leaves", "Olive oil", "Salt"],
            steps: [
                "Stretch the dough into a round base.",
                "Spread crushed tomatoes evenly over the dough.",
                "Tear mozzarella and scatter across the top.",
                "Bake at 500°F for 8-10 minutes until the crust is golden.",
                "Top with fresh basil and a drizzle of olive oil."
            ],
            tags: ["Italian", "Vegetarian", "Baking"],
            imageURL: "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80"
        )

        let diavola = Recipe(
            title: "Spicy Diavola Pizza",
            ingredients: ["Pizza dough", "Tomato sauce", "Mozzarella", "Spicy salami", "Chili flakes", "Olive oil"],
            steps: [
                "Stretch the dough into a round base.",
                "Spread tomato sauce evenly over the dough.",
                "Layer mozzarella and spicy salami slices.",
                "Sprinkle chili flakes across the top.",
                "Bake at 500°F for 8-10 minutes until crisp and bubbling."
            ],
            tags: ["Italian", "Spicy"],
            imageURL: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80",
            parent: margherita
        )

        let lentilPie = Recipe(
            title: "Vegan Lentil Shepherd's Pie",
            ingredients: ["Brown lentils", "Carrots", "Peas", "Onion", "Vegetable stock", "Russet potatoes", "Plant butter"],
            steps: [
                "Simmer lentils with onion and carrots until tender.",
                "Stir in peas and vegetable stock, season well.",
                "Boil and mash the potatoes with plant butter.",
                "Spread lentil filling in a baking dish and top with mash.",
                "Bake at 400°F for 25 minutes until golden on top."
            ],
            tags: ["Vegan", "Comfort Food"],
            imageURL: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&q=80"
        )

        let tacos = Recipe(
            title: "Classic Beef Tacos",
            ingredients: ["Ground beef", "Taco seasoning", "Corn tortillas", "Lettuce", "Cheddar cheese", "Diced tomato"],
            steps: [
                "Brown the ground beef in a skillet.",
                "Stir in taco seasoning and a splash of water.",
                "Warm the tortillas.",
                "Fill tortillas with beef, lettuce, cheese, and tomato."
            ],
            tags: ["Mexican", "Quick"],
            imageURL: "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=800&q=80"
        )

        let cookies = Recipe(
            title: "Chocolate Chip Cookies",
            ingredients: ["Butter", "Brown sugar", "White sugar", "Eggs", "Flour", "Baking soda", "Chocolate chips"],
            steps: [
                "Cream butter with brown and white sugar.",
                "Beat in eggs one at a time.",
                "Mix in flour and baking soda until combined.",
                "Fold in chocolate chips.",
                "Bake at 350°F for 10-12 minutes until golden."
            ],
            tags: ["Dessert", "Baking"],
            imageURL: "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=800&q=80"
        )

        let salad = Recipe(
            title: "Classic Caesar Salad",
            ingredients: ["Romaine lettuce", "Parmesan", "Croutons", "Caesar dressing", "Black pepper"],
            steps: [
                "Chop the romaine lettuce and place in a large bowl.",
                "Toss with Caesar dressing until evenly coated.",
                "Top with shaved Parmesan and croutons.",
                "Finish with freshly cracked black pepper."
            ],
            tags: ["Salad", "Quick", "Vegetarian"],
            imageURL: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80"
        )

        let alfredo = Recipe(
            title: "Creamy Garlic Alfredo Pasta",
            ingredients: ["Fettuccine", "Butter", "Garlic", "Heavy cream", "Parmesan", "Parsley"],
            steps: [
                "Cook the fettuccine in salted water until al dente.",
                "Sauté minced garlic in butter until fragrant.",
                "Stir in heavy cream and Parmesan until smooth.",
                "Toss the pasta in the sauce and garnish with parsley."
            ],
            tags: ["Italian", "Pasta", "Comfort Food"],
            imageURL: "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800&q=80"
        )

        let pancakes = Recipe(
            title: "Fluffy Buttermilk Pancakes",
            ingredients: ["Flour", "Baking powder", "Sugar", "Buttermilk", "Eggs", "Butter"],
            steps: [
                "Whisk together the flour, baking powder, and sugar.",
                "In a separate bowl, whisk the buttermilk, eggs, and melted butter.",
                "Combine the wet and dry ingredients until just mixed.",
                "Cook on a hot griddle until golden on both sides.",
                "Serve warm with syrup."
            ],
            tags: ["Breakfast", "Baking"],
            imageURL: "https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800&q=80"
        )

        let recipes = [margherita, diavola, lentilPie, tacos, cookies, salad, alfredo, pancakes]
        for recipe in recipes {
            context.insert(recipe)
        }

        let ratingsData: [(Recipe, [Int])] = [
            (margherita, [5, 4, 5, 4]),
            (diavola, [5, 5, 4]),
            (lentilPie, [4, 4, 3]),
            (tacos, [5, 4, 4, 5]),
            (cookies, [5, 5, 5, 4]),
            (salad, [4, 3, 4]),
            (alfredo, [5, 5, 4, 5]),
            (pancakes, [5, 4, 5])
        ]

        for (recipe, starsList) in ratingsData {
            for stars in starsList {
                context.insert(Rating(stars: stars, recipe: recipe))
            }
        }
    }
}
