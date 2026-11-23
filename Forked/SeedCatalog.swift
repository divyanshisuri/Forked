// SeedCatalog.swift
// The sample recipes, with photos, quantities, servings, ratings and fork notes.

import Foundation

enum SeedCatalog {
    static let version = 1

    static let recipes: [SeedRecipe] = [
        SeedRecipe(
            title: "Classic Margherita Pizza", photo: "1565299624946-b28f40a0ae38", cookTime: 10, servings: 2,
            tags: ["Italian", "Vegetarian", "Baking"],
            ingredients: ["1 lb pizza dough", "1 cup San Marzano tomatoes", "8 oz fresh mozzarella", "10 basil leaves", "2 tbsp olive oil", "1/2 tsp salt"],
            steps: [
                "Stretch the dough into a round base.",
                "Spread crushed tomatoes evenly over the dough.",
                "Tear mozzarella and scatter across the top.",
                "Bake at 500°F for 8-10 minutes until the crust is golden.",
                "Top with fresh basil and a drizzle of olive oil."
            ],
            ratings: [5, 4, 5, 4]
        ),
        SeedRecipe(
            title: "Spicy Diavola Pizza", photo: "1513104890138-7c749659a591", cookTime: 10, servings: 2,
            tags: ["Italian", "Spicy"],
            ingredients: ["1 lb pizza dough", "3/4 cup tomato sauce", "8 oz mozzarella", "3 oz spicy salami", "1 tsp chili flakes", "2 tbsp olive oil"],
            steps: [
                "Stretch the dough into a round base.",
                "Spread tomato sauce evenly over the dough.",
                "Layer mozzarella and spicy salami slices.",
                "Sprinkle chili flakes across the top.",
                "Bake at 500°F for 8-10 minutes until crisp and bubbling."
            ],
            ratings: [5, 5, 4],
            parent: "Classic Margherita Pizza", forkNote: "Swapped the basil for spicy salami and chili flakes."
        ),
        SeedRecipe(
            title: "Vegan Lentil Shepherd's Pie", photo: "1547592166-23ac45744acd", cookTime: 50, servings: 6,
            tags: ["Vegan", "Comfort Food", "Dairy Free"],
            ingredients: ["1 1/2 cups brown lentils", "2 carrots, diced", "1 cup peas", "1 onion, diced", "2 cups vegetable stock", "2 lb russet potatoes", "3 tbsp plant butter"],
            steps: [
                "Simmer lentils with onion and carrots for 20 minutes until tender.",
                "Stir in peas and vegetable stock, season well.",
                "Boil the potatoes for 15 minutes, then mash with plant butter.",
                "Spread lentil filling in a baking dish and top with mash.",
                "Bake at 400°F for 25 minutes until golden on top."
            ],
            ratings: [4, 4, 3]
        ),
        SeedRecipe(
            title: "Classic Beef Tacos", photo: "1551504734-5ee1c4a1479b", cookTime: 20, servings: 4,
            tags: ["Mexican", "Quick", "Gluten Free"],
            ingredients: ["1 lb ground beef", "2 tbsp taco seasoning", "8 corn tortillas", "2 cups shredded lettuce", "1 cup cheddar cheese", "1 diced tomato"],
            steps: [
                "Brown the ground beef in a skillet for 8 minutes.",
                "Stir in taco seasoning and a splash of water and simmer 5 minutes.",
                "Warm the tortillas.",
                "Fill tortillas with beef, lettuce, cheese, and tomato."
            ],
            ratings: [5, 4, 4, 5]
        ),
        SeedRecipe(
            title: "Smoky Chickpea Tacos", photo: "1565299585323-38d6b0865b47", cookTime: 15, servings: 4,
            tags: ["Mexican", "Vegan", "Quick", "Gluten Free"],
            ingredients: ["2 cans chickpeas, drained", "1 tbsp smoked paprika", "1 tsp cumin", "2 tbsp olive oil", "8 corn tortillas", "1 avocado, sliced", "1/2 cup pickled red onion", "1 lime"],
            steps: [
                "Toss chickpeas with olive oil, paprika, and cumin.",
                "Roast at 425°F for 12 minutes until crisp.",
                "Warm the tortillas in a dry pan.",
                "Fill with chickpeas, avocado, and pickled onion, then squeeze over lime."
            ],
            ratings: [5, 4, 5],
            parent: "Classic Beef Tacos", forkNote: "Made it vegan with crispy smoked chickpeas instead of beef."
        ),
        SeedRecipe(
            title: "Chocolate Chip Cookies", photo: "1499636136210-6f4ee915583e", cookTime: 12, servings: 24,
            tags: ["Dessert", "Baking", "Vegetarian"],
            ingredients: ["1 cup butter, softened", "3/4 cup brown sugar", "3/4 cup white sugar", "2 eggs", "2 1/4 cups flour", "1 tsp baking soda", "2 cups chocolate chips"],
            steps: [
                "Cream butter with brown and white sugar.",
                "Beat in eggs one at a time.",
                "Mix in flour and baking soda until combined.",
                "Fold in chocolate chips.",
                "Bake at 350°F for 10-12 minutes until golden."
            ],
            ratings: [5, 5, 5, 4]
        ),
        SeedRecipe(
            title: "Classic Caesar Salad", photo: "1512621776951-a57141f2eefd", cookTime: 10, servings: 4,
            tags: ["Salad", "Quick", "Vegetarian"],
            ingredients: ["1 head romaine lettuce", "1/2 cup shaved Parmesan", "1 cup croutons", "1/3 cup Caesar dressing", "1/4 tsp black pepper"],
            steps: [
                "Chop the romaine lettuce and place in a large bowl.",
                "Toss with Caesar dressing until evenly coated.",
                "Top with shaved Parmesan and croutons.",
                "Finish with freshly cracked black pepper."
            ],
            ratings: [4, 3, 4]
        ),
        SeedRecipe(
            title: "Creamy Garlic Alfredo Pasta", photo: "1551183053-bf91a1d81141", cookTime: 25, servings: 4,
            tags: ["Italian", "Pasta", "Comfort Food", "Vegetarian"],
            ingredients: ["12 oz fettuccine", "4 tbsp butter", "4 cloves garlic, minced", "1 1/2 cups heavy cream", "1 cup grated Parmesan", "2 tbsp chopped parsley"],
            steps: [
                "Cook the fettuccine in salted water for 10 minutes until al dente.",
                "Sauté minced garlic in butter for 1 minute until fragrant.",
                "Stir in heavy cream and Parmesan and simmer 3 minutes until smooth.",
                "Toss the pasta in the sauce and garnish with parsley."
            ],
            ratings: [5, 5, 4, 5]
        ),
        SeedRecipe(
            title: "Fluffy Buttermilk Pancakes", photo: "1528207776546-365bb710ee93", cookTime: 20, servings: 4,
            tags: ["Breakfast", "Baking", "Vegetarian"],
            ingredients: ["2 cups flour", "2 tsp baking powder", "2 tbsp sugar", "2 cups buttermilk", "2 eggs", "3 tbsp melted butter"],
            steps: [
                "Whisk together the flour, baking powder, and sugar.",
                "In a separate bowl, whisk the buttermilk, eggs, and melted butter.",
                "Combine the wet and dry ingredients until just mixed.",
                "Cook on a hot griddle for 2 minutes per side until golden.",
                "Serve warm with syrup."
            ],
            ratings: [5, 4, 5]
        ),
        SeedRecipe(
            title: "Banana Honey Pancakes", photo: "1567620905732-2d1ec7ab7445", cookTime: 20, servings: 4,
            tags: ["Breakfast", "Vegetarian"],
            ingredients: ["2 cups flour", "2 tsp baking powder", "2 cups buttermilk", "2 eggs", "3 tbsp melted butter", "2 ripe bananas", "1/4 cup honey"],
            steps: [
                "Mash one banana and whisk it into the buttermilk, eggs, and butter.",
                "Fold in the flour and baking powder until just mixed.",
                "Cook on a hot griddle for 2 minutes per side until golden.",
                "Stack and top with sliced banana and a drizzle of honey."
            ],
            ratings: [5, 5, 4],
            parent: "Fluffy Buttermilk Pancakes", forkNote: "Mashed banana into the batter and swapped sugar for honey."
        ),
        SeedRecipe(
            title: "Berry French Toast", photo: "1484723091739-30a097e8f929", cookTime: 15, servings: 2,
            tags: ["Breakfast", "Vegetarian", "Quick"],
            ingredients: ["4 thick slices brioche", "2 eggs", "1/2 cup milk", "1 tsp cinnamon", "1 tsp vanilla", "1 tbsp butter", "1 cup blueberries", "1 banana, sliced", "2 tbsp maple syrup"],
            steps: [
                "Whisk eggs, milk, cinnamon, and vanilla in a shallow dish.",
                "Soak each slice of brioche for 20 seconds per side.",
                "Fry in butter for 3 minutes per side until golden.",
                "Top with blueberries, banana, and maple syrup."
            ],
            ratings: [5, 4, 4]
        ),
        SeedRecipe(
            title: "Simple Avocado Toast", photo: "1588137378633-dea1336ce1e2", cookTime: 5, servings: 1,
            tags: ["Breakfast", "Vegan", "Quick", "Dairy Free"],
            ingredients: ["2 slices sourdough", "1 ripe avocado", "1/2 lemon", "1/4 tsp flaky salt", "1 pinch chili flakes"],
            steps: [
                "Toast the sourdough until crisp.",
                "Mash the avocado with lemon juice and salt.",
                "Spread thickly on the toast and finish with chili flakes."
            ],
            ratings: [4, 4, 5]
        ),
        SeedRecipe(
            title: "Avocado Toast with Jammy Eggs", photo: "1541519227354-08fa5d50c44d", cookTime: 12, servings: 1,
            tags: ["Breakfast", "Vegetarian", "Quick", "Dairy Free"],
            ingredients: ["2 slices seeded rye", "1 ripe avocado", "2 eggs", "1/2 lemon", "1/4 tsp flaky salt"],
            steps: [
                "Lower the eggs into boiling water and cook for 7 minutes.",
                "Move the eggs to ice water for 2 minutes, then peel and halve.",
                "Toast the rye and fan sliced avocado on top.",
                "Add the eggs and season with lemon and flaky salt."
            ],
            ratings: [5, 5, 4, 5],
            parent: "Simple Avocado Toast", forkNote: "Added jammy 7-minute eggs and switched to seeded rye."
        ),
        SeedRecipe(
            title: "Shakshuka", photo: "1590412200988-a436970781fa", cookTime: 30, servings: 4,
            tags: ["Middle Eastern", "Vegetarian", "Gluten Free", "Breakfast"],
            ingredients: ["2 tbsp olive oil", "1 onion, diced", "1 red bell pepper, diced", "3 cloves garlic, minced", "1 tsp cumin", "1 tsp smoked paprika", "28 oz crushed tomatoes", "6 eggs", "1/4 cup chopped cilantro"],
            steps: [
                "Sauté onion and pepper in olive oil for 6 minutes until soft.",
                "Add garlic, cumin, and paprika and cook for 1 minute.",
                "Pour in the tomatoes and simmer for 10 minutes until thick.",
                "Make six wells and crack in the eggs.",
                "Cover and cook for 6-8 minutes until the whites are set.",
                "Scatter with cilantro and serve with bread."
            ],
            ratings: [5, 4, 5]
        ),
        SeedRecipe(
            title: "Butter Chicken", photo: "1565557623262-b51c2513a641", cookTime: 40, servings: 4,
            tags: ["Indian", "Gluten Free", "Comfort Food"],
            ingredients: ["1 1/2 lb chicken thighs, cubed", "1/2 cup plain yogurt", "2 tbsp garam masala", "3 tbsp butter", "1 onion, diced", "1 tbsp grated ginger", "4 cloves garlic, minced", "15 oz tomato sauce", "3/4 cup heavy cream"],
            steps: [
                "Marinate the chicken in yogurt and half the garam masala for 20 minutes.",
                "Sear the chicken in 1 tbsp butter for 6 minutes, then set aside.",
                "Cook onion, ginger, and garlic in the remaining butter for 5 minutes.",
                "Add tomato sauce and the rest of the garam masala and simmer 10 minutes.",
                "Stir in the cream and chicken and simmer 8 minutes more.",
                "Serve with rice or naan."
            ],
            ratings: [5, 5, 5, 4]
        ),
        SeedRecipe(
            title: "Chickpea Tikka Masala", photo: "1585937421612-70a008356fbe", cookTime: 30, servings: 4,
            tags: ["Indian", "Vegan", "Gluten Free", "Dairy Free"],
            ingredients: ["2 cans chickpeas, drained", "2 tbsp coconut oil", "1 onion, diced", "1 tbsp grated ginger", "4 cloves garlic, minced", "2 tbsp garam masala", "15 oz tomato sauce", "1 can coconut milk", "2 cups spinach"],
            steps: [
                "Cook onion, ginger, and garlic in coconut oil for 5 minutes.",
                "Add garam masala and toast for 1 minute.",
                "Stir in tomato sauce and coconut milk and simmer 10 minutes.",
                "Add chickpeas and spinach and simmer 8 minutes more.",
                "Serve with basmati rice."
            ],
            ratings: [4, 5, 4],
            parent: "Butter Chicken", forkNote: "Vegan swap: chickpeas and coconut milk instead of chicken and cream."
        ),
        SeedRecipe(
            title: "Shrimp Pad Thai", photo: "1559314809-0d155014e29e", cookTime: 25, servings: 2,
            tags: ["Thai", "Dairy Free", "Gluten Free"],
            ingredients: ["6 oz rice noodles", "1/2 lb shrimp, peeled", "2 eggs", "3 tbsp tamarind paste", "2 tbsp fish sauce", "1 tbsp brown sugar", "2 cups bean sprouts", "3 green onions, sliced", "1/4 cup crushed peanuts", "1 lime"],
            steps: [
                "Soak the rice noodles in hot water for 8 minutes, then drain.",
                "Whisk tamarind, fish sauce, and brown sugar into a sauce.",
                "Stir-fry the shrimp for 2 minutes and push to the side.",
                "Scramble the eggs in the pan, then add noodles and sauce.",
                "Toss with bean sprouts and green onion for 2 minutes.",
                "Serve with peanuts and lime wedges."
            ],
            ratings: [5, 4, 4, 5]
        ),
        SeedRecipe(
            title: "Classic Shoyu Ramen", photo: "1557872943-16a5ac26437e", cookTime: 35, servings: 2,
            tags: ["Japanese", "Comfort Food", "Dairy Free"],
            ingredients: ["4 cups chicken stock", "3 tbsp soy sauce", "1 tbsp mirin", "1 tbsp grated ginger", "2 portions ramen noodles", "2 eggs", "2 sheets nori", "2 green onions, sliced"],
            steps: [
                "Boil the eggs for 6 minutes, then cool in ice water and peel.",
                "Simmer stock with soy sauce, mirin, and ginger for 15 minutes.",
                "Cook the noodles for 3 minutes and divide between bowls.",
                "Ladle over the broth and top with halved eggs, nori, and green onion."
            ],
            ratings: [5, 4, 5]
        ),
        SeedRecipe(
            title: "Shrimp & Snap Pea Ramen", photo: "1569718212165-3a8278d5f624", cookTime: 30, servings: 2,
            tags: ["Japanese", "Dairy Free", "Quick"],
            ingredients: ["4 cups chicken stock", "3 tbsp soy sauce", "1 tbsp grated ginger", "2 portions ramen noodles", "1/2 lb shrimp, peeled", "1 cup snap peas", "2 eggs", "1 tsp chili oil"],
            steps: [
                "Boil the eggs for 6 minutes, then cool in ice water and peel.",
                "Simmer stock with soy sauce and ginger for 10 minutes.",
                "Poach the shrimp and snap peas in the broth for 3 minutes.",
                "Cook the noodles for 3 minutes and divide between bowls.",
                "Ladle over broth, shrimp, and peas, then add eggs and chili oil."
            ],
            ratings: [4, 5, 4],
            parent: "Classic Shoyu Ramen", forkNote: "Added shrimp, snap peas, and a hit of chili oil."
        ),
        SeedRecipe(
            title: "Chicken Fried Rice", photo: "1603133872878-684f208fb84b", cookTime: 20, servings: 4,
            tags: ["Chinese", "Quick", "Dairy Free"],
            ingredients: ["4 cups cooked rice, chilled", "1 lb chicken breast, diced", "2 eggs", "1 cup peas and carrots", "3 green onions, sliced", "3 tbsp soy sauce", "1 tbsp sesame oil", "2 tbsp vegetable oil"],
            steps: [
                "Stir-fry the chicken in vegetable oil for 6 minutes and set aside.",
                "Scramble the eggs and set aside.",
                "Fry the rice with peas and carrots for 4 minutes until hot.",
                "Return chicken and egg, add soy sauce and sesame oil, and toss.",
                "Finish with green onion."
            ],
            ratings: [4, 4, 5, 4]
        ),
        SeedRecipe(
            title: "Garlic Shrimp Spaghetti", photo: "1563379926898-05f4575a45d8", cookTime: 20, servings: 4,
            tags: ["Italian", "Pasta", "Quick", "Dairy Free"],
            ingredients: ["12 oz spaghetti", "1 lb shrimp, peeled", "6 cloves garlic, sliced", "1/4 cup olive oil", "1 cup cherry tomatoes, halved", "1/2 tsp chili flakes", "1 lemon", "1/4 cup chopped parsley"],
            steps: [
                "Cook the spaghetti for 9 minutes until al dente.",
                "Sizzle garlic and chili flakes in olive oil for 1 minute.",
                "Add shrimp and tomatoes and cook for 4 minutes.",
                "Toss with the pasta, lemon juice, and parsley."
            ],
            ratings: [5, 4, 5]
        ),
        SeedRecipe(
            title: "Penne alla Vodka", photo: "1621996346565-e3dbc646d9a9", cookTime: 25, servings: 4,
            tags: ["Italian", "Pasta", "Vegetarian"],
            ingredients: ["1 lb penne", "2 tbsp butter", "1 shallot, minced", "3 tbsp tomato paste", "1/4 cup vodka", "3/4 cup heavy cream", "1/2 cup grated Parmesan"],
            steps: [
                "Cook the penne for 11 minutes until al dente.",
                "Soften the shallot in butter for 3 minutes.",
                "Stir in tomato paste and cook for 2 minutes until brick red.",
                "Add vodka and simmer for 1 minute, then stir in cream.",
                "Toss with the pasta and Parmesan."
            ],
            ratings: [5, 5, 4]
        ),
        SeedRecipe(
            title: "Pesto Pasta Salad", photo: "1473093295043-cdd812d0e601", cookTime: 15, servings: 6,
            tags: ["Salad", "Pasta", "Vegetarian", "Quick"],
            ingredients: ["1 lb farfalle", "1/2 cup basil pesto", "1 cup cherry tomatoes, halved", "2 cups arugula", "1/3 cup grated Parmesan"],
            steps: [
                "Cook the farfalle for 11 minutes, then rinse under cold water.",
                "Toss with pesto until coated.",
                "Fold in tomatoes, arugula, and Parmesan."
            ],
            ratings: [4, 4, 4]
        ),
        SeedRecipe(
            title: "Pan-Seared Salmon", photo: "1519708227418-c8fd9a32b7a2", cookTime: 15, servings: 2,
            tags: ["Seafood", "Gluten Free", "Dairy Free", "Quick"],
            ingredients: ["2 salmon fillets", "1 tbsp olive oil", "1/2 tsp salt", "1/4 tsp black pepper", "1 lime", "2 cups sautéed greens"],
            steps: [
                "Pat the salmon dry and season with salt and pepper.",
                "Sear skin-side down in hot oil for 4 minutes.",
                "Flip and cook for 3 minutes more.",
                "Serve over greens with a squeeze of lime."
            ],
            ratings: [5, 4, 5, 5]
        ),
        SeedRecipe(
            title: "Roasted Butternut Squash Soup", photo: "1476718406336-bb5a9690ee2a", cookTime: 45, servings: 6,
            tags: ["Soup", "Vegan", "Gluten Free", "Dairy Free"],
            ingredients: ["1 butternut squash, cubed", "1 onion, quartered", "2 tbsp olive oil", "4 cups vegetable stock", "1/2 cup coconut milk", "1 tsp smoked paprika", "2 tbsp pumpkin seeds"],
            steps: [
                "Roast squash and onion in olive oil at 425°F for 30 minutes.",
                "Blend with stock and paprika until smooth.",
                "Warm through with coconut milk for 5 minutes.",
                "Serve topped with pumpkin seeds."
            ],
            ratings: [4, 5, 4]
        ),
        SeedRecipe(
            title: "Lemon Herb Quinoa Bowl", photo: "1547592180-85f173990554", cookTime: 25, servings: 2,
            tags: ["Vegan", "Gluten Free", "Healthy"],
            ingredients: ["1 cup quinoa", "2 cups water", "1 cup green beans", "1 cup cherry tomatoes", "2 tbsp olive oil", "1 lemon", "2 tbsp fresh herbs"],
            steps: [
                "Simmer quinoa in water for 15 minutes, then fluff.",
                "Blanch the green beans for 3 minutes.",
                "Whisk olive oil, lemon juice, and herbs into a dressing.",
                "Toss everything together and serve warm or cold."
            ],
            ratings: [4, 4, 5]
        ),
        SeedRecipe(
            title: "Protein Power Bowl", photo: "1546069901-ba9599a7e63c", cookTime: 20, servings: 2,
            tags: ["Healthy", "Vegetarian", "Gluten Free"],
            ingredients: ["7 oz firm tofu, cubed", "2 eggs", "1 cup corn", "1 cup shredded red cabbage", "1 cucumber, diced", "1 cup cherry tomatoes", "2 cups mixed greens", "2 tbsp tahini dressing"],
            steps: [
                "Bake the tofu at 400°F for 15 minutes until golden.",
                "Boil the eggs for 8 minutes, then peel and halve.",
                "Arrange greens and vegetables in bowls.",
                "Top with tofu and eggs and drizzle with tahini dressing."
            ],
            ratings: [4, 5, 4]
        ),
        SeedRecipe(
            title: "Classic Smash Burger", photo: "1586190848861-99aa4a171e90", cookTime: 15, servings: 4,
            tags: ["American", "Quick"],
            ingredients: ["1 lb ground beef", "4 brioche buns", "4 slices cheddar", "1 tomato, sliced", "4 lettuce leaves", "4 strips bacon", "1/4 cup burger sauce"],
            steps: [
                "Cook the bacon for 6 minutes until crisp.",
                "Smash beef balls onto a hot griddle and cook for 2 minutes.",
                "Flip, add cheese, and cook for 1 minute more.",
                "Build on toasted buns with sauce, lettuce, tomato, and bacon."
            ],
            ratings: [5, 5, 4, 5]
        ),
        SeedRecipe(
            title: "Southern Fried Chicken", photo: "1569058242253-92a9c755a0ec", cookTime: 40, servings: 4,
            tags: ["American", "Comfort Food"],
            ingredients: ["3 lb chicken pieces", "2 cups buttermilk", "2 cups flour", "1 tbsp paprika", "1 tsp garlic powder", "1 tsp cayenne", "2 tsp salt", "4 cups oil for frying"],
            steps: [
                "Soak the chicken in buttermilk for at least 1 hour.",
                "Mix flour with paprika, garlic powder, cayenne, and salt.",
                "Dredge each piece in the seasoned flour.",
                "Fry at 350°F for 12-15 minutes until golden and cooked through.",
                "Rest on a rack for 5 minutes before serving."
            ],
            ratings: [5, 4, 5]
        ),
        SeedRecipe(
            title: "Fudgy Brownies", photo: "1606313564200-e75d5e30476c", cookTime: 35, servings: 16,
            tags: ["Dessert", "Baking", "Vegetarian"],
            ingredients: ["1/2 cup butter", "8 oz dark chocolate", "1 cup sugar", "3 eggs", "1 tsp vanilla", "1/2 cup flour", "1/4 cup cocoa powder"],
            steps: [
                "Melt the butter and chocolate together.",
                "Whisk in sugar, then eggs and vanilla.",
                "Fold in flour and cocoa until just combined.",
                "Bake at 350°F for 25 minutes until just set.",
                "Cool for 30 minutes before slicing."
            ],
            ratings: [5, 5, 5, 4]
        )
    ]
}
