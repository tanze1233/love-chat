import PhotosUI
import SwiftUI
import UIKit

struct ChatInputBar: View {
    @Binding var text: String
    @Binding var isRecordingVoice: Bool

    let onSendText: () -> Void
    let onSendImage: (UIImage) -> Void
    let onVoiceGestureChanged: () -> Void
    let onVoiceGestureEnded: () -> Void

    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 10) {
            if isRecordingVoice {
                recordingBanner
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            HStack(spacing: 10) {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    toolbarButton(systemName: "photo.on.rectangle.angled", tint: LoveTheme.lavender)
                }
                .onChange(of: selectedPhotoItem) { newItem in
                    Task { await loadSelectedImage(from: newItem) }
                }

                TextField("给 TA 发点甜甜的话…", text: $text, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .foregroundStyle(LoveTheme.plum)

                Button(action: onSendText) {
                    Image(systemName: "paperplane.fill")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(canSendText ? AnyShapeStyle(LoveTheme.myBubble) : AnyShapeStyle(Color.gray.opacity(0.35)), in: Circle())
                }
                .disabled(!canSendText)

                voiceButton
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial.opacity(0.85))
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: isRecordingVoice)
    }

    private var canSendText: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var voiceButton: some View {
        toolbarButton(systemName: isRecordingVoice ? "mic.fill" : "mic", tint: isRecordingVoice ? LoveTheme.rose : LoveTheme.plum)
            .scaleEffect(isRecordingVoice ? 1.08 : 1)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onVoiceGestureChanged() }
                    .onEnded { _ in onVoiceGestureEnded() }
            )
            .accessibilityLabel("按住发送语音")
    }

    private var recordingBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "waveform")
            Text("松开发送语音消息")
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(LoveTheme.myBubble, in: Capsule())
        .shadow(color: LoveTheme.rose.opacity(0.25), radius: 12, y: 6)
    }

    private func toolbarButton(systemName: String, tint: Color) -> some View {
        Image(systemName: systemName)
            .font(.headline.weight(.semibold))
            .foregroundStyle(tint)
            .frame(width: 42, height: 42)
            .background(.white.opacity(0.72), in: Circle())
            .shadow(color: LoveTheme.plum.opacity(0.08), radius: 7, y: 3)
    }

    @MainActor
    private func loadSelectedImage(from item: PhotosPickerItem?) async {
        guard let item else { return }
        defer { selectedPhotoItem = nil }

        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else { return }
            onSendImage(image)
        } catch {
            // Frontend-only prototype: production error UI can be added with the backend layer.
        }
    }
}
