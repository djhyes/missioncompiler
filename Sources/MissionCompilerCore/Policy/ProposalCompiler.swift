import Foundation

public enum ProposalCompilerError: Error, Equatable {
    case emptyPrompt
}

public struct ProposalCompiler: Sendable {
    public init() {}

    public func compile(_ draft: TaskDraft) throws -> ExecutionProposal {
        let prompt = draft.rawPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty else {
            throw ProposalCompilerError.emptyPrompt
        }

        let constraints = draft.constraints.trimmingCharacters(in: .whitespacesAndNewlines)
        var protections = [
            "先进行只读环境扫描，再决定写入范围",
            "不自动安装 Skill、插件或 MCP",
            "不执行发布、付款、消息发送等真实外部动作"
        ]
        if !constraints.isEmpty {
            protections.insert("用户不可变条件：\(constraints)", at: 0)
        }

        return ExecutionProposal(
            title: Self.title(from: prompt),
            goal: prompt,
            mode: .plan,
            modelTier: "平衡能力层",
            reasoningEffort: "Medium",
            workspaceStrategy: "环境扫描后确定",
            riskLevel: .yellow,
            deliverables: [
                "结构化 TaskSpec",
                "可解释的执行方案与权限边界",
                "逐项验收结果与回滚说明"
            ],
            protections: protections,
            capabilities: [
                "本地项目只读扫描",
                "Codex App Server（下一里程碑接入）",
                "现有项目测试与 Review 能力"
            ],
            acceptanceCriteria: [
                "用户原始目标和禁止项没有在整理中丢失",
                "所有写入、网络和外部动作在执行前可见",
                "完成结论由测试或检查证据支持"
            ],
            stopCondition: "发现关键事实无法确认、所需权限扩大或出现未批准外部动作时停止并重新生成方案。",
            rollback: "真实执行适配器尚未启用；当前公开预览不会修改项目，因此无需回滚。"
        )
    }

    private static func title(from prompt: String) -> String {
        let firstLine = prompt.split(whereSeparator: \.isNewline).first.map(String.init) ?? prompt
        let compact = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
        guard compact.count > 26 else { return compact }
        return String(compact.prefix(26)) + "…"
    }
}
