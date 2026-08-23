import SwiftUI

struct ContentView: View {
    @ObservedObject var store: AppStore
    @State private var showInspector = false

    var body: some View {
        NavigationSplitView {
            SidebarView(store: store)
                .navigationSplitViewColumnWidth(min: 220, ideal: 248, max: 300)
        } detail: {
            ProposalWorkspaceView(store: store)
        }
        .inspector(isPresented: $showInspector) {
            InspectorView(store: store)
                .frame(minWidth: 260, idealWidth: 288)
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showInspector.toggle()
                } label: {
                    Label("技术详情", systemImage: "sidebar.trailing")
                }

                Button {
                    store.newTask()
                } label: {
                    Label("新建任务", systemImage: "square.and.pencil")
                }
            }
        }
    }
}
