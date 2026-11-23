// Sample data: the recipe catalog (added to existing installs once per catalog version) and 8 accounts (4 chefs, 4 consumers).
import Foundation
import SwiftData

enum SeedData {
    private static let catalogVersionKey = "seedCatalogVersion"

    /// Adds missing sample recipes and fills empty fields on existing ones, once per catalog version,
    /// so a recipe the user deletes doesn't come back on every launch.
    static func seedIfNeeded(context: ModelContext, defaults: UserDefaults = .standard) {
        assignLegacyOwnership(context: context)
        guard defaults.integer(forKey: catalogVersionKey) < SeedCatalog.version else { return }
        do {
            try syncCatalog(context: context)
            defaults.set(SeedCatalog.version, forKey: catalogVersionKey)
        } catch {
            context.rollback()
        }
    }

    private static func syncCatalog(context: ModelContext) throws {
        var byTitle: [String: Recipe] = [:]
        for recipe in try context.fetch(FetchDescriptor<Recipe>()) where byTitle[recipe.title] == nil {
            byTitle[recipe.title] = recipe
        }
        let start = Date.now
        for (index, seed) in SeedCatalog.recipes.enumerated() {
            if let existing = byTitle[seed.title] {
                fillMissing(existing, from: seed)
            } else {
                byTitle[seed.title] = insert(seed, parent: seed.parent.flatMap { byTitle[$0] },
                                             createdAt: start.addingTimeInterval(-Double(index) * 3600), context: context)
            }
        }
        try context.save()
    }

    private static func insert(_ seed: SeedRecipe, parent: Recipe?, createdAt: Date, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: seed.title, ingredients: seed.ingredients, steps: seed.steps, tags: seed.tags,
            imageURL: seed.imageURL, createdAt: createdAt, parent: parent
        )
        recipe.cookTimeMinutes = seed.cookTime
        recipe.servings = seed.servings
        recipe.forkNote = seed.forkNote
        context.insert(recipe)
        for stars in seed.ratings {
            context.insert(Rating(stars: stars, recipe: recipe))
        }
        return recipe
    }

    private static func fillMissing(_ recipe: Recipe, from seed: SeedRecipe) {
        if recipe.photoData == nil && recipe.imageURL == nil { recipe.imageURL = seed.imageURL }
        if recipe.cookTimeMinutes == nil { recipe.cookTimeMinutes = seed.cookTime }
        if recipe.servings == nil { recipe.servings = seed.servings }
        if recipe.forkNote == nil && recipe.parent?.title == seed.parent { recipe.forkNote = seed.forkNote }
    }

    /// Before ownership existed, only the original bundled recipes were not user-created.
    private static func assignLegacyOwnership(context: ModelContext) {
        let seedTitles: Set<String> = [
            "Classic Margherita Pizza", "Spicy Diavola Pizza", "Vegan Lentil Shepherd's Pie", "Classic Beef Tacos",
            "Chocolate Chip Cookies", "Classic Caesar Salad", "Creamy Garlic Alfredo Pasta", "Fluffy Buttermilk Pancakes"
        ]
        let descriptor = FetchDescriptor<Recipe>(predicate: #Predicate { !$0.ownershipAssigned })
        guard let recipes = try? context.fetch(descriptor) else { return }
        for recipe in recipes {
            let isSeed = seedTitles.contains(recipe.title) &&
                recipe.imageURL?.hasPrefix("https://images.unsplash.com/") == true &&
                recipe.photoData == nil
            recipe.isUserCreated = !isSeed
            recipe.ownershipAssigned = true
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
