import Foundation

public struct CodexEnvironmentProbe: Sendable {
    public init() {}

    public func run() -> CodexEnvironmentSnapshot {
        let process = Process()
        let output = Pipe()

        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["codex", "--version"]
        process.standardOutput = output
        process.standardError = output

        do {
            try process.run()
            let data = output.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            let text = String(decoding: data, as: UTF8.self)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard process.terminationStatus == 0, !text.isEmpty else {
                return CodexEnvironmentSnapshot(
                    availability: .unavailable(reason: text.isEmpty ? "Codex 命令不可用" : text)
                )
            }
            return CodexEnvironmentSnapshot(availability: .available(version: text))
        } catch {
            return CodexEnvironmentSnapshot(
                availability: .unavailable(reason: "未找到 Codex CLI")
            )
        }
    }
}
