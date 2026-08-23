import SwiftUI

struct SidebarView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(Color.accentColor)
                    Text("MC")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .frame(width: 34, height: 34)

                VStack(alignment: .leading, spacing: 1) {
                    Text("MissionCompiler")
                        .font(.headline)
                    Text("AI 任务编译器")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)

            List(selection: $store.selectedSessionID) {
                Section("预览任务") {
                    ForEach(store.sessions) { session in
                        HStack(spacing: 10) {
                            Image(systemName: "sparkle.magnifyingglass")
                                .foregroundStyle(.secondary)
                                .frame(width: 16)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(session.title)
                                    .lineLimit(1)
                                Text(session.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .tag(session.id)
                    }
                }
            }
            .listStyle(.sidebar)
            .onChange(of: store.selectedSessionID) {
                store.selectSession()
            }

            VStack(alignment: .leading, spacing: 7) {
                Label("公开预览版", systemImage: "lock.shield")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("只生成方案，不调用 Agent、不安装能力、不修改项目。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
