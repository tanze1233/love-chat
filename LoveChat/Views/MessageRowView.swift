import SwiftUI

struct MessageRowView: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isMine { Spacer(minLength: 42) }

            if !message.isMine {
                avatar(symbol: "moon.stars.fill")
            }

            MessageBubbleView(message: message)

            if message.isMine {
                avatar(symbol: "heart.fill")
            }

            if !message.isMine { Spacer(minLength: 42) }
        }
    }

    private func avatar(symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.caption.weight(.bold))
            .foregroundStyle(message.isMine ? .white : LoveTheme.plum)
            .frame(width: 30, height: 30)
            .background(message.isMine ? AnyShapeStyle(LoveTheme.myBubble) : AnyShapeStyle(.white.opacity(0.78)), in: Circle())
            .shadow(color: LoveTheme.plum.opacity(0.12), radius: 8, y: 4)
    }
}
