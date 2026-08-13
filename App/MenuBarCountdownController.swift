import SwiftUI

#if os(macOS)
import AppKit

final class MenuBarCountdownController: NSObject {
    static let shared = MenuBarCountdownController()

    private var statusItem: NSStatusItem?
    private var timer: Timer?

    func install() {
        if statusItem == nil {
            let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            item.autosaveName = "ALTAMCountdownDays"
            item.button?.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "ALTAM")
            item.button?.imagePosition = .imageLeading
            item.button?.font = .monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .medium)
            item.button?.setAccessibilityTitle("ALTAM days remaining")

            let menu = NSMenu()
            let summary = NSMenuItem(title: "", action: nil, keyEquivalent: "")
            summary.tag = 1
            menu.addItem(summary)
            menu.addItem(.separator())
            let open = NSMenuItem(title: "Open ALTAM Countdown", action: #selector(openApp), keyEquivalent: "")
            open.target = self
            menu.addItem(open)
            item.menu = menu
            statusItem = item
        }

        if timer == nil {
            let timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.refresh()
            }
            timer.tolerance = 5
            RunLoop.main.add(timer, forMode: .common)
            self.timer = timer
        }

        refresh()
    }

    func refresh() {
        let days = ExamCountdown.daysRemaining()
        statusItem?.button?.title = " \(days)"
        statusItem?.menu?.item(withTag: 1)?.title =
            "\(ExamCountdown.title) · \(days) \(ExamCountdown.daysCaption(for: days)) left"
    }

    @objc private func openApp() {
        NSApp.activate(ignoringOtherApps: true)
        if NSApp.windows.isEmpty {
            NSApp.orderedWindows.forEach { $0.makeKeyAndOrderFront(nil) }
        } else {
            NSApp.windows.forEach { $0.makeKeyAndOrderFront(nil) }
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        MenuBarCountdownController.shared.install()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            NSApp.windows.forEach { $0.makeKeyAndOrderFront(nil) }
        }
        return true
    }
}
#endif
