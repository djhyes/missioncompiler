import Foundation

public enum ExecutionMode: String, Codable, Sendable {
    case direct
    case plan

    public var displayName: String {
        switch self {
        case .direct: "直接执行"
        case .plan: "先计划再执行"
        }
    }
}

public enum RiskLevel: String, Codable, Sendable {
    case green
    case yellow
    case red
    case blocked

    public var displayName: String {
        switch self {
        case .green: "低风险"
        case .yellow: "需要批准"
        case .red: "逐次批准"
        case .blocked: "已阻塞"
        }
    }
}

public struct ExecutionProposal: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public let goal: String
    public let mode: ExecutionMode
    public let modelTier: String
    public let reasoningEffort: String
    public let workspaceStrategy: String
    public let riskLevel: RiskLevel
    public let deliverables: [String]
    public let protections: [String]
    public let capabilities: [String]
    public let acceptanceCriteria: [String]
    public let stopCondition: String
    public let rollback: String

    public init(
        id: UUID = UUID(),
        title: String,
        goal: String,
        mode: ExecutionMode,
        modelTier: String,
        reasoningEffort: String,
        workspaceStrategy: String,
        riskLevel: RiskLevel,
        deliverables: [String],
        protections: [String],
        capabilities: [String],
        acceptanceCriteria: [String],
        stopCondition: String,
        rollback: String
    ) {
        self.id = id
        self.title = title
        self.goal = goal
        self.mode = mode
        self.modelTier = modelTier
        self.reasoningEffort = reasoningEffort
        self.workspaceStrategy = workspaceStrategy
        self.riskLevel = riskLevel
        self.deliverables = deliverables
        self.protections = protections
        self.capabilities = capabilities
        self.acceptanceCriteria = acceptanceCriteria
        self.stopCondition = stopCondition
        self.rollback = rollback
    }
}
