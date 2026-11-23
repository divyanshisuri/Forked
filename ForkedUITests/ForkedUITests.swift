// ForkedUITests.swift
// UI tests against an in-memory store and the mock API: a bad log-in, a consumer cooking a recipe,
// a chef opening Kitchen Insights, and Discover loading.

import XCTest

final class ForkedUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }

    private func logIn(_ username: String, password: String = "forked2026") {
        let usernameField = app.textFields["Username"]
        XCTAssertTrue(usernameField.waitForExistence(timeout: 10))
        usernameField.tap()
        usernameField.typeText(username)
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText(password)
        app.buttons["authSubmit"].tap()
    }

    /// iOS offers to save the password after logging in, and the prompt covers the app until dismissed.
    private func dismissSavePasswordPrompt() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        for button in [app.buttons["Not Now"], springboard.buttons["Not Now"]] where button.waitForExistence(timeout: 3) {
            button.tap()
            return
        }
    }

    private func tapWhenReady(_ element: XCUIElement, timeout: TimeInterval = 15) {
        let ready = expectation(for: NSPredicate(format: "exists == true AND hittable == true"), evaluatedWith: element)
        wait(for: [ready], timeout: timeout)
        element.tap()
    }

    func testWrongPasswordShowsAnErrorAndStaysOnLogIn() {
        logIn("sam_eats", password: "WrongPass1")
        XCTAssertTrue(app.staticTexts["Incorrect username or password."].waitForExistence(timeout: 15))
        XCTAssertTrue(app.buttons["authSubmit"].exists)
    }

    func testConsumerCanOpenARecipeAndStartCooking() {
        logIn("sam_eats")
        dismissSavePasswordPrompt()
        XCTAssertTrue(app.tabBars.buttons["Recipes"].firstMatch.waitForExistence(timeout: 15))
        XCTAssertFalse(app.buttons["Kitchen Insights"].exists, "Consumers should not see chef insights")
        tapWhenReady(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Classic Margherita Pizza")).firstMatch)

        let startCooking = app.buttons["Start Cooking"]
        XCTAssertTrue(startCooking.waitForExistence(timeout: 5))
        startCooking.tap()
        XCTAssertTrue(app.staticTexts["GATHER YOUR INGREDIENTS"].waitForExistence(timeout: 5))
        app.buttons["Start"].tap()
        XCTAssertTrue(app.staticTexts["STEP 1 OF 5"].waitForExistence(timeout: 5))
        app.buttons["Done"].tap()
        XCTAssertTrue(startCooking.waitForExistence(timeout: 5))
    }

    func testChefCanOpenKitchenInsights() {
        logIn("chef_maria")
        dismissSavePasswordPrompt()
        tapWhenReady(app.buttons["Kitchen Insights"])
        XCTAssertTrue(app.staticTexts["Top rated"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Most forked"].exists)
    }

    func testDiscoverLoadsFromTheMockAPI() {
        logIn("mei_lin")
        dismissSavePasswordPrompt()
        tapWhenReady(app.tabBars.buttons["Discover"].firstMatch)
        XCTAssertTrue(app.staticTexts["Fresh from the web"].waitForExistence(timeout: 5))
        let anyMockRecipe = NSPredicate(format: "label CONTAINS %@ OR label CONTAINS %@ OR label CONTAINS %@",
                                        "Herb Crusted Salmon", "Garden Salad with Feta", "Spiced Shrimp Fried Rice")
        XCTAssertTrue(app.buttons.matching(anyMockRecipe).firstMatch.waitForExistence(timeout: 10))
    }
}
