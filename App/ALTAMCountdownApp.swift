import SwiftUI
import WidgetKit

@main
struct ALTAMCountdownApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    #endif

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    #if os(macOS)
                    MenuBarCountdownController.shared.install()
                    #endif
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        #if os(macOS)
        .defaultSize(width: 380, height: 500)
        #endif
    }
}
