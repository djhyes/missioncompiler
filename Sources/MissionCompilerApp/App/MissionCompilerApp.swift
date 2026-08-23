import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct MissionCompilerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var store = AppStore()

    var body: some Scene {
        WindowGroup("MissionCompiler", id: "main") {
            ContentView(store: store)
                .frame(minWidth: 1_080, minHeight: 720)
        }
        .defaultSize(width: 1_280, height: 800)
        .commands {
            CommandMenu("任务") {
                Button("新建任务") {
                    store.newTask()
                }
                .keyboardShortcut("n", modifiers: .command)

                Button("生成执行方案") {
                    store.compileDraft()
                }
                .keyboardShortcut(.return, modifiers: [.command, .shift])

                Divider()

                Button("重新检测 Codex") {
                    store.refreshEnvironment()
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
            }
        }

        Settings {
            SettingsView()
        }
    }
}
