import SwiftUI

struct SettingsView: View {
    @AppStorage("showTechnicalDetails") private var showTechnicalDetails = true

    var body: some View {
        TabView {
            Form {
                Toggle("默认显示技术详情", isOn: $showTechnicalDetails)
                Text("真实执行、能力安装和外部动作在公开预览版中始终关闭。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .formStyle(.grouped)
            .tabItem {
                Label("通用", systemImage: "gearshape")
            }
        }
        .frame(width: 480, height: 260)
        .scenePadding()
    }
}
