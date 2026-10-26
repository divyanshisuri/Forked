# Forked
A social cookbook for iPhone and iPad. Think GitHub for cooking.

Chefs post recipes. Anyone can fork a recipe to make their own variation (vegan, spicier, quicker) that stays linked to the original. Every fork credits where it came from, so recipes grow into a family tree of variations.

## Features
- Create recipes with a title, ingredients, steps, tags, and a photo
- Fork recipes to build on someone else's idea, with "Forked from" credit
- Browse variations of any recipe to find alternatives
- Search by recipe name or by ingredients you have
- Filter by diet tags like Vegetarian, Vegan, Gluten Free, Dairy Free, Quick
- Rate recipes 1 to 5 stars and see the average rating
- Collections to organize saved recipes

## Tech Stack
- Swift, SwiftUI
- SwiftData for local persistence
- PhotosPicker for recipe photos
- iOS 17+, iPhone and iPad

## Getting Started
1. Clone the repo
   ```bash
   git clone https://github.com/divyanshisuri/Forked.git
   ```
2. Open `Forked.xcodeproj` in Xcode
3. Select an iPhone simulator and press Run

Sample recipes load on first launch.

## Project Structure
```
Forked/
  Models/       Recipe, Rating, RecipeCollection
  Views/        Screens and reusable components
  Theme.swift   Theme colors and utilities
  SeedData.swift  Sample recipe seeding
```

## User Stories
| ID | Story |
|----|-------|
| KAN-29 | Recipes store title, ingredients, steps, tags, and parent recipe |
| KAN-32 | Form to create a recipe with title, ingredients, steps, and photo |
| KAN-30 | Search recipes by name |
| KAN-15 | Search recipes by ingredient |
| KAN-31 | Filter by diet tags |
| KAN-16 | Rate a recipe 1 to 5 stars |
| KAN-17 | See a recipe's average rating |
| KAN-20 | Create a variation of an existing recipe |
| KAN-21 | See all variations of a recipe |
| KAN-14 | Group saved recipes into collections |

## Design
Red, white, and black theme. Primary red `#D62828`, black `#111111`, white `#FFFFFF`. Supports dark mode.

## Team
Divya Suri, Dhanush C, Shiraaz Sayeed, Yash Kantheti
