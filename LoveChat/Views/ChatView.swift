import SwiftUI
import UIKit

struct ChatView: View {
    @State private var messages = ChatMessage.previewMessages
    @State private var draftText = ""
    @State private var isRecordingVoice = false
    @State private var recordingStartDate: Date?

    var body: some View {
        ZStack {
            LoveTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ChatHeaderView()

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(messages) { message in
                                MessageRowView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: messages.count) { _ in
                        guard let lastID = messages.last?.id else { return }
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }

                ChatInputBar(
                    text: $draftText,
                    isRecordingVoice: $isRecordingVoice,
                    onSendText: sendTextMessage,
                    onSendImage: sendImageMessage,
                    onVoiceGestureChanged: handleVoiceGestureChanged,
                    onVoiceGestureEnded: handleVoiceGestureEnded
                )
            }
        }
    }

    private func sendTextMessage() {
        let trimmedText = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        messages.append(ChatMessage(sender: .me, content: .text(trimmedText)))
        draftText = ""
    }

    private func sendImageMessage(_ image: UIImage) {
        messages.append(ChatMessage(sender: .me, content: .image(image)))
    }

    private func handleVoiceGestureChanged() {
        if !isRecordingVoice {
            isRecordingVoice = true
            recordingStartDate = Date()
        }
    }

    private func handleVoiceGestureEnded() {
        guard isRecordingVoice else { return }
        let duration = max(1, Date().timeIntervalSince(recordingStartDate ?? Date()))
        messages.append(ChatMessage(sender: .me, content: .voice(duration: duration)))
        isRecordingVoice = false
        recordingStartDate = nil
    }
}

private struct ChatHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LoveTheme.myBubble)
                Text("❤")
                    .font(.title3)
            }
            .frame(width: 44, height: 44)
            .shadow(color: LoveTheme.rose.opacity(0.3), radius: 10, y: 6)

            VStack(alignment: .leading, spacing: 3) {
                Text("Only Us")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(LoveTheme.plum)
                Text("两个人的粉紫小宇宙")
                    .font(.caption)
                    .foregroundStyle(LoveTheme.plum.opacity(0.7))
            }

            Spacer()

            Image(systemName: "sparkles")
                .font(.title3.weight(.semibold))
                .foregroundStyle(LoveTheme.rose)
                .padding(10)
                .background(.white.opacity(0.55), in: Circle())
        }
        .padding(.horizontal, 18)
        .padding(.top, 12)
        .padding(.bottom, 14)
        .background(.ultraThinMaterial.opacity(0.75))
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
