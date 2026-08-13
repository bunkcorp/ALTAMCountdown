import Foundation

enum ExamCountdown {
    static let title = "ALTAM Exam"
    static let timeZone = TimeZone(identifier: "America/Detroit")!

    static var examDate: Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = timeZone
        components.year = 2026
        components.month = 10
        components.day = 21
        components.hour = 6
        components.minute = 20
        return components.date!
    }

    private static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }

    /// Whole calendar days from today to exam day in America/Detroit.
    static func daysRemaining(from now: Date = Date()) -> Int {
        let startOfToday = calendar.startOfDay(for: now)
        let startOfExamDay = calendar.startOfDay(for: examDate)
        let days = calendar.dateComponents([.day], from: startOfToday, to: startOfExamDay).day ?? 0
        return max(0, days)
    }

    static func nextMidnight(after now: Date = Date()) -> Date {
        let startOfToday = calendar.startOfDay(for: now)
        return calendar.date(byAdding: .day, value: 1, to: startOfToday)!
    }

    static var formattedExamDate: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: examDate)
    }

    static var formattedExamDateLong: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: examDate)
    }

    static func daysCaption(for days: Int) -> String {
        days == 1 ? "day" : "days"
    }
}
