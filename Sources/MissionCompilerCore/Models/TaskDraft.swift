import Foundation

public struct TaskDraft: Equatable, Sendable {
    public let rawPrompt: String
    public let constraints: String

    public init(rawPrompt: String, constraints: String = "") {
        self.rawPrompt = rawPrompt
        self.constraints = constraints
    }
}
