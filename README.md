# Forked
A social cookbook for iPhone, iPad and Mac. Think GitHub for cooking.

Chefs post recipes. Anyone can fork a recipe to make their own variation (vegan, spicier, quicker) that stays linked to the original. Every fork credits where it came from, so recipes grow into a family tree of variations.

## Features
- Post a recipe with a photo, title, ingredients, steps, cook time and tags
- Fork any recipe into your own variation, with "Forked from" credit
- See a recipe's variations and what each one changed from the original
- Edit recipes you created, and look back at earlier versions in Version History
- Search by recipe name or ingredient, and filter by tags
- Rate recipes 1 to 5 stars and see the average rating
- Favorite recipes and group them into collections

## Layouts
- **iPhone:** a tab bar with Recipes, New Recipe and Collections.
- **iPad:** a sidebar with Recipes, Collections and a New Recipe button (⌘N), a recipe grid that fits the screen, and a two-column recipe form.
- **Mac:** the iPad layout, running as a Mac Catalyst app.

## Tech Stack
- Swift, SwiftUI
- SwiftData for local storage, with a versioned schema and migration plan
- PhotosPicker for recipe photos
- iOS 17+ (iPhone and iPad), macOS 14+ (Mac Catalyst)
- No third-party packages

## Getting Started
You need a Mac with Xcode 26 or later.

1. Clone the repo
   ```bash
   git clone https://github.com/divyanshisuri/Forked.git
   ```
2. Open `Forked.xcodeproj` in Xcode
3. Choose an iPhone or iPad simulator, or My Mac (Mac Catalyst), as the run destination
4. Press Run (⌘R)

No Team or Bundle ID changes are needed to run on a simulator or on your Mac. Sample recipes load on first launch.

## Project Structure
```
Forked/
  ForkedApp.swift   App entry point; opens the SwiftData store
  SeedData.swift    Sample recipes and ratings for first launch
  Theme.swift       Colors, button style and shared styling
  Models/           SwiftData models, the versioned schema and migration plan,
                    and recipe form, diff and cook time logic
  Views/            Screens and reusable components
Forked.xcodeproj    Xcode project
```

## Known Issues
- Accounts are stored only on the device, and there's no password reset.
- Data saved by very early builds (before cook times and version history) can't be upgraded. If the app crashes at launch with "Failed to create ModelContainer", delete it from the simulator and run it again.
- "Changes from Original" compares a fork with the original as it is now, so editing the original changes what its forks show.
- A rating can't be removed once it's set, and the average includes your own rating.
- Tags are case-sensitive, so "Vegan" and "vegan" are separate filters.
- Version History appears on every recipe, including sample recipes, which can't be edited, so theirs is always empty.
- Sample recipe photos load from the internet and show a placeholder when offline.
- There are no automated tests yet.

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
| KAN-13 | Save recipes to favorites |
| KAN-19 | Edit a recipe you created |
| KAN-22 | See what changed between a recipe and its variation |
| KAN-23 | See the version history of an edited recipe |
| KAN-25 | Use the larger iPad screen when creating a recipe |
| KAN-28 | Add an optional cook time to a recipe |
| KAN-34 | Fix deleting an ingredient or step row in the recipe form |
| KAN-36 | Add a data migration plan before changing the data model |

## Design
A black, white and grey interface built on the system colors, so recipe photos stand out. Supports dark mode.

## Team
Divya Suri, Dhanush C, Shiraaz Sayeed, Yash Kantheti
