import SwiftUI

enum WidgetTheme: String, CaseIterable {
    case ocean
    case paper
    case midnight
    case forest
    case warm

    var displayName: String {
        switch self {
        case .ocean: "Ocean"
        case .paper: "Paper"
        case .midnight: "Midnight"
        case .forest: "Forest"
        case .warm: "Warm"
        }
    }
    var background: Color {
        switch self {
        case .ocean: Color(red: 0.16, green: 0.40, blue: 0.76)
        case .paper: Color(red: 0.97, green: 0.95, blue: 0.90)
        case .midnight: Color(red: 0.12, green: 0.14, blue: 0.22)
        case .forest: Color(red: 0.18, green: 0.45, blue: 0.34)
        case .warm: Color(red: 0.86, green: 0.42, blue: 0.20)
        }
    }

    var foreground: Color {
        switch self {
        case .paper: Color(red: 0.12, green: 0.13, blue: 0.16)
        default: .white
        }
    }

    var secondary: Color {
        switch self {
        case .paper: Color(red: 0.32, green: 0.33, blue: 0.36)
        default: Color.white.opacity(0.82)
        }
    }
}

