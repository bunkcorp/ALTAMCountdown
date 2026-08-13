import Foundation

enum ThemeStore {
    static let suiteName = "group.com.kevinwoods.ALTAMCountdown"
    static let key = "widgetTheme"

    private static var suite: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    static var current: WidgetTheme {
        get {
            WidgetTheme(rawValue: suite.string(forKey: key) ?? "") ?? .ocean
        }
        set {
            suite.set(newValue.rawValue, forKey: key)
        }
    }
}
