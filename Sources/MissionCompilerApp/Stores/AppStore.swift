import MissionCompilerCore
import Foundation

@MainActor
final class AppStore: ObservableObject {
    enum PreviewState: String {
        case draft = "等待需求"
        case proposal = "等待批准"
        case approved = "预览已批准"
    }

    struct Session: Identifiable, Hashable {
        let id: UUID
        let title: String
        let subtitle: String
        let prompt: String
        let constraints: String

        init(
            id: UUID = UUID(),
            title: String,
            subtitle: String,
            prompt: String,
            constraints: String = ""
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.prompt = prompt
            self.constraints = constraints
        }
    }

    @Published var sessions: [Session]
    @Published var selectedSessionID: Session.ID?
    @Published var draftText: String
    @Published var constraintsText: String
    @Published var proposal: ExecutionProposal?
    @Published var previewState: PreviewState = .draft
    @Published var environment: CodexEnvironmentSnapshot
    @Published var errorMessage: String?

    private let compiler = ProposalCompiler()
    private let environmentProbe = CodexEnvironmentProbe()

    init() {
        let samples = Self.sampleSessions
        sessions = samples
        selectedSessionID = samples.first?.id
        draftText = samples.first?.prompt ?? ""
        constraintsText = samples.first?.constraints ?? ""
        environment = CodexEnvironmentSnapshot(
            availability: .unavailable(reason: "尚未检测")
        )
        refreshEnvironment()
        compileDraft()
    }

    func newTask() {
        selectedSessionID = nil
        draftText = ""
        constraintsText = ""
        proposal = nil
        previewState = .draft
        errorMessage = nil
    }

    func selectSession() {
        guard let selectedSessionID,
              let session = sessions.first(where: { $0.id == selectedSessionID }) else {
            return
        }
        draftText = session.prompt
        constraintsText = session.constraints
        compileDraft()
    }

    func compileDraft() {
        do {
            proposal = try compiler.compile(
                TaskDraft(rawPrompt: draftText, constraints: constraintsText)
            )
            previewState = .proposal
            errorMessage = nil
        } catch ProposalCompilerError.emptyPrompt {
            proposal = nil
            previewState = .draft
            errorMessage = "请先描述你想完成什么。"
        } catch {
            proposal = nil
            previewState = .draft
            errorMessage = "暂时无法生成方案。"
        }
    }

    func approvePreview() {
        previewState = .approved
    }

    func editProposal() {
        previewState = .draft
    }

    func refreshEnvironment() {
        environment = environmentProbe.run()
    }

    private static let sampleSessions = [
        Session(
            title: "空数组崩溃",
            subtitle: "Bug 修复 · 本地预览",
            prompt: "空数组时结果页会崩溃，请修复并加一个回归测试，其他行为不要改。",
            constraints: "不重构相邻模块，不增加新依赖"
        ),
        Session(
            title: "温度市场筛选",
            subtitle: "高风险边界 · 示例",
            prompt: "给天气市场项目增加温度市场筛选功能，但必须继续保持 dry-run，不能下真实订单。",
            constraints: "保持 dry-run，禁止真实订单"
        ),
        Session(
            title: "未知 MCP 安装",
            subtitle: "供应链门 · 示例",
            prompt: "评估一个没有固定版本的数据库 MCP，并给出更安全的替代方案。",
            constraints: "不安装未知来源软件，不读取无关本机配置"
        )
    ]
}
