// Sample data for first launch: 8 recipes with ratings, and 8 accounts (4 chefs, 4 consumers).
import Foundation
import SwiftData

enum SeedData {
    /// Inserts the sample recipes into an empty store, or backfills ownership on older stores.
    static func seedIfNeeded(context: ModelContext) {
        let existing = try? context.fetchCount(FetchDescriptor<Recipe>())
        guard existing == 0 else {
            // Before ownership existed, only these bundled recipes were not user-created.
            let seedTimes = [
                "Classic Margherita Pizza": 10, "Spicy Diavola Pizza": 10,
                "Vegan Lentil Shepherd's Pie": 50, "Classic Beef Tacos": 20,
                "Chocolate Chip Cookies": 12, "Classic Caesar Salad": 10,
                "Creamy Garlic Alfredo Pasta": 25, "Fluffy Buttermilk Pancakes": 20
            ]
            if let recipes = try? context.fetch(FetchDescriptor<Recipe>()) {
                for recipe in recipes where !recipe.ownershipAssigned {
                    let isSeed = seedTimes[recipe.title] != nil &&
                        recipe.imageURL?.hasPrefix("https://images.unsplash.com/") == true &&
                        recipe.photoData == nil
                    recipe.isUserCreated = !isSeed
                    recipe.ownershipAssigned = true
                    if isSeed { recipe.cookTimeMinutes = seedTimes[recipe.title] }
                }
            }
            return
        }

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
        let cookTimes = [10, 10, 50, 20, 12, 10, 25, 20]
        for (recipe, minutes) in zip(recipes, cookTimes) {
            recipe.cookTimeMinutes = minutes
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

    // Procedural: a fixed sequence of steps (check, decode, insert, save) with no shared state.
    /// Inserts the 8 sample accounts when the store has no users yet, including after upgrading from V1.
    static func seedUsersIfNeeded(context: ModelContext) {
        let existing = try? context.fetchCount(FetchDescriptor<User>())
        guard existing == 0 else { return }

        for sample in sampleUsers {
            guard let salt = Data(base64Encoded: sample.salt),
                  let hash = Data(base64Encoded: sample.hash) else { continue }
            context.insert(User(
                username: sample.username,
                role: sample.role,
                passwordHash: hash,
                passwordSalt: salt,
                passwordIterations: sampleIterations
            ))
        }
        try? context.save()
    }

    // The hashes are precomputed because running PBKDF2 eight times at full strength would make
    // first launch noticeably slow. Every account uses the password "forked2026", hashed with
    // PBKDF2-HMAC-SHA256, 600,000 iterations and a 32-byte key. Regenerate a salt and hash with:
    // python3 -c "import hashlib,base64,os;s=os.urandom(16);print(base64.b64encode(s).decode(),base64.b64encode(hashlib.pbkdf2_hmac('sha256',b'forked2026',s,600000,32)).decode())"
    private static let sampleIterations = 600_000

    private static let sampleUsers: [(username: String, role: UserRole, salt: String, hash: String)] = [
        ("chef_maria", .chef, "uZ5T5KHbymWdooq+c/W8FQ==", "3QRO8xOZrztS196m/Cq5pehNkBF2YezjCsu2z+Q4aa0="),
        ("chef_kenji", .chef, "cLFzdDMQ+k2jQmWszRYKOw==", "aqobX1AsN3UDgrF5RkhyD1qY5mUJfmqkhthugVfBzak="),
        ("chef_amara", .chef, "lVLbZmZ/JnJNzuYXKuZU0g==", "BRwa0gF/zNnkd9+VpD3/eueyUZKSjEAF5+gHmk19dMU="),
        ("chef_luca", .chef, "9ZeWZn3RNag3/PgXblUtCg==", "6+E3PvpkuEh3QP0khA7IH0YQphcLOyBiTkvYk9Jg8Yg="),
        ("sam_eats", .consumer, "NFWPZEUcNdSi8893ovcMFQ==", "+8k4nPTbB0kJCgStu5oSoDwk3ohCUggAjMTjes2AkQM="),
        ("priya_k", .consumer, "aXGybXtZOY9rEsAb1NE5ag==", "F7tQNrqF7CQdvoau4bZs/va+m376bRrjZYGKXMav/lM="),
        ("jordan_b", .consumer, "K3DgzLTuqRt9UgFhpG1h6w==", "HpPezF/xfyjf1BSxukL7luL3c06s5PYz/RX1gxZj0f0="),
        ("mei_lin", .consumer, "ZLmX1CalckSHphTB8z4c0A==", "7ToedFRtdOspS+rgxwzgr3G1HQ25ZBsSHHrAuJBa+RQ=")
    ]
}
