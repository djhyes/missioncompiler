import MissionCompilerCore
import SwiftUI

struct InspectorView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("方案详情")
                    .font(.headline)

                environmentSection

                Divider()

                if let proposal = store.proposal {
                    decisionSection(proposal)
                    Divider()
                    permissionSection
                } else {
                    ContentUnavailableView(
                        "等待执行方案",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("输入任务后，这里会显示风险、权限和技术路由。")
                    )
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Label("当前能力边界", systemImage: "lock.shield")
                        .font(.subheadline.weight(.semibold))
                    Text("本版本不会调用 Codex App Server 执行任务，也不会安装 Skill、插件或 MCP。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    private var environmentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("本机环境")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Button {
                    store.refreshEnvironment()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .help("重新检测 Codex")
            }

            switch store.environment.availability {
            case let .available(version):
                Label("Codex 已就绪", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text(version)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            case let .unavailable(reason):
                Label("Codex 尚未就绪", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text(reason)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func decisionSection(_ proposal: ExecutionProposal) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("技术路由")
                .font(.subheadline.weight(.semibold))
            InspectorRow(label: "阶段", value: store.previewState.rawValue)
            InspectorRow(label: "风险", value: proposal.riskLevel.rawValue.uppercased())
            InspectorRow(label: "方式", value: proposal.mode.rawValue.uppercased())
            InspectorRow(label: "模型层级", value: proposal.modelTier)
            InspectorRow(label: "推理", value: proposal.reasoningEffort)
        }
    }

    private var permissionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("权限边界")
                .font(.subheadline.weight(.semibold))
            PermissionRow(label: "读取本机 Codex 版本", enabled: true)
            PermissionRow(label: "修改工作区", enabled: false)
            PermissionRow(label: "网络访问", enabled: false)
            PermissionRow(label: "安装能力", enabled: false)
            PermissionRow(label: "真实外部动作", enabled: false)
        }
    }
}

private struct InspectorRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .multilineTextAlignment(.trailing)
        }
        .font(.caption)
    }
}

private struct PermissionRow: View {
    let label: String
    let enabled: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: enabled ? "checkmark.circle.fill" : "minus.circle")
                .foregroundStyle(enabled ? Color.green : Color.secondary)
            Text(label)
                .font(.caption)
            Spacer()
        }
    }
}
