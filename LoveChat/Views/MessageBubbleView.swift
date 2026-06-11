import SwiftUI
import UIKit

struct MessageBubbleView: View {
    let message: ChatMessage

    var body: some View {
        VStack(alignment: message.isMine ? .trailing : .leading, spacing: 5) {
            content
                .padding(paddingForContent)
                .background(bubbleBackground, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(alignment: message.isMine ? .bottomTrailing : .bottomLeading) {
                    BubbleTail(isMine: message.isMine)
                        .fill(message.isMine ? AnyShapeStyle(LoveTheme.myBubble) : AnyShapeStyle(LoveTheme.partnerBubble))
                        .frame(width: 16, height: 14)
                        .offset(x: message.isMine ? 5 : -5, y: 2)
                }
                .shadow(color: LoveTheme.plum.opacity(message.isMine ? 0.18 : 0.08), radius: 10, y: 5)

            Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .foregroundStyle(LoveTheme.plum.opacity(0.48))
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: 270, alignment: message.isMine ? .trailing : .leading)
    }

    @ViewBuilder
    private var content: some View {
        switch message.content {
        case .text(let text):
            Text(text)
                .font(.body)
                .foregroundStyle(message.isMine ? .white : LoveTheme.plum)
                .fixedSize(horizontal: false, vertical: true)
        case .image(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 210, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "photo.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(7)
                        .background(.black.opacity(0.28), in: Circle())
                        .padding(8)
                }
        case .voice(let duration):
            VoiceMessageView(duration: duration, isMine: message.isMine)
        }
    }

    private var bubbleBackground: some ShapeStyle {
        message.isMine ? AnyShapeStyle(LoveTheme.myBubble) : AnyShapeStyle(LoveTheme.partnerBubble)
    }

    private var paddingForContent: EdgeInsets {
        switch message.content {
        case .image:
            return EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        default:
            return EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15)
        }
    }
}

private struct VoiceMessageView: View {
    let duration: TimeInterval
    let isMine: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isMine ? "waveform.circle.fill" : "play.circle.fill")
                .font(.title3.weight(.semibold))
            HStack(spacing: 3) {
                ForEach(0..<12, id: \.self) { index in
                    Capsule()
                        .frame(width: 3, height: CGFloat([8, 15, 11, 22, 13, 18, 10, 24, 16, 12, 20, 9][index]))
                        .opacity(0.55 + Double(index % 3) * 0.15)
                }
            }
            Text("\(Int(duration.rounded()))\" ")
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(isMine ? .white : LoveTheme.plum)
        .frame(minWidth: 150, alignment: .leading)
    }
}

private struct BubbleTail: Shape {
    let isMine: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if isMine {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        path.closeSubpath()
        return path
    }
}
