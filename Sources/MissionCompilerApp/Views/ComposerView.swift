import SwiftUI

struct ComposerView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        VStack(spacing: 10) {
            TextEditor(text: $store.draftText)
                .font(.body)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 58, maxHeight: 92)
                .padding(9)
                .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.separator.opacity(0.6), lineWidth: 1)
                }

            HStack(spacing: 10) {
                TextField("不可改变的条件（可选）", text: $store.constraintsText)
                    .textFieldStyle(.roundedBorder)

                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Spacer()

                Button("生成执行方案") {
                    store.compileDraft()
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.regularMaterial)
    }
}
