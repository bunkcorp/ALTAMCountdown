import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var theme = ThemeStore.current

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            let days = ExamCountdown.daysRemaining(from: context.date)
            VStack(spacing: 16) {
                Text(ExamCountdown.title)
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text("\(days)")
                    .font(.system(size: 96, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                Text(ExamCountdown.daysCaption(for: days).uppercased())
                    .font(.title3.weight(.semibold))
                    .tracking(4)
                    .foregroundStyle(.secondary)

                Text(ExamCountdown.formattedExamDateLong)
                    .font(.body)
                    .foregroundStyle(.tertiary)

                VStack(spacing: 10) {
                    Text("Widget color")
                        .font(.subheadline.weight(.semibold))
                    HStack(spacing: 12) {
                        ForEach(WidgetTheme.allCases, id: \.self) { option in
                            Button {
                                theme = option
                                ThemeStore.current = option
                                WidgetCenter.shared.reloadAllTimelines()
                            } label: {
                                VStack(spacing: 6) {
                                    Circle()
                                        .fill(option.background)
                                        .overlay {
                                            Circle().strokeBorder(
                                                theme == option ? Color.primary : Color.secondary.opacity(0.3),
                                                lineWidth: theme == option ? 3 : 1
                                            )
                                        }
                                        .frame(width: 28, height: 28)
                                    Text(option.displayName)
                                        .font(.caption2)
                                        .foregroundStyle(theme == option ? Color.primary : Color.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(option.displayName)
                        }
                    }
                }
                .padding(.top, 8)

                Text("The day count stays in the Mac menu bar while this app is running. Add a Home Screen or desktop widget, then pick a color here.")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
        }
        .onAppear {
            theme = ThemeStore.current
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    ContentView()
}
