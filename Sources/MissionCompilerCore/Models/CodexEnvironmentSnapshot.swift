import Foundation

public struct CodexEnvironmentSnapshot: Equatable, Sendable {
    public enum Availability: Equatable, Sendable {
        case available(version: String)
        case unavailable(reason: String)
    }

    public let availability: Availability
    public let checkedAt: Date

    public init(availability: Availability, checkedAt: Date = Date()) {
        self.availability = availability
        self.checkedAt = checkedAt
    }
}
