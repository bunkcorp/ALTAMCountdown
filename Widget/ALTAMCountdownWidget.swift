import SwiftUI
import WidgetKit

struct ALTAMCountdownEntry: TimelineEntry {
    let date: Date
    let daysRemaining: Int
    let theme: WidgetTheme
}

struct ALTAMCountdownProvider: TimelineProvider {
    func placeholder(in context: Context) -> ALTAMCountdownEntry {
        entry(for: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ALTAMCountdownEntry) -> Void) {
        completion(entry(for: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ALTAMCountdownEntry>) -> Void) {
        let now = Date()
        let nextMidnight = ExamCountdown.nextMidnight(after: now)
        let entries = [
            entry(for: now),
            entry(for: nextMidnight)
        ]
        completion(Timeline(entries: entries, policy: .after(nextMidnight)))
    }

    private func entry(for date: Date) -> ALTAMCountdownEntry {
        ALTAMCountdownEntry(
            date: date,
            daysRemaining: ExamCountdown.daysRemaining(from: date),
            theme: ThemeStore.current
        )
    }
}

struct ALTAMCountdownWidgetView: View {
    var entry: ALTAMCountdownEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                mediumView
            #if os(iOS)
            case .accessoryCircular:
                accessoryCircularView
            case .accessoryInline:
                accessoryInlineView
            #endif
            default:
                smallView
            }
        }
        .foregroundStyle(entry.theme.foreground)
    }

    private var smallView: some View {
        VStack(spacing: 4) {
            Text("\(entry.daysRemaining)")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            Text(ExamCountdown.daysCaption(for: entry.daysRemaining))
                .font(.headline)
                .foregroundStyle(entry.theme.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            entry.theme.background
        }
    }

    private var mediumView: some View {
        HStack(alignment: .lastTextBaseline, spacing: 16) {
            Text("\(entry.daysRemaining)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            VStack(alignment: .leading, spacing: 4) {
                Text(ExamCountdown.daysCaption(for: entry.daysRemaining) + " left")
                    .font(.headline)
                    .foregroundStyle(entry.theme.secondary)
                Text(ExamCountdown.title)
                    .font(.subheadline.weight(.semibold))
                Text(ExamCountdown.formattedExamDate)
                    .font(.caption)
                    .foregroundStyle(entry.theme.secondary)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            entry.theme.background
        }
    }

    #if os(iOS)
    private var accessoryCircularView: some View {
        VStack(spacing: 0) {
            Text("\(entry.daysRemaining)")
                .font(.system(.title, design: .rounded).weight(.bold))
                .monospacedDigit()
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            Text("days")
                .font(.caption2)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var accessoryInlineView: some View {
        Label("\(entry.daysRemaining) days to ALTAM", systemImage: "calendar")
    }
    #endif
}

struct ALTAMCountdownWidget: Widget {
    let kind = "ALTAMCountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ALTAMCountdownProvider()) { entry in
            ALTAMCountdownWidgetView(entry: entry)
        }
        .configurationDisplayName("ALTAM Countdown")
        .description("Days remaining until Exam ALTAM. Change the color in the app.")
        .supportedFamilies(Self.supportedFamilies)
    }

    private static var supportedFamilies: [WidgetFamily] {
        #if os(iOS)
        [.systemSmall, .systemMedium, .accessoryCircular, .accessoryInline]
        #else
        [.systemSmall, .systemMedium]
        #endif
    }
}

#Preview(as: .systemSmall) {
    ALTAMCountdownWidget()
} timeline: {
    ALTAMCountdownEntry(date: .now, daysRemaining: 69, theme: .ocean)
    ALTAMCountdownEntry(date: .now, daysRemaining: 69, theme: .paper)
}
