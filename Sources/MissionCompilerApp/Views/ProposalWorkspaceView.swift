import MissionCompilerCore
import SwiftUI

struct ProposalWorkspaceView: View {
    @ObservedObject var store: AppStore
    @State private var expandedSection: ProposalSectionID?

    private enum ProposalSectionID: Hashable {
        case goal
        case recommendation
        case deliverables
        case protections
        case capabilities
        case risk
        case acceptance
        case rollback
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    if let proposal = store.proposal {
                        proposalContent(proposal)
                    } else {
                        emptyState
                    }
                }
                .frame(maxWidth: 820, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity, alignment: .top)
            }

            Divider()
            ComposerView(store: store)
        }
        .background(.background)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("MISSIONCOMPILER 执行方案")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .tracking(0.8)

                Text(store.proposal == nil ? "先说清目标，技术选择交给系统。" : "方案已准备好，先理解再批准。")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .textSelection(.enabled)
            }
            Spacer()
            StatusPill(text: store.previewState.rawValue, color: store.previewState == .approved ? .green : .blue)
        }
    }

    @ViewBuilder
    private func proposalContent(_ proposal: ExecutionProposal) -> some View {
        SummaryStrip(
            mode: proposal.mode.displayName,
            risk: proposal.riskLevel.displayName,
            workspace: proposal.workspaceStrategy
        )

        VStack(spacing: 0) {
            ProposalDisclosure(
                title: "目标",
                summary: "原始需求",
                icon: "scope",
                isExpanded: binding(for: .goal)
            ) {
                Text(proposal.goal)
                    .textSelection(.enabled)
            }

            Divider().padding(.leading, 46)

            ProposalDisclosure(
                title: "推荐执行方式",
                summary: "Plan、模型与工作区",
                icon: "point.3.connected.trianglepath.dotted",
                isExpanded: binding(for: .recommendation)
            ) {
                VStack(spacing: 10) {
                    DetailRow(label: "方式", value: proposal.mode.displayName)
                    DetailRow(label: "工作区", value: proposal.workspaceStrategy)
                    DetailRow(label: "模型层级", value: proposal.modelTier)
                    DetailRow(label: "推理强度", value: proposal.reasoningEffort)
                }
            }

            Divider().padding(.leading, 46)

            ProposalDisclosure(
                title: "交付物",
                summary: "\(proposal.deliverables.count) 项",
                icon: "shippingbox",
                isExpanded: binding(for: .deliverables)
            ) {
                DisclosureList(items: proposal.deliverables)
            }

            Divider().padding(.leading, 46)

            ProposalDisclosure(
                title: "保护项",
                summary: "\(proposal.protections.count) 项",
                icon: "shield",
                isExpanded: binding(for: .protections)
            ) {
                DisclosureList(items: proposal.protections)
            }

            Divider().padding(.leading, 46)

            ProposalDisclosure(
                title: "能力与权限",
                summary: "按需加载",
                icon: "puzzlepiece.extension",
                isExpanded: binding(for: .capabilities)
            ) {
                DisclosureList(items: proposal.capabilities)
            }

            Divider().padding(.leading, 46)

            ProposalDisclosure(
                title: "风险与审批",
                summary: proposal.riskLevel.displayName,
                icon: "exclamationmark.shield",
                tint: riskColor(proposal.riskLevel),
                isExpanded: binding(for: .risk)
            ) {
                Text("公开预览只生成方案。真实执行、能力安装和外部动作均未启用；后续版本仍会在动作发生前重新核对批准范围。")
                    .foregroundStyle(.secondary)
            }

            Divider().padding(.leading, 46)

            ProposalDisclosure(
                title: "验收条件",
                summary: "\(proposal.acceptanceCriteria.count) 项",
                icon: "checkmark.seal",
                isExpanded: binding(for: .acceptance)
            ) {
                DisclosureList(items: proposal.acceptanceCriteria, numbered: true)
            }

            Divider().padding(.leading, 46)

            ProposalDisclosure(
                title: "停止与回滚",
                summary: "执行保护",
                icon: "arrow.uturn.backward.circle",
                isExpanded: binding(for: .rollback)
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("停止条件").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                    Text(proposal.stopCondition)
                    Text("回滚").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                    Text(proposal.rollback)
                }
            }
        }
        .background(.quaternary.opacity(0.38), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.separator.opacity(0.5), lineWidth: 1)
        }

        HStack {
            Button("修改方案") {
                store.editProposal()
            }
            .buttonStyle(.bordered)

            Spacer()

            if store.previewState == .approved {
                Label("演示批准已记录，不会执行真实任务", systemImage: "checkmark.seal.fill")
                    .font(.callout)
                    .foregroundStyle(.green)
            } else {
                Button("批准这张预览方案") {
                    store.approvePreview()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("你不需要先学会模型、Plan、Skill 或 MCP。")
                .font(.title2.weight(.semibold))
            Text("输入原始需求和不可改变的条件，MissionCompiler 会把它整理成可审批、可验收的执行合同。")
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                FeatureRow(icon: "shield.lefthalf.filled", title: "先保护现有工作", detail: "扫描 Git、目录和未提交改动")
                Divider().padding(.leading, 46)
                FeatureRow(icon: "list.bullet.clipboard", title: "先解释再执行", detail: "目标、影响、风险和回滚一次看懂")
                Divider().padding(.leading, 46)
                FeatureRow(icon: "checkmark.seal", title: "完成必须有证据", detail: "测试与 Review 对照验收")
            }
            .background(.quaternary.opacity(0.38), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(.vertical, 24)
    }

    private func binding(for section: ProposalSectionID) -> Binding<Bool> {
        Binding(
            get: { expandedSection == section },
            set: { isExpanded in
                withAnimation(.easeInOut(duration: 0.16)) {
                    expandedSection = isExpanded ? section : nil
                }
            }
        )
    }

    private func riskColor(_ level: RiskLevel) -> Color {
        switch level {
        case .green: .green
        case .yellow: .orange
        case .red, .blocked: .red
        }
    }
}

private struct SummaryStrip: View {
    let mode: String
    let risk: String
    let workspace: String

    var body: some View {
        HStack(spacing: 8) {
            Label(mode, systemImage: "list.bullet.clipboard")
            Text("·").foregroundStyle(.tertiary)
            Label(risk, systemImage: "shield")
            Text("·").foregroundStyle(.tertiary)
            Label(workspace, systemImage: "folder")
                .lineLimit(1)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}

private struct ProposalDisclosure<Content: View>: View {
    let title: String
    let summary: String
    let icon: String
    var tint: Color = .accentColor
    @Binding var isExpanded: Bool
    @ViewBuilder let content: Content

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            content
                .font(.callout)
                .padding(.leading, 34)
                .padding(.top, 8)
                .padding(.bottom, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                    .frame(width: 20)
                Text(title)
                    .font(.body.weight(.medium))
                Spacer()
                Text(summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .padding(.trailing, 4)
            }
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

private struct DisclosureList: View {
    let items: [String]
    var numbered = false

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 9) {
                    Text(numbered ? "\(index + 1)." : "•")
                        .foregroundStyle(.secondary)
                        .frame(width: 20, alignment: .trailing)
                    Text(item)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value).multilineTextAlignment(.trailing)
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.callout.weight(.medium))
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

private struct StatusPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.12), in: Capsule())
    }
}
