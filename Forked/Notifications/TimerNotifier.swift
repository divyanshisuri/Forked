// TimerNotifier.swift
// ADVANCED FEATURE: Local notifications. Alerts the cook when a step timer finishes, even if the app is in the background.

import Foundation
import UserNotifications

enum TimerNotifier {
    /// Asks for permission the first time, then schedules an alert `seconds` from now.
    static func schedule(id: String, recipeTitle: String, step: Int, seconds: TimeInterval) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = "Timer done: Step \(step)"
            content.body = "Check on your \(recipeTitle)."
            content.sound = .default
            content.interruptionLevel = .timeSensitive
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(seconds, 1), repeats: false)
            center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }
    }

    static func cancel(ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}

/// Shows timer alerts as banners while Forked is open, so they aren't silently dropped.
final class NotificationPresenter: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationPresenter()

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
